`include "uvm_macros.svh"
import uvm_pkg::*;

`include "can_pkg.sv"
import can_pkg::*;

`include "can_interface.sv"

module can_top;

  logic s_apb_pclk = 0;
  logic can_clk = 0;

  always #5 s_apb_pclk = ~s_apb_pclk;
  always #10 can_clk = ~can_clk;

  can_interface vif (
    .s_apb_pclk    (s_apb_pclk),
    .s_apb_presetn (1'b0),
    .can_clk       (can_clk)
  );

  can2b DUT (
    .s_apb_pclk    (vif.s_apb_pclk),
    .s_apb_presetn (vif.s_apb_presetn),
    .s_apb_psel    (vif.s_apb_psel),
    .s_apb_penable (vif.s_apb_penable),
    .s_apb_pwrite  (vif.s_apb_pwrite),
    .s_apb_paddr   (vif.s_apb_paddr),
    .s_apb_pwdata  (vif.s_apb_pwdata),
    .s_apb_pstrb   (vif.s_apb_pstrb),
    .s_apb_pprot   (vif.s_apb_pprot),
    .s_apb_prdata  (vif.s_apb_prdata),
    .s_apb_pready  (vif.s_apb_pready),
    .s_apb_pslverr (vif.s_apb_pslverr),
    .can_clk       (vif.can_clk),
    .can_resetn    (vif.can_resetn),
    .can_rx        (vif.can_rx),
    .can_tx        (vif.can_tx),
    .can_irq       (vif.can_irq)
  );

  initial begin
    vif.s_apb_presetn = 0;
    vif.can_resetn = 0;
    vif.can_rx = 1'b1;
    #20;
    vif.s_apb_presetn = 1;
    vif.can_resetn = 1;
  end

  initial begin
    uvm_config_db#(virtual can_interface)::set(
      uvm_root::get(), "*", "vif", vif
    );
  end

  initial begin
    run_test("can_test_base");
  end

endmodule
