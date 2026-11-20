class can_std_frame_rx_ack_virtual_seq extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(can_std_frame_rx_ack_virtual_seq)
  `uvm_declare_p_sequencer(can_virtual_sequencer)

  can_tx_to_dut_seq can_seq_rx_std_frame;
  can_std_rx_basic_seq ral_seq_rx_std_frame;

  function new(string name = "can_std_frame_rx_ack_virtual_seq");
    super.new(name);
  endfunction

  task body();

    can_seq_rx_std_frame = can_tx_to_dut_seq::type_id::create("can_seq_rx_std_frame");
    ral_seq_rx_std_frame = can_std_rx_basic_seq::type_id::create("ral_seq_rx_std_frame");

    ral_seq_rx_std_frame.can_regmodel = p_sequencer.can_regmodel;

    `uvm_info("VSEQ", "Configuring and enabling DUT receiver", UVM_LOW)

    ral_seq_rx_std_frame.configure_only = 1;
    ral_seq_rx_std_frame.start(p_sequencer.seqr_apb);

    `uvm_info("VSEQ", "DUT receiver is enabled. Starting external CAN transmission", UVM_LOW)

    ral_seq_rx_std_frame.configure_only = 0;

    fork
      begin
        can_seq_rx_std_frame.start(p_sequencer.seqr_can);
        `uvm_info("VSEQ", "External CAN frame transmission completed", UVM_LOW)
      end

      begin
        ral_seq_rx_std_frame.start(p_sequencer.seqr_apb);
        `uvm_info("VSEQ", "DUT frame reception and register reading completed", UVM_LOW)
      end
    join

    `uvm_info("VSEQ", "Virtual sequence completed", UVM_LOW)

  endtask

endclass

