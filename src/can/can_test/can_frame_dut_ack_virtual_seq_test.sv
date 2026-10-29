class can_frame_dut_ack_virtual_seq_test extends uvm_test;

  `uvm_component_utils(can_frame_dut_ack_virtual_seq_test)

  can_env can_e;
  can_base_reg_seq can_reg_seq;
  can_frame_dut_ack_virtual_seq v_seq;

  function new(string name = "can_frame_dut_ack_virtual_seq_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    can_e = can_env::type_id::create("can_e", this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);

    can_reg_seq = can_base_reg_seq::type_id::create("can_reg_seq");
    can_reg_seq.can_regmodel = can_e.can_regmodel;

    v_seq = can_frame_dut_ack_virtual_seq::type_id::create("v_seq");
    v_seq.start(can_e.virtual_seqr);

    phase.drop_objection(this);
  endtask

endclass
