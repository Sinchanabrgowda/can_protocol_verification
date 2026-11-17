class can_ext_frame_ack_seq extends uvm_sequence #(can_sequence_item);

  `uvm_object_utils(can_ext_frame_ack_seq)

  function new(string name = "can_ext_frame_ack_seq");
    super.new(name);
  endfunction

  task body();
    can_sequence_item req;
    `uvm_info("CAN_ext_frame_ACK_SEQ", "Creating ACK request", UVM_LOW)
    req = can_sequence_item::type_id::create("req");

    start_item(req);
`uvm_info("CAN_ext_frame_ACK_SEQ", "Got grant from CAN sequencer", UVM_LOW)
    req.operation = ACK_DUT_FRAME;
    finish_item(req);
`uvm_info("CAN_ACK_SEQ", "ACK request completed", UVM_LOW)

  endtask

endclass
