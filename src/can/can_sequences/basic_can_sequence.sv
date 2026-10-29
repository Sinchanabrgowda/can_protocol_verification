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

    `uvm_info("CAN_SEQUENCE",
      $sformatf("CAN frame generated: IDE=%0b RTR=%0b ID_BASE=%03h ID_EXT=%05h DLC=%0d",
                req.ide, req.rtr, req.id_base, req.id_ext, req.dlc),
      UVM_MEDIUM)
  endtask

endclass

