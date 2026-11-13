class can_frame_dut_ack_virtual_seq extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(can_frame_dut_ack_virtual_seq)
  `uvm_declare_p_sequencer(can_virtual_sequencer)

  can_ack_dut_seq can_seq;
  can_tx_basic_seq ral_seq;

  function new(string name = "can_frame_dut_ack_virtual_seq");
    super.new(name);
  endfunction

  task body();

    can_seq = can_ack_dut_seq::type_id::create("can_seq");
    ral_seq = can_tx_basic_seq::type_id::create("ral_seq");

    ral_seq.can_regmodel = p_sequencer.can_regmodel;

`uvm_info("VSEQ", "Starting CAN ACK sequence", UVM_LOW)
/*
    fork
      can_seq.start(p_sequencer.seqr_can);
      ral_seq.start(p_sequencer.seqr_apb);
    join
*/
fork
    begin
      can_seq.start(p_sequencer.seqr_can);
      `uvm_info("VSEQ", "CAN ACK sequence completed", UVM_LOW)
    end

    begin
      `uvm_info("VSEQ", "Starting APB RAL sequence", UVM_LOW)
      ral_seq.start(p_sequencer.seqr_apb);
      `uvm_info("VSEQ", "APB RAL sequence completed", UVM_LOW)
    end
  join

  `uvm_info("VSEQ", "Virtual sequence completed", UVM_LOW)
  endtask

endclass
