class can_std_frame_rx_ack_virtual_seq_test extends uvm_test;

  `uvm_component_utils(can_std_frame_rx_ack_virtual_seq_test)

  can_env can_e;
  can_std_frame_rx_ack_virtual_seq v_seq_rx_std_frame;

  function new(string name = "can_std_frame_rx_ack_virtual_seq_test",uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  uvm_config_db#(can_operation_e)::set(
  this, "can_e", "operation", DRIVE_FRAME
);

 can_e = can_env::type_id::create("can_e", this);
 endfunction


 task run_phase(uvm_phase phase);

    super.run_phase(phase);

    phase.raise_objection(this);

`uvm_info("TEST", "Starting virtual sequence", UVM_LOW)
   v_seq_rx_std_frame = can_std_frame_rx_ack_virtual_seq::type_id::create("v_seq_rx_std_frame");
    v_seq_rx_std_frame.start(can_e.virtual_seqr);

    phase.drop_objection(this);
  endtask


endclass
