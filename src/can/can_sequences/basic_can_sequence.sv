class can_sequence extends uvm_sequence #(can_sequence_item);
  `uvm_object_utils(can_sequence)

  function new(string name = "can_sequence");
    super.new(name);
  endfunction

  task body();
    can_sequence_item req;

    req = can_sequence_item::type_id::create("req");

    start_item(req);

    if (!req.randomize())
      `uvm_fatal("CAN_SEQUENCE", "Randomization failed")

    finish_item(req);

  endtask

endclass

