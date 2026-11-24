class can_frame_loopback_virtual_seq extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(can_frame_loopback_virtual_seq)
  `uvm_declare_p_sequencer(can_virtual_sequencer)


  can_tx_basic_loopback_seq ral_seq_loopback;

  function new(string name = "can_frame_loopback_virtual_seq");
    super.new(name);
  endfunction

  task body();

    ral_seq_loopback = can_tx_basic_loopback_seq::type_id::create("ral_seq_loopback");

    ral_seq_loopback.can_regmodel = p_sequencer.can_regmodel;


fork

    begin
      `uvm_info("VSEQ", "Starting APB RAL sequence", UVM_LOW)
      ral_seq_loopback.start(p_sequencer.seqr_apb);
      `uvm_info("VSEQ", "APB RAL sequence completed", UVM_LOW)
    end
  join

  `uvm_info("VSEQ", "Virtual sequence completed", UVM_LOW)
  endtask

endclass
