class can_active_monitor extends uvm_monitor;

  `uvm_component_utils(can_active_monitor)

  virtual can_interface vif;
  can_timing_config timing_cfg;

  uvm_analysis_port #(can_sequence_item) analysis_port;

  bit previous_bit;   // to remove stuff bits
  int unsigned same_count; //to remove stuff bits
  bit frame_valid;

  function new(
    string name = "can_active_monitor",
    uvm_component parent = null
  );
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual can_interface)::get(
          this, "", "vif", vif))
      `uvm_fatal("CAN_MON", "CAN interface not found")

    if (!uvm_config_db#(can_timing_config)::get(
          this, "", "timing_cfg", timing_cfg))
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

    task sample_destuffed_bit(output bit value); //value stores the actual next bit after removing the stuff bit
    bit stuff_bit; // used to store the stuff bit

    if (same_count == 5) begin
      sample_raw_bit(stuff_bit); // sample the raw stuff bit 

      if (stuff_bit === previous_bit) begin
        frame_valid = 0;
        `uvm_error("CAN_MON", "CAN stuffing error detected")
      end

      previous_bit = stuff_bit;
      same_count = 1;
    end

      sample_raw_bit(value); // value returned to the task read_field

    if (value === previous_bit)
      same_count++;
    else begin
      previous_bit = value;
      same_count = 1;
    end
  endtask

  task read_field(
    input int unsigned width,
    output longint unsigned value
  );
    bit sampled_bit;

    value = 0;

    for (int unsigned i = 0; i < width; i++) begin
      sample_destuffed_bit(sampled_bit); // so here it takes the next bit after sample bit only it doesnt count the stuff bit
      value = (value << 1) | sampled_bit; //left shift to join the next bit
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

    bit [14:0] received_crc;

    int unsigned payload_bytes;

    tr = can_sequence_item::type_id::create("tr");

    frame_valid = 1;
    previous_bit = 0;
    same_count = 1;

    tr.data = new[0];

    wait_for_sof(sof);

    if (sof !== 1'b0)
      return;

    previous_bit = sof; //sof
    same_count = 1;

    read_field(11, field_value);
    tr.id_base = field_value[10:0]; // id

    sample_destuffed_bit(first_after_base);
    sample_destuffed_bit(received_ide);

    tr.ide = received_ide; //ide

    if (received_ide) begin
      if (first_after_base !== 1'b1) begin //srr
        frame_valid = 0;
        `uvm_error("CAN_MON", "Invalid SRR bit")
      end

      read_field(18, field_value); //ext_id
      tr.id_ext = field_value[17:0];

      read_field(1, field_value);
      received_rtr = field_value[0]; //extd frame rtr

      read_field(1, field_value); //ext_frame r1
      if (field_value[0] !== 1'b0) begin
        frame_valid = 0;
        `uvm_error("CAN_MON", "Invalid extended r1 bit")
      end

      read_field(1, field_value);   //ext_frame r0
      if (field_value[0] !== 1'b0) begin
        frame_valid = 0;
        `uvm_error("CAN_MON", "Invalid extended r0 bit")
      end
    end
    else begin
      received_rtr = first_after_base; //std_frame rtr

      read_field(1, field_value); //std_frame ide

      if (field_value[0] !== 1'b0) begin  // std_frame r0
        frame_valid = 0;
        `uvm_error("CAN_MON", "Invalid standard r0 bit")
      end
    end

    tr.rtr = received_rtr;

    read_field(4, field_value); //dlc
    tr.dlc = field_value[3:0];

    if (tr.dlc > 8) begin
      frame_valid = 0;
      `uvm_error(
        "CAN_MON",
        $sformatf("Unsupported DLC value: %0d", tr.dlc)
      )
    end

    payload_bytes = (tr.dlc > 8) ? 8 : tr.dlc;  //data payload

    if (!tr.rtr) begin
      tr.data = new[payload_bytes];

      for (int unsigned i = 0; i < payload_bytes; i++) begin
        read_field(8, field_value);
        tr.data[i] = field_value[7:0];
      end
    end
    else begin
      tr.data = new[0]; // if rtr data =0
    end

    read_field(15, field_value); //crc
    received_crc = field_value[14:0];

    sample_raw_bit(sampled_bit);  //crc delimeter

    if (sampled_bit !== 1'b1) begin
      frame_valid = 0;
      `uvm_error("CAN_MON", "Invalid CRC delimiter")
    end

    sample_raw_bit(sampled_bit); //sample ack

    if (sampled_bit !== 1'b0) begin
      frame_valid = 0;
      `uvm_error("CAN_MON", "ACK slot was not dominant")
    end

    sample_raw_bit(sampled_bit); //sample ack delimeter

    if (sampled_bit !== 1'b1) begin
      frame_valid = 0;
      `uvm_error("CAN_MON", "Invalid ACK delimiter")
    end

    for (int unsigned i = 0; i < 7; i++) begin
      sample_raw_bit(sampled_bit);  // eof

      if (sampled_bit !== 1'b1) begin
        frame_valid = 0;
        `uvm_error("CAN_MON", "Invalid EOF bit")
      end
    end

    if (frame_valid) begin
      `uvm_info(
        "CAN_MON",
        $sformatf(
          "Observed CAN frame: IDE=%0b RTR=%0b ID_BASE=0x%03h ID_EXT=0x%05h DLC=%0d CRC=0x%04h",
          tr.ide,
          tr.rtr,
          tr.id_base,
          tr.id_ext,
          tr.dlc,
          received_crc
        ),
        UVM_MEDIUM
      )

      analysis_port.write(tr);
    end
    else begin
      `uvm_warning(
        "CAN_MON",
        "Invalid CAN frame observed; transaction not published"
      )
    end
  endtask

  task run_phase(uvm_phase phase);
    forever begin
      monitor_frame();
    end
  endtask

endclass
