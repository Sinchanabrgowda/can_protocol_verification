class can_driver extends uvm_driver #(can_sequence_item);

  `uvm_component_utils(can_driver)

  virtual can_interface vif;
  can_timing_config timing_cfg;

  bit crc_bits[$]; //to store the crc
  bit rx_replay_bits[$]; //to store the bits already sampled during arbitration, if it loses then it can continue from the next bits

  bit rx_first_live_after_replay;
  bit rx_previous_bit; //for stuffing
  int unsigned rx_same_count; //for stuffing
  bit frame_valid;

  bit tx_bits[$];
  bit tx_stuffed_bits[$];
  bit tx_arbitration_flags[$];

  function new(
    string name = "can_driver",
    uvm_component parent = null
  );
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual can_interface)::get(
          this, "", "vif", vif))
      `uvm_fatal("CAN_DRV", "CAN interface not found")

    if (!uvm_config_db#(can_timing_config)::get(
          this, "", "timing_cfg", timing_cfg))
      `uvm_fatal("CAN_DRV", "CAN timing configuration not found")
  endfunction

  task wait_clocks(int unsigned count);
    repeat (count)
      @(posedge vif.can_clk);
  endtask

  task sample_next_raw_bit(output bit value);
    if (rx_replay_bits.size() != 0) begin
      value = rx_replay_bits.pop_front();
    end
    else begin
      if (rx_first_live_after_replay) begin
        wait_clocks(timing_cfg.sample_point_cycles);
        rx_first_live_after_replay = 1'b0;
      end
      else begin
        wait_clocks(timing_cfg.clocks_per_bit);
      end
      value = vif.can_bus;
    end
  endtask

  task wait_for_sof(output bit sof);
    sof = 1'b1;

    wait (vif.can_bus === 1'b1);
    @(negedge vif.can_bus);

    wait_clocks(timing_cfg.sample_point_cycles);
    sof = vif.can_bus;

    if (sof !== 1'b0) begin //drive sof
      frame_valid = 0;
      `uvm_error("CAN_DRV", "Invalid SOF")
    end
  endtask

  task get_destuffed_bit(output bit value);
  bit stuff_bit;

  if (rx_same_count == 5) begin
    sample_next_raw_bit(stuff_bit);

    if (stuff_bit === rx_previous_bit) begin
      frame_valid = 0;
      `uvm_error("CAN_DRV", "CAN stuffing error detected")
    end

    rx_same_count = 0;
  end

  sample_next_raw_bit(value);

  if (rx_same_count == 0) begin
    rx_previous_bit = value;
    rx_same_count = 1; // start count =1 becuase a new bit started
  end
    else if (value === rx_previous_bit)  // next bit is mathcing then icnrease count
    rx_same_count++;
  else begin
    rx_previous_bit = value; // if not then start the count from the current bit again
    rx_same_count = 1;
  end
endtask
    

  task read_rx_field(
    input int unsigned width,
    output longint unsigned value,
    input bit include_in_crc
  );
    bit sampled_bit;

    value = 0;

    for (int unsigned i = 0; i < width; i++) begin
      get_destuffed_bit(sampled_bit);
      value = (value << 1) | sampled_bit;  // value shld be shifted to lhs and add the next bit to this (reduction or)

      if (include_in_crc)
        crc_bits.push_back(sampled_bit);
    end
  endtask

  function bit [14:0] calculate_crc();
    bit [14:0] crc;
    bit [14:0] crc_new;
    bit fb;

    crc = 15'b0;

    foreach (crc_bits[i]) begin
      fb = crc_bits[i] ^ crc[14];

      crc_new[0]  = fb;
      crc_new[1]  = crc[0];
      crc_new[2]  = crc[1];
      crc_new[3]  = crc[2] ^ fb;
      crc_new[4]  = crc[3] ^ fb;
      crc_new[5]  = crc[4];
      crc_new[6]  = crc[5] ^ fb;
      crc_new[7]  = crc[6] ^ fb;
      crc_new[8]  = crc[7] ^ fb;
      crc_new[9]  = crc[8];
      crc_new[10] = crc[9] ^ fb;
      crc_new[11] = crc[10];
      crc_new[12] = crc[11];
      crc_new[13] = crc[12];
      crc_new[14] = crc[13] ^ fb;

      crc = crc_new;
    end

    return crc;
  endfunction

  task drive_ack_slot();
    wait_clocks(
      timing_cfg.clocks_per_bit -
      timing_cfg.sample_point_cycles
    );

    @(negedge vif.can_clk);
    vif.ext_tx = 1'b0;  //ack

    repeat (timing_cfg.clocks_per_bit)
      @(negedge vif.can_clk);

    vif.ext_tx = 1'b1;
  endtask

  task check_ack_delimiter_and_eof();
    bit sampled_bit;

    sample_next_raw_bit(sampled_bit);  //ack delm

    if (sampled_bit !== 1'b1)
      `uvm_error("CAN_DRV", "Invalid ACK delimiter")

    for (int unsigned i = 0; i < 7; i++) begin
      sample_next_raw_bit(sampled_bit); //eof

      if (sampled_bit !== 1'b1)
        `uvm_error("CAN_DRV", "Invalid EOF bit")
    end

    for (int unsigned i = 0; i < 3; i++) begin
      sample_next_raw_bit(sampled_bit);  //ifs

      if (sampled_bit !== 1'b1)
        `uvm_error("CAN_DRV", "Intermission bit is not recessive")
    end
  endtask

  task check_error_flag_and_delimiter();
    bit sampled_bit;

    vif.ext_tx = 1'b1;

    for (int unsigned i = 0; i < 6; i++) begin
      sample_next_raw_bit(sampled_bit);  //error_flag bits

      if (sampled_bit !== 1'b0)
        `uvm_error(
          "CAN_DRV",
          $sformatf(
            "Expected dominant error-flag bit %0d, sampled %0b",
            i,
            sampled_bit
          )
        )
    end

    for (int unsigned i = 0; i < 8; i++) begin
      sample_next_raw_bit(sampled_bit);  //error_delim

      if (sampled_bit !== 1'b1)
        `uvm_error(
          "CAN_DRV",
          $sformatf(
            "Expected recessive error-delimiter bit %0d, sampled %0b",
            i,
            sampled_bit
          )
        )
    end

    for (int unsigned i = 0; i < 3; i++) begin
      sample_next_raw_bit(sampled_bit); //error ifs

      if (sampled_bit !== 1'b1)
        `uvm_error(
          "CAN_DRV",
          $sformatf(
            "Expected recessive intermission bit %0d, sampled %0b",
            i,
            sampled_bit
          )
        )
    end

    `uvm_info(
      "CAN_DRV",
      "DUT error flag, error delimiter and intermission checked",
      UVM_MEDIUM
    )
  endtask

  task decode_frame_from_sof(
    can_sequence_item req,
    input bit sof
  );
    bit sampled_bit;
    bit first_after_base;
    bit received_ide;
    bit received_rtr;
    bit reserved_bit;

    bit [14:0] received_crc;
    bit [14:0] expected_crc;

    longint unsigned field_value;

    int unsigned received_dlc;
    int unsigned payload_bytes;

    crc_bits.delete();

    frame_valid = 1;
    crc_bits.push_back(sof);

    rx_previous_bit = sof;  //sof
    rx_same_count = 1;

      read_rx_field(11, field_value, 1);  //base id
    req.id_base = field_value[10:0];

    get_destuffed_bit(first_after_base);
    crc_bits.push_back(first_after_base);

    get_destuffed_bit(received_ide);
    crc_bits.push_back(received_ide);
    req.ide = received_ide;   //ide

    if (received_ide) begin
      if (first_after_base !== 1'b1) begin  //extd srr
        frame_valid = 0;
        `uvm_error("CAN_DRV", "Invalid SRR bit")
      end

      read_rx_field(18, field_value, 1); //ext frame id
      req.id_ext = field_value[17:0];

      read_rx_field(1, field_value, 1);  //ext_frame rtr
      received_rtr = field_value[0];

      read_rx_field(1, field_value, 1);    //ext frame r1

      if (field_value[0] !== 1'b0) begin
        frame_valid = 0;
        `uvm_error("CAN_DRV", "Invalid extended r1 bit")
      end

      read_rx_field(1, field_value, 1);  //ext frame r0

      if (field_value[0] !== 1'b0) begin
        frame_valid = 0;
        `uvm_error("CAN_DRV", "Invalid extended r0 bit")
      end
    end
    else begin
      received_rtr = first_after_base;

      read_rx_field(1, field_value, 1);  //std frame r0
      reserved_bit = field_value[0];

      if (reserved_bit !== 1'b0) begin
        frame_valid = 0;
        `uvm_error("CAN_DRV", "Invalid standard r0 bit")
      end
    end

    req.rtr = received_rtr;   //rtr

      read_rx_field(4, field_value, 1);  //dlc
    received_dlc = field_value[3:0];
    req.dlc = received_dlc;

    if (received_dlc > 8) begin
      frame_valid = 0;
      `uvm_error(
        "CAN_DRV",
        $sformatf("Unsupported DLC value: %0d", received_dlc)
      )
    end

    payload_bytes = (received_dlc > 8) ? 8 : received_dlc;

    if (!received_rtr) begin
      req.data = new[payload_bytes];

      for (int unsigned i = 0; i < payload_bytes; i++) begin
        read_rx_field(8, field_value, 1);  //payload
        req.data[i] = field_value[7:0];
      end
    end
    else begin
      req.data = new[0];  //if rtr then no paylaod so 0
    end

      read_rx_field(15, field_value, 0); //crc
    received_crc = field_value[14:0];

    expected_crc = calculate_crc();

    if (received_crc !== expected_crc) begin
      frame_valid = 0;

      `uvm_error(
        "CAN_DRV",
        $sformatf(
          "CRC mismatch: received=0x%04h expected=0x%04h",
          received_crc,
          expected_crc
        )
      )
    end
    else begin
      `uvm_info(
        "CAN_DRV",
        $sformatf("CRC matched: 0x%04h", received_crc),
        UVM_MEDIUM
      )
    end
 
      sample_next_raw_bit(sampled_bit);  //crc delim

    if (sampled_bit !== 1'b1) begin
      frame_valid = 0;
      `uvm_error("CAN_DRV", "Invalid CRC delimiter")
    end

    if (frame_valid && !req.ack_error) begin
      drive_ack_slot();  //go to ack drive if recived properly

      `uvm_info(
        "CAN_DRV",
        $sformatf(
          "ACK sent: IDE=%0b RTR=%0b ID_BASE=0x%03h DLC=%0d",
          req.ide,
          req.rtr,
          req.id_base,
          req.dlc
        ),
        UVM_MEDIUM
      )

      check_ack_delimiter_and_eof();  //if ack go to this
    end
    else begin
      vif.ext_tx = 1'b1;

      `uvm_warning(
        "CAN_DRV",
        "Frame not acknowledged: checking DUT error response"
      )

      check_error_flag_and_delimiter(); //if err go to this
    end
  endtask

  task receive_and_ack(can_sequence_item req);
    bit sof;

    rx_replay_bits.delete();
    rx_first_live_after_replay = 1'b0;
    crc_bits.delete();

    frame_valid = 1;
    rx_previous_bit = 0;
    rx_same_count = 1;

    vif.ext_tx = 1'b1; //release the bus

    wait_for_sof(sof); //sof  =0 

    if (sof !== 1'b0)
      return;

    decode_frame_from_sof(req, sof);  //recive the frame 
  endtask

  task receive_after_arbitration_loss(can_sequence_item req);
    bit sof;

    if (rx_replay_bits.size() == 0) begin
      `uvm_error(
        "CAN_DRV",
        "No buffered bus bits available after arbitration loss"
      )
      return;
    end

    crc_bits.delete();
    frame_valid = 1'b1;
    rx_previous_bit = 1'b0;
    rx_same_count = 1;

    // The first buffered sample is the SOF. Consume it as the decoder's
    // starting bit; 
    sof = rx_replay_bits.pop_front();

    if (sof !== 1'b0) begin
      `uvm_error(
        "CAN_DRV",
        "Buffered frame does not start with a dominant SOF"
      )
      rx_replay_bits.delete();
      rx_first_live_after_replay = 1'b0;
      vif.ext_tx = 1'b1;
      return;
    end

    // The losing node releases the bus. The current bit period has already
    // been completed by drive_one_bit before this task is entered.
    vif.ext_tx = 1'b1;
    rx_first_live_after_replay = 1'b1;

    `uvm_info(
      "CAN_DRV",
      "Arbitration lost; reconstructing the sampled prefix and continuing at the next live bit",
      UVM_MEDIUM
    )

    decode_frame_from_sof(req, sof);

    rx_replay_bits.delete();
    rx_first_live_after_replay = 1'b0;
  endtask

  function void append_bits(
    ref bit bits[$],
    input longint unsigned value,
    input int unsigned width
  );
    for (int i = width - 1; i >= 0; i--)
      bits.push_back(value[i]);
  endfunction

  function bit [14:0] calculate_tx_crc();
    bit [14:0] crc;
    bit [14:0] crc_new;
    bit fb;

    crc = '0;

    foreach (tx_bits[i]) begin
      fb = tx_bits[i] ^ crc[14];

      crc_new[0]  = fb;
      crc_new[1]  = crc[0];
      crc_new[2]  = crc[1];
      crc_new[3]  = crc[2] ^ fb;
      crc_new[4]  = crc[3] ^ fb;
      crc_new[5]  = crc[4];
      crc_new[6]  = crc[5] ^ fb;
      crc_new[7]  = crc[6] ^ fb;
      crc_new[8]  = crc[7] ^ fb;
      crc_new[9]  = crc[8];
      crc_new[10] = crc[9] ^ fb;
      crc_new[11] = crc[10];
      crc_new[12] = crc[11];
      crc_new[13] = crc[12];
      crc_new[14] = crc[13] ^ fb;

      crc = crc_new;
    end

    return crc;
  endfunction

  function void build_tx_frame(can_sequence_item req);
    bit [14:0] crc;
    bit previous_bit;
    int unsigned same_count;
    int unsigned arbitration_end;

    tx_bits.delete();
    tx_stuffed_bits.delete();
    tx_arbitration_flags.delete();

    tx_bits.push_back(1'b0); //sof

    if (req.ide) begin //if ext frame
      append_bits(tx_bits, req.id_base, 11); //base id
      tx_bits.push_back(1'b1); //srr
      tx_bits.push_back(1'b1); //ide
      append_bits(tx_bits, req.id_ext, 18);  //ext_id
      tx_bits.push_back(req.rtr);  //rtr
      tx_bits.push_back(1'b0);  //r1
      tx_bits.push_back(1'b0); //r0

      arbitration_end = 32; //for ext frame
    end
    else begin
      append_bits(tx_bits, req.id_base, 11);  //std frame base id
      tx_bits.push_back(req.rtr); //rtr
      tx_bits.push_back(1'b0); //ide
      tx_bits.push_back(1'b0); //r0

      arbitration_end = 12;  //for std frame
    end

    append_bits(tx_bits, req.dlc, 4);  //dlc

    if (!req.rtr) begin
      for (int unsigned i = 0; i < req.dlc; i++)  //ddata
        append_bits(tx_bits, req.data[i], 8);
    end

    crc = calculate_tx_crc();
    append_bits(tx_bits, crc, 15);  //crc

    previous_bit = tx_bits[0]; //actual cna frame (sof  - bit 0)
    same_count = 1;

    tx_stuffed_bits.push_back(previous_bit); //after bit stuffing it stores into this from sof
    tx_arbitration_flags.push_back(1'b0); //arbitration flag for eahc bit , so fro sof 1'b0 means it is not there is arbitration it needs to start from the next

    for (int unsigned i = 1; i < tx_bits.size(); i++) begin
      if (same_count == 5) begin
        tx_stuffed_bits.push_back(~previous_bit);
        tx_arbitration_flags.push_back(1'b0);

        previous_bit = ~previous_bit;
        same_count = 1;
      end

      tx_stuffed_bits.push_back(tx_bits[i]); //pysh one by one to this
      tx_arbitration_flags.push_back(i <= arbitration_end); // if true check for arbitration

      if (tx_bits[i] == previous_bit)
        same_count++;
      else begin
        previous_bit = tx_bits[i];
        same_count = 1;
      end
    end
  endfunction

  task drive_one_bit(
    input bit value,
    input bit check_arbitration,
    output bit arbitration_lost
  );
    bit sampled_bus;

    arbitration_lost = 0; 
    vif.ext_tx = value;  // if arb not lost then drive vlaue on to ext_tx
 
    wait_clocks(timing_cfg.sample_point_cycles);
    sampled_bus = vif.can_bus;

    rx_replay_bits.push_back(sampled_bus);  // if arb lost then it needs these sampled bits so push it into

    if (check_arbitration && value && !sampled_bus) begin // check arb is to check if arb is going  , value is what we drivw, sampled bus is what is sampled (not of is it is opposite), if true then lost
      arbitration_lost = 1;
      vif.ext_tx = 1'b1;

      `uvm_info(
        "CAN_DRV",
        "Sent recessive bit but sampled dominant bit; arbitration lost; releasing the bus for the rest of this bit period",
        UVM_MEDIUM
      )
    end

    // Even after losing arbitration, finish the current bit period before
    // attempting to receive the next bit from the winning node.
    wait_clocks(
      timing_cfg.clocks_per_bit -
      timing_cfg.sample_point_cycles
    );

    @(negedge vif.can_clk);
  endtask

  task drive_one_non_arbitration_bit(input bit value);
    bit arbitration_lost;

    drive_one_bit(value, 1'b0, arbitration_lost);
  endtask

  task sample_ack_slot(output bit ack_received);
    bit sampled_bit;

    vif.ext_tx = 1'b1;

    wait_clocks(timing_cfg.sample_point_cycles);
    sampled_bit = vif.can_bus;

    ack_received = (sampled_bit === 1'b0); //ack

    wait_clocks(
      timing_cfg.clocks_per_bit -
      timing_cfg.sample_point_cycles
    );

    if (!ack_received)
      `uvm_error("CAN_DRV", "No ACK received from DUT")
    else
      `uvm_info("CAN_DRV", "DUT ACK received", UVM_MEDIUM)
  endtask

  task drive_frame(can_sequence_item req);
    bit ack_received;
    bit arbitration_lost;

    if (req.dlc > 8) begin
      `uvm_error("CAN_DRV", "DLC must be between 0 and 8")
      return;
    end

    if (req.id_base > 11'h7FF) begin
      `uvm_error("CAN_DRV", "Base identifier field is out of range")
      return;
    end

    if (req.ide && req.id_ext > 18'h3FFFF) begin
      `uvm_error("CAN_DRV", "Extended identifier field is out of range")
      return;
    end

    if (!req.rtr && req.data.size() < req.dlc) begin
      `uvm_error(
        "CAN_DRV",
        "Payload array size is smaller than DLC"
      )
      return;
    end

    build_tx_frame(req);
    rx_replay_bits.delete();
    rx_first_live_after_replay = 1'b0;

    `uvm_info(
      "CAN_DRV",
      $sformatf(
        "Starting CAN frame: IDE=%0b RTR=%0b ID_BASE=0x%03h DLC=%0d",
        req.ide,
        req.rtr,
        req.id_base,
        req.dlc
      ),
      UVM_MEDIUM
    )

    @(negedge vif.can_clk);

    foreach (tx_stuffed_bits[i]) begin
      drive_one_bit(
        tx_stuffed_bits[i],
        tx_arbitration_flags[i],
        arbitration_lost
      );

      if (arbitration_lost) begin
        receive_after_arbitration_loss(req);
        return;
      end
    end

    rx_replay_bits.delete();

    drive_one_non_arbitration_bit(1'b1);

    sample_ack_slot(ack_received);

    drive_one_non_arbitration_bit(1'b1);

    for (int unsigned i = 0; i < 7; i++)
      drive_one_non_arbitration_bit(1'b1);

    vif.ext_tx = 1'b1;

    if (ack_received)
      `uvm_info("CAN_DRV", "Frame transmitted through EOF", UVM_MEDIUM)
    else
      `uvm_warning(
        "CAN_DRV",
        "Frame transmission reached EOF without ACK"
      )
  endtask

  task run_phase(uvm_phase phase);
    can_sequence_item req;

    vif.ext_tx = 1'b1;

    forever begin
      seq_item_port.get_next_item(req);

      case (req.operation)
        ACK_DUT_FRAME:
          receive_and_ack(req);

        DRIVE_FRAME:
          drive_frame(req);

        default:
          `uvm_error(
            "CAN_DRV",
            "Unsupported CAN driver operation"
          )
      endcase

      seq_item_port.item_done();
    end
  endtask

endclass
