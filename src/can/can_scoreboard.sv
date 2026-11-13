
`uvm_analysis_imp_decl(_apb_active)
`uvm_analysis_imp_decl(_apb_passive)
`uvm_analysis_imp_decl(_can_active)
`uvm_analysis_imp_decl(_can_passive)

class can_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(can_scoreboard)

  uvm_analysis_imp_apb_active #(apb_sequence_item, can_scoreboard) apb_active_imp;
  uvm_analysis_imp_apb_passive #(apb_sequence_item, can_scoreboard) apb_passive_imp;
  uvm_analysis_imp_can_active #(can_sequence_item, can_scoreboard) can_active_imp;
  uvm_analysis_imp_can_passive #(can_sequence_item, can_scoreboard) can_passive_imp;

  localparam bit [11:0] TX_ID_ADDR = 12'h030;
  localparam bit [11:0] TX_DLC_ADDR = 12'h034;
  localparam bit [11:0] TX_DW1_ADDR = 12'h038;
  localparam bit [11:0] TX_DW2_ADDR = 12'h03C;

  localparam bit [11:0] RX_ID_ADDR = 12'h050;
  localparam bit [11:0] RX_DLC_ADDR = 12'h054;
  localparam bit [11:0] RX_DW1_ADDR = 12'h058;
  localparam bit [11:0] RX_DW2_ADDR = 12'h05C;

  can_sequence_item expected_can_q[$];
  can_sequence_item expected_rx_q[$];

  bit [31:0] tx_id;
  bit [31:0] tx_dlc;
  bit [31:0] tx_dw1;
  bit [31:0] tx_dw2;

  bit tx_id_valid;
  bit tx_dlc_valid;
  bit tx_dw1_valid;

  bit [31:0] rx_id;
  bit [31:0] rx_dlc;
  bit [31:0] rx_dw1;
  bit [31:0] rx_dw2;

  bit rx_id_valid;
  bit rx_dlc_valid;
  bit rx_dw1_valid;
  bit rx_dw2_valid;

  int pass_count;
  int error_count;


  function new(string name = "can_scoreboard",uvm_component parent = null);
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_active_imp  = new("apb_active_imp", this);
    apb_passive_imp = new("apb_passive_imp", this);
    can_active_imp  = new("can_active_imp", this);
    can_passive_imp = new("can_passive_imp", this);
  endfunction


  // ---------------------------------------------------------
  // CRC-15 CAN calculation
  // ---------------------------------------------------------

  function automatic bit [14:0] crc_next( input bit [14:0] crc,input bit data_bit);

  bit fb;
  bit [14:0] crc_new;

  fb = data_bit ^ crc[14];

  crc_new[0] = fb;
  crc_new[1] = crc[0];
  crc_new[2] = crc[1];
  crc_new[3] = crc[2] ^ fb;
  crc_new[4] = crc[3] ^ fb;
  crc_new[5] = crc[4];
  crc_new[6] = crc[5];
  crc_new[7] = crc[6] ^ fb;
  crc_new[8] = crc[7] ^ fb;
  crc_new[9] = crc[8];
  crc_new[10] = crc[9] ^ fb;
  crc_new[11] = crc[10];
  crc_new[12] = crc[11];
  crc_new[13] = crc[12];
  crc_new[14] = crc[13] ^ fb;

  return crc_new;
endfunction

  function automatic bit [14:0] calculate_can_crc( input can_sequence_item tr);

  bit [14:0] crc;

  crc = 15'h0000;

  // SOF
  crc = crc_next(crc, 1'b0);

  // Base identifier
  for (int i = 10; i >= 0; i--)
    crc = crc_next(crc, tr.id_base[i]);

  if (tr.ide) begin

    // SRR and IDE
    crc = crc_next(crc, 1'b1);
    crc = crc_next(crc, 1'b1);

    // Extended identifier
    for (int i = 17; i >= 0; i--)
      crc = crc_next(crc, tr.id_ext[i]);

    // RTR and reserved bits
    crc = crc_next(crc, tr.rtr);
    crc = crc_next(crc, 1'b0);
    crc = crc_next(crc, 1'b0);

  end
  else begin

    // RTR, IDE and reserved bit
    crc = crc_next(crc, tr.rtr);
    crc = crc_next(crc, 1'b0);
    crc = crc_next(crc, 1'b0);

  end

  // DLC
  for (int i = 3; i >= 0; i--)
    crc = crc_next(crc, tr.dlc[i]);

  // Data field
  if (!tr.rtr) begin
    for (int i = 0; i < tr.data.size(); i++) begin
      for (int j = 7; j >= 0; j--)
        crc = crc_next(crc, tr.data[i][j]);
    end
  end

  return crc;

endfunction

  // ---------------------------------------------------------
  // Check errors reported by CAN monitor
  // ---------------------------------------------------------

  function bit check_monitor_errors(can_sequence_item tr, string direction );

    bit frame_error;

    frame_error = 0;

    if (tr.stuff_error) begin
      `uvm_error("CAN_SB", $sformatf("%s: CAN stuffing error detected", direction))
      frame_error = 1;
    end

    if (tr.form_error) begin
      `uvm_error("CAN_SB", $sformatf("%s: CAN form error detected", direction))
      frame_error = 1;
    end

    if (tr.ack_error) begin
      `uvm_error("CAN_SB", $sformatf("%s: CAN ACK error detected", direction))
      frame_error = 1;
    end

    if (tr.bit_error) begin
      `uvm_error("CAN_SB", $sformatf("%s: CAN bit error detected", direction))
      frame_error = 1;
    end

    if (tr.crc_error) begin
      `uvm_error("CAN_SB",$sformatf("%s: CAN CRC error flag is set", direction))
      frame_error = 1;
    end

    return frame_error;

  endfunction


  // ---------------------------------------------------------
  // APB active monitor
  // Collect DUT TX register writes
  // ---------------------------------------------------------

  function void write_apb_active(apb_sequence_item tr);

    if (!(tr.psel && tr.penable && tr.pready && tr.pwrite && !tr.pslverr))
      return;

    case (tr.paddr)

      TX_ID_ADDR: begin
        tx_id = tr.pwdata;
        tx_id_valid = 1;
      end

      TX_DLC_ADDR: begin
        tx_dlc = tr.pwdata;
        tx_dlc_valid = 1;
      end

      TX_DW1_ADDR: begin
        tx_dw1 = tr.pwdata;
        tx_dw1_valid = 1;
      end

      TX_DW2_ADDR: begin
        tx_dw2 = tr.pwdata;

        if (tx_id_valid && tx_dlc_valid && tx_dw1_valid) begin  //becuase writing to dw2 is triggering the frame so all other detail need to be written before the dw2

          create_expected_can( tx_id, tx_dlc,tx_dw1,tx_dw2);
          tx_id_valid  = 0;
          tx_dlc_valid = 0;
          tx_dw1_valid = 0;

        end
        else begin
          `uvm_warning("CAN_SB", "TX_DW2 written before TX_ID, TX_DLC and TX_DW1 were observed")
        end
      end

      default: begin
      end

    endcase

  endfunction


  // ---------------------------------------------------------
  // Create expected DUT TX frame from APB writes
  // ---------------------------------------------------------

  function void create_expected_can(bit [31:0] id_word,bit [31:0] dlc_word,bit [31:0] dw1_word,bit [31:0] dw2_word);

    can_sequence_item expected;
    int byte_count;

    expected = can_sequence_item::type_id::create("expected_can");

    expected.operation = DRIVE_FRAME;

    expected.id_base = id_word[31:21];
    expected.ide = id_word[19];
    expected.id_ext  = id_word[18:1];
    expected.rtr  = id_word[0];

    expected.dlc = dlc_word[3:0];

    if (expected.dlc > 8) begin
      `uvm_error("CAN_SB",  $sformatf("Invalid TX DLC value: %0d", expected.dlc))
      error_count++;
      return;
    end

    byte_count = expected.dlc;

    if (expected.rtr)
      byte_count = 0;

    expected.data = new[byte_count];

    for (int i = 0; i < byte_count; i++) begin

      if (i < 4)
        expected.data[i] = dw1_word[i*8 +: 8];
      else
        expected.data[i] = dw2_word[(i-4)*8 +: 8];

    end

    expected_can_q.push_back(expected);

    `uvm_info("CAN_SB",$sformatf( "Expected DUT TX frame queued: IDE=%0b ID_BASE=%03h ID_EXT=%05h RTR=%0b DLC=%0d",expected.ide, expected.id_base, expected.id_ext, expected.rtr,  expected.dlc),UVM_MEDIUM)

  endfunction


  // ---------------------------------------------------------
  // CAN passive monitor
  // Observes frames transmitted by DUT
  // ---------------------------------------------------------

  function void write_can_passive(can_sequence_item tr);

    can_sequence_item expected;

    if (expected_can_q.size() == 0) begin
      `uvm_error("CAN_SB", "DUT transmitted a CAN frame, but no expected frame is queued")
      error_count++;
      return;
    end

    expected = expected_can_q.pop_front();

    compare_can_frames(expected,tr, "DUT_TX",1'b1);

  endfunction


  // ---------------------------------------------------------
  // CAN active monitor
  // Observes frames transmitted by testbench to DUT
  // ---------------------------------------------------------

  function void write_can_active(can_sequence_item tr);

    can_sequence_item expected;
    bit frame_error;
    bit [14:0] calculated_crc;

    frame_error = check_monitor_errors(tr, "CAN input");

    // Validate CRC of the CAN frame sent from tb
    calculated_crc = calculate_can_crc(tr);

    if (calculated_crc !== tr.crc) begin
      `uvm_error("CAN_SB", $sformatf("CAN input CRC mismatch: calculated=0x%04h received=0x%04h",calculated_crc,tr.crc ))  //tr.crc is recived ffrom the monitor
      frame_error = 1;
    end

    if (frame_error) begin
      error_count++;
      return;
    end

    expected = can_sequence_item::type_id::create("expected_rx");  //Create a new CAN transaction so it can be used to store the items recived from the active monitor

    expected.copy(tr); //Copy the frame captured by the CAN active monitor into it. , copy is used becuase when monitor recives other trnasaction so it should not override the actully stored one so

    expected_rx_q.push_back(expected); //Store that independent copy in the expected RX queue for later comparison with APB read data.

    `uvm_info("CAN_SB", $sformatf(  "Expected DUT RX frame queued: IDE=%0b ID_BASE=%03h ID_EXT=%05h RTR=%0b DLC=%0d",    tr.ide,  tr.id_base,tr.id_ext, tr.rtr, tr.dlc),  UVM_MEDIUM)

  endfunction


  // ---------------------------------------------------------
  // APB passive monitor
  // Collect DUT output when can trasamitted
  // ---------------------------------------------------------

  function void write_apb_passive(apb_sequence_item tr);

    can_sequence_item expected;
    can_sequence_item observed;

    int byte_count;

    if (!(tr.psel && tr.penable && tr.pready && !tr.pwrite && !tr.pslverr))
      return;

    case (tr.paddr)

      RX_ID_ADDR: begin
        rx_id = tr.prdata;
        rx_id_valid = 1;
      end

      RX_DLC_ADDR: begin
        rx_dlc = tr.prdata;
        rx_dlc_valid = 1;
      end

      RX_DW1_ADDR: begin
        rx_dw1 = tr.prdata;
        rx_dw1_valid = 1;
      end

      RX_DW2_ADDR: begin
        rx_dw2 = tr.prdata;
        rx_dw2_valid = 1;
      end

      default: begin
      end

    endcase

    if (rx_id_valid && rx_dlc_valid && rx_dw1_valid && rx_dw2_valid) begin
      if (expected_rx_q.size() == 0) begin
        `uvm_error("CAN_SB", "APB read returned RX data, but no expected CAN RX frame is queued")
        error_count++;
      end
      else begin

        expected = expected_rx_q.pop_front();  //can active monitor

        observed = can_sequence_item::type_id::create("observed_rx");

        observed.operation = DRIVE_FRAME;

        observed.id_base = rx_id[31:21];
        observed.ide  = rx_id[19];
        observed.id_ext  = rx_id[18:1];
        observed.rtr = rx_id[0];

        observed.dlc = rx_dlc[31:28];

        if (observed.dlc > 8) begin

          `uvm_error("CAN_SB", $sformatf("Invalid RX DLC value read from APB: %0d", observed.dlc))
          error_count++;

        end
        else begin

          byte_count = observed.dlc;

          if (observed.rtr)
            byte_count = 0;

          observed.data = new[byte_count];

          for (int i = 0; i < byte_count; i++) begin

            if (i < 4)
              observed.data[i] = rx_dw1[i*8 +: 8];
            else
              observed.data[i] = rx_dw2[(i-4)*8 +: 8];

          end

          compare_can_frames(expected, observed, "DUT_RX", 1'b0 );
        end
      end

      rx_id_valid  = 0;
      rx_dlc_valid = 0;
      rx_dw1_valid = 0;
      rx_dw2_valid = 0;

    end
  endfunction


  // ---------------------------------------------------------
  // Compare expected and observed CAN frames
  // check_crc = 1 for DUT TX passive monitor comparison
  // check_crc = 0 for DUT RX APB register comparison
  // ---------------------------------------------------------

  function void compare_can_frames( can_sequence_item expected, can_sequence_item observed, string direction, bit check_crc);

    bit mismatch;
    bit monitor_error;

    bit [14:0] calculated_crc;

    mismatch = 0;

    // Check monitor error flags
    monitor_error = check_monitor_errors(observed, direction);

    if (monitor_error)
      mismatch = 1;

    // IDE
    if (expected.ide !== observed.ide) begin
      `uvm_error("CAN_SB", $sformatf("%s IDE mismatch: expected=%0b observed=%0b",direction, expected.ide, observed.ide))
      mismatch = 1;
    end

    // RTR
    if (expected.rtr !== observed.rtr) begin
      `uvm_error("CAN_SB", $sformatf( "%s RTR mismatch: expected=%0b observed=%0b", direction, expected.rtr, observed.rtr))
      mismatch = 1;
    end

    // Base identifier
    if (expected.id_base !== observed.id_base) begin
      `uvm_error("CAN_SB", $sformatf( "%s base ID mismatch: expected=%03h observed=%03h", direction, expected.id_base, observed.id_base))
      mismatch = 1;
    end

    // Extended identifier
    if (expected.ide &&
        expected.id_ext !== observed.id_ext) begin
      `uvm_error("CAN_SB", $sformatf("%s extended ID mismatch: expected=%05h observed=%05h",direction, expected.id_ext, observed.id_ext))
      mismatch = 1;
    end

    // DLC
    if (expected.dlc !== observed.dlc) begin
      `uvm_error("CAN_SB",
        $sformatf( "%s DLC mismatch: expected=%0d observed=%0d", direction, expected.dlc, observed.dlc))
      mismatch = 1;
    end

    // Payload
    if (!expected.rtr) begin

      if (expected.data.size() != observed.data.size()) begin

        `uvm_error("CAN_SB", $sformatf( "%s payload size mismatch: expected=%0d observed=%0d", direction, expected.data.size(), observed.data.size()))
        mismatch = 1;

      end
      else begin

        for (int i = 0; i < expected.data.size(); i++) begin

          if (expected.data[i] !== observed.data[i]) begin

            `uvm_error("CAN_SB", $sformatf( "%s payload mismatch at byte %0d: expected=%02h observed=%02h", direction, i, expected.data[i], observed.data[i] ))

            mismatch = 1;

          end
        end
      end
    end

    // CRC validation for observed CAN bus frame
    if (check_crc) begin

      calculated_crc = calculate_can_crc(expected);

      if (calculated_crc !== observed.crc) begin

        `uvm_error("CAN_SB",$sformatf(  "%s CRC mismatch: calculated=0x%04h observed=0x%04h",  direction,  calculated_crc,  observed.crc))

        mismatch = 1;

      end
    end
    
    // Final result
    if (mismatch) begin
      error_count++;

    end
    else begin
      pass_count++;

      `uvm_info("CAN_SB", $sformatf("%s frame matched successfully", direction), UVM_MEDIUM)
    end

  endfunction


  // ---------------------------------------------------------
  // Report phase
  // ---------------------------------------------------------

  function void report_phase(uvm_phase phase);

    super.report_phase(phase);

    `uvm_info("CAN_SB",
      $sformatf( "Scoreboard summary: PASS=%0d ERROR=%0d Expected TX frames remaining=%0d Expected RX frames remaining=%0d", pass_count,  error_count, expected_can_q.size(),  expected_rx_q.size()), UVM_NONE)

    if (expected_can_q.size() != 0)
      `uvm_error("CAN_SB", "some expected DUT TX frames were never observed")

    if (expected_rx_q.size() != 0)
      `uvm_error("CAN_SB", "some expected DUT RX frames were never checked through APB reads")

  endfunction

endclass

