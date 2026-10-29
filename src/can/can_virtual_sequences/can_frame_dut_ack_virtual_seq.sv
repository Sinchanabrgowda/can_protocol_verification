class can_frame_dut_ack_virtual_seq extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(can_frame_dut_ack_virtual_seq)
  `uvm_declare_p_sequencer(can_virtual_sequencer)

  can_ack_dut_frame can_seq;
  can_base_reg_seq ral_seq;

  function new(string name = "can_frame_dut_ack_virtual_seq");
    super.new(name);
  endfunction

  task body();

    can_seq = can_ack_dut_frame::type_id::create("can_seq");
    ral_seq = can_base_reg_seq::type_id::create("ral_seq");

    fork
      can_seq.start(p_sequencer.seqr_can);
      ral_seq.start(p_sequencer.seqr_apb);
    join

  endtask

endclass
