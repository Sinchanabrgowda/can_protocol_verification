class can_tx_ext_loopback_seq extends can_base_reg_seq;

  `uvm_object_utils(can_tx_ext_loopback_seq)

  function new(string name = "can_tx_ext_loopback_seq");
    super.new(name);
  endfunction

  task body();

    uvm_status_e status;
    uvm_reg_data_t rdata;

    uvm_reg_data_t rx_id;
    uvm_reg_data_t rx_dlc;
    uvm_reg_data_t rx_dw1;
    uvm_reg_data_t rx_dw2;

    bit rx_available;
    int poll_count;

    if (can_regmodel == null)
      `uvm_fatal("CAN_TX_SEQ", "Register model handle is null")

    // Disable CAN controller
    `uvm_info("CAN_TX_SEQ", "Disabling CAN controller", UVM_LOW)

    can_regmodel.srr_reg_inst.write(status, 32'h00000000);

    if (status != UVM_IS_OK)
      `uvm_fatal("CAN_TX_SEQ", "Failed to disable CAN controller")

    // Configure baud rate and bit timing
    `uvm_info("CAN_TX_SEQ", "Configuring BRPR", UVM_LOW)

    can_regmodel.brpr_reg_inst.write(status, 32'h00000003);

    if (status != UVM_IS_OK)
      `uvm_fatal("CAN_TX_SEQ", "BRPR configuration failed")

    `uvm_info("CAN_TX_SEQ", "Configuring BTR", UVM_LOW)

    can_regmodel.btr_reg_inst.write(status, 32'h000000A5);

    if (status != UVM_IS_OK)
      `uvm_fatal("CAN_TX_SEQ", "BTR configuration failed")

    // Enable internal loopback mode
    `uvm_info("CAN_TX_SEQ", "Enabling internal loopback mode", UVM_LOW)

    can_regmodel.msr_reg_inst.write(status, 32'h00000002);

    if (status != UVM_IS_OK)
      `uvm_fatal("CAN_TX_SEQ", "Loopback configuration failed")

    // Accept all incoming frames
    can_regmodel.afr_reg_inst.write(status, 32'h00000000);

    if (status != UVM_IS_OK)
      `uvm_fatal("CAN_TX_SEQ", "Acceptance filter configuration failed")

    // Enable CAN controller
    `uvm_info("CAN_TX_SEQ", "Enabling CAN controller", UVM_LOW)

    can_regmodel.srr_reg_inst.write(status, 32'h00000002);

    if (status != UVM_IS_OK)
      `uvm_fatal("CAN_TX_SEQ", "Failed to enable CAN controller")

    can_regmodel.sr_reg_inst.read(status, rdata);

    `uvm_info("CAN_TX_SEQ",
              $sformatf("CAN Status after enable = %08h", rdata),
              UVM_LOW)

    if (!rdata[30])
      `uvm_error("CAN_TX_SEQ", "Internal loopback mode is not enabled")

    `uvm_info("CAN_TX_SEQ", "Writing TX_ID", UVM_LOW)

      can_regmodel.tx_id_reg_inst.write(status, 32'h04180010);

    if (status != UVM_IS_OK)
      `uvm_fatal("CAN_TX_SEQ", "TX_ID write failed")

    `uvm_info("CAN_TX_SEQ", "Writing TX_DLC", UVM_LOW)

      can_regmodel.tx_dlc_reg_inst.write(status, 32'h00000008);

    if (status != UVM_IS_OK)
      `uvm_fatal("CAN_TX_SEQ", "TX_DLC write failed")

    `uvm_info("CAN_TX_SEQ", "Writing TX_DW1", UVM_LOW)

    can_regmodel.tx_dw1_reg_inst.write(status, 32'hAABBCCDD);

    if (status != UVM_IS_OK)
      `uvm_fatal("CAN_TX_SEQ", "TX_DW1 write failed")

    `uvm_info("CAN_TX_SEQ", "Pushing frame into TX FIFO", UVM_LOW)

      can_regmodel.tx_dw2_reg_inst.write(status, 32'h11223344);

    if (status != UVM_IS_OK)
      `uvm_fatal("CAN_TX_SEQ", "TX FIFO push failed")

    `uvm_info("CAN_TX_SEQ",
              "Waiting for internal loopback reception",
              UVM_LOW)

    rx_available = 0;

    for (poll_count = 0; poll_count < 500; poll_count++) begin

      can_regmodel.isr_reg_inst.read(status, rdata);

      if (status != UVM_IS_OK)
        `uvm_fatal("CAN_TX_SEQ", "ISR read failed during polling")

      // RXNEMP: bit 24 or mirror bit 7
      if (rdata[24] || rdata[7]) begin

        rx_available = 1;

        `uvm_info("CAN_TX_SEQ",
                  $sformatf("RX FIFO is non-empty. ISR = %08h", rdata),
                  UVM_LOW)

        break;
      end

      #1000;

    end

    // Read controller status
    can_regmodel.sr_reg_inst.read(status, rdata);

    `uvm_info("CAN_TX_SEQ",
              $sformatf("CAN Status = %08h", rdata),
              UVM_LOW)

    if (rdata[26])
      `uvm_warning("CAN_TX_SEQ", "CAN controller is still busy")

    can_regmodel.isr_reg_inst.read(status, rdata);

    `uvm_info("CAN_TX_SEQ",
              $sformatf("Interrupt Status = %08h", rdata),
              UVM_LOW)

    can_regmodel.ecr_reg_inst.read(status, rdata);

    `uvm_info("CAN_TX_SEQ",
              $sformatf("Error Counter = %08h", rdata),
              UVM_LOW)

    // Check RX FIFO reception
    if (!rx_available) begin

      `uvm_error("CAN_TX_SEQ",
                 "Timeout: RX FIFO did not become non-empty")

    end
    else begin

      `uvm_info("CAN_TX_SEQ", "Reading RX_ID", UVM_LOW)

      can_regmodel.rx_id_reg_inst.read(status, rx_id);

      `uvm_info("CAN_TX_SEQ",
                $sformatf("RX_ID = %08h", rx_id),
                UVM_LOW)

      `uvm_info("CAN_TX_SEQ", "Reading RX_DLC", UVM_LOW)

      can_regmodel.rx_dlc_reg_inst.read(status, rx_dlc);

      `uvm_info("CAN_TX_SEQ",
                $sformatf("RX_DLC = %08h", rx_dlc),
                UVM_LOW)

      `uvm_info("CAN_TX_SEQ", "Reading RX_DW1", UVM_LOW)

      can_regmodel.rx_dw1_reg_inst.read(status, rx_dw1);

      `uvm_info("CAN_TX_SEQ",
                $sformatf("RX_DW1 = %08h", rx_dw1),
                UVM_LOW)

      `uvm_info("CAN_TX_SEQ", "Reading RX_DW2", UVM_LOW)

      can_regmodel.rx_dw2_reg_inst.read(status, rx_dw2);

      `uvm_info("CAN_TX_SEQ",
                $sformatf("RX_DW2 = %08h", rx_dw2),
                UVM_LOW)

      if (rx_id !== 32'h04180010)
        `uvm_error("CAN_TX_SEQ",
                   $sformatf("RX_ID mismatch. Expected 04180010, Got %08h",
                             rx_id))
      else
        `uvm_info("CAN_TX_SEQ", "RX_ID matched successfully", UVM_LOW)

        if (rx_dlc[31:28] !== 4'h8)
        `uvm_error("CAN_TX_SEQ",
                   $sformatf("RX DLC mismatch. Expected 8, Got %0h",
                             rx_dlc[3:0]))
      else
        `uvm_info("CAN_TX_SEQ", "RX DLC matched successfully", UVM_LOW)

      if (rx_dw1 !== 32'hAABBCCDD)
        `uvm_error("CAN_TX_SEQ",
                   $sformatf("RX data mismatch. Expected AABBCCDD, Got %08h",
                             rx_dw1))
      else
        `uvm_info("CAN_TX_SEQ", "RX data matched successfully", UVM_LOW)
        
        if (rx_dw2 !== 32'h11223344)
        `uvm_error("CAN_TX_SEQ",
                   $sformatf("RX data mismatch. Expected 11223344, Got %08h",
                             rx_dw1))
      else
        `uvm_info("CAN_TX_SEQ", "RX data matched successfully", UVM_LOW)


    end

    can_regmodel.isr_reg_inst.read(status, rdata);

    `uvm_info("CAN_TX_SEQ",
              $sformatf("Final Interrupt Status = %08h", rdata),
              UVM_LOW)

    can_regmodel.ecr_reg_inst.read(status, rdata);

    `uvm_info("CAN_TX_SEQ",
              $sformatf("Final Error Counter = %08h", rdata),
              UVM_LOW)

    `uvm_info("CAN_TX_SEQ",
              "Internal loopback sequence completed",
              UVM_LOW)

  endtask

endclass
