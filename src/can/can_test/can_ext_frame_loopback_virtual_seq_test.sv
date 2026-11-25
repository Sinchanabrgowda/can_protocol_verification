class can_ext_frame_loopback_virtual_seq_test extends uvm_test;

  `uvm_component_utils(can_ext_frame_loopback_virtual_seq_test)

  can_env can_e;
  can_ext_frame_loopback_virtual_seq v_seq_lb_ex;

  function new(string name = "can_ext_frame_loopback_virtual_seq_test",uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
 super.build_phase(phase);
uvm_config_db#(bit)::set(
    this, "can_e.can_scb", "internal_loopback", 1'b1
  );

 can_e = can_env::type_id::create("can_e", this);
 endfunction


 task run_phase(uvm_phase phase);

    super.run_phase(phase);

    phase.raise_objection(this);

`uvm_info("TEST", "Starting virtual sequence", UVM_LOW)
   v_seq_lb_ex = can_ext_frame_loopback_virtual_seq::type_id::create("v_seq_lb_ex");
    v_seq_lb_ex.start(can_e.virtual_seqr);

    phase.drop_objection(this);
  endtask


endclass
