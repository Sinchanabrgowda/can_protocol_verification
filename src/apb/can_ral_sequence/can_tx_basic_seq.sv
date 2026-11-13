/*
class can_tx_basic_seq extends can_base_reg_seq;
  `uvm_object_utils(can_tx_basic_seq)

  function new(string name = "can_tx_basic_seq");
    super.new(name);
  endfunction

task body();

  if (can_regmodel == null)
    `uvm_fatal("CAN_TX_SEQ", "Register model handle is null")

  `uvm_info("CAN_TX_SEQ", "Writing TX_ID", UVM_LOW)
 can_regmodel.tx_id_reg_inst.write(status, 32'h00000000);
  `uvm_info("CAN_TX_SEQ", "TX_ID write completed", UVM_LOW)

  `uvm_info("CAN_TX_SEQ", "Writing TX_DLC", UVM_LOW)
  can_regmodel.tx_dlc_reg_inst.write(status, 32'h00000004);
  `uvm_info("CAN_TX_SEQ", "TX_DLC write completed", UVM_LOW)

  `uvm_info("CAN_TX_SEQ", "Writing TX_DW1", UVM_LOW)
  can_regmodel.tx_dw1_reg_inst.write(status, 32'hAABBCCDD);
  `uvm_info("CAN_TX_SEQ", "TX_DW1 write completed", UVM_LOW)

  `uvm_info("CAN_TX_SEQ", "Writing TX_DW2", UVM_LOW)
  can_regmodel.tx_dw2_reg_inst.write(status, 32'h00000000);
  `uvm_info("CAN_TX_SEQ", "TX_DW2 write completed", UVM_LOW)

endtask
endclass
*/

class can_tx_basic_seq extends can_base_reg_seq;
  `uvm_object_utils(can_tx_basic_seq)

  function new(string name = "can_tx_basic_seq");
    super.new(name);
  endfunction

  task body();
    uvm_status_e status;
    uvm_reg_data_t rdata;

    if (can_regmodel == null)
      `uvm_fatal("CAN_TX_SEQ", "Register model handle is null")

    // CAN in configuration mode
    `uvm_info("CAN_TX_SEQ", "Disabling CAN controller", UVM_LOW)
    can_regmodel.srr_reg_inst.write(status, 32'h00000000);

    // Configure baud rate and bit timing
    `uvm_info("CAN_TX_SEQ", "Configuring BRPR", UVM_LOW)
    can_regmodel.brpr_reg_inst.write(status, 32'h00000003);

    `uvm_info("CAN_TX_SEQ", "Configuring BTR", UVM_LOW)
    can_regmodel.btr_reg_inst.write(status, 32'h000000A5);

    // Accept all incoming frames
    can_regmodel.afr_reg_inst.write(status, 32'h00000000);

    //  Enable CAN controller
    `uvm_info("CAN_TX_SEQ", "Enabling CAN controller", UVM_LOW)
    can_regmodel.srr_reg_inst.write(status, 32'h00000002);

    can_regmodel.sr_reg_inst.read(status, rdata);
    `uvm_info("CAN_TX_SEQ",$sformatf("CAN Status after enable = %08h", rdata), UVM_LOW)

    // Write TX frame registers
    `uvm_info("CAN_TX_SEQ", "Writing TX_ID", UVM_LOW)
    can_regmodel.tx_id_reg_inst.write(status, 32'h00000000);

    `uvm_info("CAN_TX_SEQ", "Writing TX_DLC", UVM_LOW)
    can_regmodel.tx_dlc_reg_inst.write(status, 32'h00000004);

    `uvm_info("CAN_TX_SEQ", "Writing TX_DW1", UVM_LOW)
    can_regmodel.tx_dw1_reg_inst.write(status, 32'hAABBCCDD);

    // Push frame into TX FIFO
    `uvm_info("CAN_TX_SEQ", "Pushing frame into TX FIFO", UVM_LOW)
    can_regmodel.tx_dw2_reg_inst.write(status, 32'h00000000);

    //  Wait for transmission and inspect status
    #1ms;

    can_regmodel.sr_reg_inst.read(status, rdata);
    `uvm_info("CAN_TX_SEQ",$sformatf("CAN Status = %08h", rdata),UVM_LOW)

    can_regmodel.isr_reg_inst.read(status, rdata);
    `uvm_info("CAN_TX_SEQ",$sformatf("Interrupt Status = %08h", rdata), UVM_LOW)

    can_regmodel.ecr_reg_inst.read(status, rdata);
    `uvm_info("CAN_TX_SEQ", $sformatf("Error Counter = %08h", rdata), UVM_LOW)

  endtask
endclass

