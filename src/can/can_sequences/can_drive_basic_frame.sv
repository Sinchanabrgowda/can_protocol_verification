class can_tx_to_dut_seq extends uvm_sequence #(can_sequence_item);

  `uvm_object_utils(can_tx_to_dut_seq)

  function new(string name = "can_tx_to_dut_seq");
    super.new(name);
  endfunction

  task body();
    can_sequence_item req;

    req = can_sequence_item::type_id::create("req");

    start_item(req);
    req.operation = DRIVE_FRAME;
    req.ide = 0;
    req.rtr = 0;
    req.id_base = 11'h123;
    req.id_ext = 0;
    req.dlc = 4;
    req.data = new[4];

    req.data[0] = 8'h11;
    req.data[1] = 8'h22;
    req.data[2] = 8'h33;
    req.data[3] = 8'h44;

    req.crc_error = 0;
    req.ack_error = 0;

    finish_item(req);
  endtask

endclass
