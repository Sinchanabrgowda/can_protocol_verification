class can_ack_dut_seq extends uvm_sequence #(can_sequence_item);

  `uvm_object_utils(can_ack_dut_seq)

  function new(string name = "can_ack_dut_seq");
    super.new(name);
  endfunction

  task body();
    can_sequence_item req;

    req = can_sequence_item::type_id::create("req");

    start_item(req);
    req.operation = ACK_DUT_FRAME;
    finish_item(req);
  endtask

endclass
