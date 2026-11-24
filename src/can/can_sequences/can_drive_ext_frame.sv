class can_tx_to_dut_ext_frame_seq extends uvm_sequence #(can_sequence_item);

  `uvm_object_utils(can_tx_to_dut_ext_frame_seq)

  function new(string name = "can_tx_to_dut_ext_frame_seq");
    super.new(name);
  endfunction

  task body();
    can_sequence_item req;

    req = can_sequence_item::type_id::create("req");

    start_item(req);
    req.operation = DRIVE_FRAME;
    req.ide = 1;
    req.rtr = 0;
    req.id_base = 11'h2AB;
    req.id_ext = 18'hCDEF;
    req.dlc = 8;
    req.data = new[8];

    req.data[0] = 8'h11;
    req.data[1] = 8'h22;
    req.data[2] = 8'h33;
    req.data[3] = 8'h44;
    req.data[4] = 8'h55;
    req.data[5] = 8'h66;
  req.data[6] = 8'h77;
    req.data[7] = 8'h88;

    req.crc_error = 0;
    req.ack_error = 0;

    finish_item(req);
  endtask

endclass

