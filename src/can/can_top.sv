`include "uvm_macros.svh"

// RTL files
`include "../rtl/apb_interface/apb_interface.v"
`include "../rtl/synchronizers/reset_synchronizer.v"
`include "../rtl/synchronizers/pulse_synchronizer.v"
`include "../rtl/synchronizers/two_ff_synchronizer.v"

`include "../rtl/bit_timing_engine/can_baud_gen.v"
`include "../rtl/bit_timing_engine/can_bit_timing_logic.v"
`include "../rtl/bit_timing_engine/can_btl_top.v"

`include "../rtl/can_reg_file/can_reg_file.v"
`include "../rtl/fifo/can_fifo.v"

`include "../rtl/rx_path/acceptance_filter.v"
`include "../rtl/rx_path/bit_destuff.v"
`include "../rtl/rx_path/crc_check.v"
`include "../rtl/rx_path/rx_fifo.v"
`include "../rtl/rx_path/rx_path_top.v"

`include "../rtl/tx_path/can_bsp.v"
`include "../rtl/tx_path/crc_gen.v"
`include "../rtl/tx_path/tx_fifo.v"
`include "../rtl/tx_path/can_tx_path_core.v"

`include "../rtl/error_management/error_management_logic.v"
`include "../rtl/can_channel/can_channel_core.v"
`include "../rtl/top/can_top.v"

`include "apb/apb_interface.sv"
`include "can/can_interface.sv"

`include "apb/apb_pkg.sv"
`include "can/can_pkg.sv"

import uvm_pkg::*;
import apb_pkg::*;
import can_pkg::*;

module top;

  logic s_apb_pclk = 0;
  logic can_clk = 0;

logic s_apb_presetn;
logic can_resetn;

  always #5 s_apb_pclk = ~s_apb_pclk;
  always #25 can_clk = ~can_clk;

apb_vif apb_vif (  .s_apb_pclk    (s_apb_pclk),  .s_apb_presetn (s_apb_presetn));

can_interface can_vif (  .can_clk    (can_clk),.can_resetn (can_resetn));


can_top DUT (
  .s_apb_pclk    (apb_vif.s_apb_pclk),
  .s_apb_presetn (apb_vif.s_apb_presetn),
  .s_apb_psel    (apb_vif.s_apb_psel),
  .s_apb_penable (apb_vif.s_apb_penable),
  .s_apb_pwrite  (apb_vif.s_apb_pwrite),
  .s_apb_paddr   (apb_vif.s_apb_paddr),
  .s_apb_pwdata  (apb_vif.s_apb_pwdata),
  .s_apb_pstrb   (apb_vif.s_apb_pstrb),
  .s_apb_pprot   (apb_vif.s_apb_pprot),
  .s_apb_prdata  (apb_vif.s_apb_prdata),
  .s_apb_pready  (apb_vif.s_apb_pready),
  .s_apb_pslverr (apb_vif.s_apb_pslverr),

  .can_clk       (can_vif.can_clk),
  .can_resetn    (can_vif.can_resetn),
  .can_rx        (can_vif.can_rx),
  .can_tx        (can_vif.can_tx),
  .can_irq       (can_vif.can_irq)
);


initial begin
  s_apb_presetn = 0;
  can_resetn = 0;
  can_vif.ext_tx  = 1'b1;

  #20;

  s_apb_presetn = 1;
  can_resetn = 1;
end

initial begin
  uvm_config_db#(virtual can_interface)::set( uvm_root::get(), "*", "vif", can_vif );
  uvm_config_db#(virtual apb_vif)::set(    uvm_root::get(), "*", "vif", apb_vif  );
end

initial begin
  uvm_config_db#(uvm_active_passive_enum)::set( null, "uvm_test_top.can_e.apb_agt", "is_active", UVM_ACTIVE );

  uvm_config_db#(uvm_active_passive_enum)::set(  null, "uvm_test_top.can_e.can_agt", "is_active", UVM_ACTIVE );

end
  initial begin
uvm_top.set_timeout(100us);
    run_test("can_ext_frame_dut_ack_virtual_seq_test");
  end

endmodule
