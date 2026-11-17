class can_ext_frame_dut_ack_virtual_seq_test extends uvm_test;

  `uvm_component_utils(can_ext_frame_dut_ack_virtual_seq_test)

  can_env can_e;
  can_ext_frame_dut_ack_virtual_seq v_seq_ext_frame;

  function new(string name = "can_ext_frame_dut_ack_virtual_seq_test",uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  uvm_config_db#(can_operation_e)::set(
  this, "can_e", "operation", ACK_DUT_FRAME
);

 can_e = can_env::type_id::create("can_e", this);
 endfunction


 task run_phase(uvm_phase phase);

    super.run_phase(phase);

    phase.raise_objection(this);

`uvm_info("TEST", "Starting virtual sequence", UVM_LOW)
   v_seq_ext_frame = can_ext_frame_dut_ack_virtual_seq::type_id::create("v_seq_ext_frame");
    v_seq_ext_frame.start(can_e.virtual_seqr);

    phase.drop_objection(this);
  endtask


endclass
