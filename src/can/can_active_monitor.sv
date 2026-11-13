class can_active_monitor extends uvm_monitor;

  `uvm_component_utils(can_active_monitor)

  virtual can_interface vif;
  can_timing_config timing_cfg;

  uvm_analysis_port #(can_sequence_item) analysis_port;

  bit previous_bit;
  int unsigned same_count;
  bit frame_valid;

  function new(string name = "can_active_monitor",uvm_component parent = null );
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual can_interface)::get( this, "", "vif", vif))
      `uvm_fatal("CAN_MON", "CAN interface not found")

    if (!uvm_config_db#(can_timing_config)::get( this, "", "timing_cfg", timing_cfg))
      `uvm_fatal("CAN_MON", "CAN timing configuration not found")
  endfunction

  task wait_clocks(int unsigned count);
    repeat (count)
      @(posedge vif.can_clk);
  endtask

  task wait_for_sof(output bit sof);
    sof = 1'b1;

    wait (vif.can_bus === 1'b1);
    @(negedge vif.can_bus);

    wait_clocks(timing_cfg.sample_point_cycles);
    sof = vif.can_bus;

    if (sof !== 1'b0) begin
      frame_valid = 0;
      `uvm_error("CAN_MON", "Invalid SOF")
    end
  endtask

  task sample_raw_bit(output bit value);
    wait_clocks(timing_cfg.clocks_per_bit);
    value = vif.can_bus;
  endtask

  task sample_destuffed_bit( output bit value, input can_sequence_item tr );
    bit stuff_bit;

    if (same_count == 5) begin
      sample_raw_bit(stuff_bit);

      if (stuff_bit === previous_bit) begin
        frame_valid = 0;
        tr.stuff_error = 1;
        `uvm_error("CAN_MON", "CAN stuffing error detected")
      end

      previous_bit = stuff_bit;
      same_count = 1;
    end

    sample_raw_bit(value);

    if (value === previous_bit)
      same_count++;
    else begin
      previous_bit = value;
      same_count = 1;
    end
  endtask

  task read_field( input int unsigned width,output longint unsigned value,input can_sequence_item tr );
    bit sampled_bit;

    value = 0;

    for (int unsigned i = 0; i < width; i++) begin
      sample_destuffed_bit(sampled_bit, tr);
      value = (value << 1) | sampled_bit;
    end
  endtask

  task monitor_frame();
    can_sequence_item tr;

    longint unsigned field_value;

    bit sof;
    bit first_after_base;
    bit received_ide;
    bit received_rtr;
    bit sampled_bit;

    int unsigned payload_bytes;

    tr = can_sequence_item::type_id::create("tr");

    frame_valid = 1;
    previous_bit = 0;
    same_count = 1;

    tr.data = new[0];

    // Initialize error flags
    tr.crc_error = 0;
    tr.ack_error = 0;
    tr.bit_error = 0;
    tr.stuff_error = 0;
    tr.form_error = 0;

    wait_for_sof(sof);

    if (sof !== 1'b0) begin
      tr.form_error = 1;
      analysis_port.write(tr);
      return;
    end

    previous_bit = sof;
    same_count = 1;

    // Identifier base
    read_field(11, field_value, tr);
    tr.id_base = field_value[10:0];

    // SRR/RTR and IDE
    sample_destuffed_bit(first_after_base, tr);
    sample_destuffed_bit(received_ide, tr);

    tr.ide = received_ide;

    if (received_ide) begin

      // Extended frame
      if (first_after_base !== 1'b1) begin
        frame_valid = 0;
        tr.form_error = 1;
        `uvm_error("CAN_MON", "Invalid SRR bit")
      end

      read_field(18, field_value, tr);
      tr.id_ext = field_value[17:0];

      read_field(1, field_value, tr);
      received_rtr = field_value[0];

      // Reserved bit r1
      read_field(1, field_value, tr);

      if (field_value[0] !== 1'b0) begin
        frame_valid = 0;
        tr.form_error = 1;
        `uvm_error("CAN_MON", "Invalid extended r1 bit")
      end

      // Reserved bit r0
      read_field(1, field_value, tr);

      if (field_value[0] !== 1'b0) begin
        frame_valid = 0;
        tr.form_error = 1;
        `uvm_error("CAN_MON", "Invalid extended r0 bit")
      end
    end
    else begin

      // Standard frame
      received_rtr = first_after_base;

      read_field(1, field_value, tr);

      if (field_value[0] !== 1'b0) begin
        frame_valid = 0;
        tr.form_error = 1;
        `uvm_error("CAN_MON", "Invalid standard r0 bit")
      end
    end

    tr.rtr = received_rtr;

    // DLC
    read_field(4, field_value, tr);
    tr.dlc = field_value[3:0];

    if (tr.dlc > 8) begin
      frame_valid = 0;
      tr.form_error = 1;
      `uvm_error( "CAN_MON",$sformatf("Unsupported DLC value: %0d", tr.dlc) )
    end

    payload_bytes = (tr.dlc > 8) ? 8 : tr.dlc;

    // Data field
    if (!tr.rtr) begin
      tr.data = new[payload_bytes];

      for (int unsigned i = 0; i < payload_bytes; i++) begin
        read_field(8, field_value, tr);
        tr.data[i] = field_value[7:0];
      end
    end
    else begin
      tr.data = new[0];
    end

    // Received CRC
    read_field(15, field_value, tr);
    tr.crc = field_value[14:0];

    // CRC delimiter
    sample_raw_bit(sampled_bit);

    if (sampled_bit !== 1'b1) begin
      frame_valid = 0;
      tr.form_error = 1;
      `uvm_error("CAN_MON", "Invalid CRC delimiter")
    end

    // ACK slot
    sample_raw_bit(sampled_bit);

    if (sampled_bit !== 1'b0) begin
      frame_valid = 0;
      tr.ack_error = 1;
      `uvm_error("CAN_MON", "ACK slot was not dominant")
    end

    // ACK delimiter
    sample_raw_bit(sampled_bit);

    if (sampled_bit !== 1'b1) begin
      frame_valid = 0;
      tr.form_error = 1;
      `uvm_error("CAN_MON", "Invalid ACK delimiter")
    end

    // EOF
    for (int unsigned i = 0; i < 7; i++) begin
      sample_raw_bit(sampled_bit);

      if (sampled_bit !== 1'b1) begin
        frame_valid = 0;
        tr.form_error = 1;
        `uvm_error("CAN_MON", "Invalid EOF bit")
      end
    end

    `uvm_info( "CAN_MON", $sformatf( "Observed CAN frame: IDE=%0b RTR=%0b ID_BASE=0x%03h ID_EXT=0x%05h DLC=%0d CRC=0x%04h", tr.ide,  tr.rtr,tr.id_base, tr.id_ext, tr.dlc, tr.crc ),UVM_MEDIUM )

    analysis_port.write(tr);

  endtask

  task run_phase(uvm_phase phase);
    forever begin
      monitor_frame();
    end
  endtask

endclass
