class can_frame_arb_virtual_seq extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(can_frame_arb_virtual_seq)
  `uvm_declare_p_sequencer(can_virtual_sequencer)

  can_tx_to_dut_arb_seq can_tb_seq;
  can_tx_arb_seq dut_seq;

  function new(string name = "can_frame_arb_virtual_seq");
    super.new(name);
  endfunction

  task body();

    can_tb_seq = can_tx_to_dut_arb_seq::type_id::create("can_tb_seq");
    dut_seq = can_tx_arb_seq::type_id::create("dut_seq");

    dut_seq.can_regmodel = p_sequencer.can_regmodel;

    `uvm_info("ARB_VSEQ", "Starting DUT and TB transmissions", UVM_LOW)

    fork
      begin
        can_tb_seq.start(p_sequencer.seqr_can);
      end

      begin
        dut_seq.start(p_sequencer.seqr_apb);
      end
    join

    `uvm_info("ARB_VSEQ", "DUT and TB sequences completed", UVM_LOW)

  endtask

endclass
