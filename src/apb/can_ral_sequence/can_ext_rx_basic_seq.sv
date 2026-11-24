class can_ext_rx_basic_seq extends can_base_reg_seq;
  `uvm_object_utils(can_ext_rx_basic_seq)

  bit configure_only;

  function new(string name = "can_ext_rx_basic_seq");
    super.new(name);
  endfunction

task body();
    uvm_status_e status;
    uvm_reg_data_t rdata;
    uvm_reg_data_t rx_id;
    uvm_reg_data_t rx_dlc;
    uvm_reg_data_t rx_dw1;
    uvm_reg_data_t rx_dw2;
    bit frame_found;

if (can_regmodel == null)
  `uvm_fatal("can_ext_rx_basic_seq", "Register model handle is null")

    if (configure_only) begin

      `uvm_info("can_ext_rx_basic_seq", "Disabling CAN controller", UVM_LOW)
      can_regmodel.srr_reg_inst.write(status, 32'h00000000);

      `uvm_info("can_ext_rx_basic_seq", "Configuring BRPR", UVM_LOW)
      can_regmodel.brpr_reg_inst.write(status, 32'h00000003);

      `uvm_info("can_ext_rx_basic_seq", "Configuring BTR", UVM_LOW)
      can_regmodel.btr_reg_inst.write(status, 32'h000000A5);

      `uvm_info("can_ext_rx_basic_seq", "Accepting all incoming frames", UVM_LOW)
      can_regmodel.afr_reg_inst.write(status, 32'h00000000);

      `uvm_info("can_ext_rx_basic_seq", "Enabling CAN controller", UVM_LOW)
      can_regmodel.srr_reg_inst.write(status, 32'h00000002);

      can_regmodel.sr_reg_inst.read(status, rdata);

      `uvm_info("can_ext_rx_basic_seq",
                $sformatf("CAN Status after enable = %08h", rdata), UVM_LOW)

return;
    end

  `uvm_info("can_ext_rx_basic_seq", "Waiting for received frame", UVM_LOW)

    frame_found = 0;

for (int i = 0; i < 10000; i++) begin
can_regmodel.isr_reg_inst.read(status, rdata);

if (rdata[24] == 1'b1) begin
frame_found = 1;
break;
end
end

if (!frame_found)
  `uvm_fatal("can_ext_rx_basic_seq", "Timeout: RX FIFO did not become non-empty")

  `uvm_info("can_ext_rx_basic_seq", "Received frame detected", UVM_LOW)

  `uvm_info("can_ext_rx_basic_seq", "Reading RX_ID", UVM_LOW)
can_regmodel.rx_id_reg_inst.read(status, rx_id);

  `uvm_info("can_ext_rx_basic_seq",
$sformatf("RX_ID = %08h", rx_id), UVM_LOW)

  `uvm_info("can_ext_rx_basic_seq", "Reading RX_DLC", UVM_LOW)
can_regmodel.rx_dlc_reg_inst.read(status, rx_dlc);

  `uvm_info("can_ext_rx_basic_seq",
$sformatf("RX_DLC = %08h", rx_dlc), UVM_LOW)

`uvm_info("can_std_rx_basic_seq", "Reading RX_DW1", UVM_LOW)
can_regmodel.rx_dw1_reg_inst.read(status, rx_dw1);

  `uvm_info("can_ext_rx_basic_seq",
$sformatf("RX_DW1 = %08h", rx_dw1), UVM_LOW)

  `uvm_info("can_ext_rx_basic_seq", "Reading RX_DW2 and popping frame", UVM_LOW)
can_regmodel.rx_dw2_reg_inst.read(status, rx_dw2);

  `uvm_info("can_ext_rx_basic_seq",
$sformatf("RX_DW2 = %08h", rx_dw2), UVM_LOW)

can_regmodel.isr_reg_inst.read(status, rdata);

  `uvm_info("can_ext_rx_basic_seq",
$sformatf("Interrupt Status = %08h", rdata), UVM_LOW)

  `uvm_info("can_ext_rx_basic_seq", "Clearing RX interrupt status", UVM_LOW)
can_regmodel.icr_reg_inst.write(status, 32'h09000000);

can_regmodel.ecr_reg_inst.read(status, rdata);

  `uvm_info("can_ext_rx_basic_seq",
$sformatf("Error Counter = %08h", rdata), UVM_LOW)

endtask
endclass
