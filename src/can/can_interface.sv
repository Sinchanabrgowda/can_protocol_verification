interface can_interface(
  input logic can_clk,
  input logic can_resetn
);

  logic can_rx;
  logic can_tx;
  logic can_irq;

  logic ext_tx;
  wire can_bus;
  
  assign can_bus = can_tx & ext_tx;
  assign can_rx  = can_bus;


  clocking driver_cb @(posedge can_clk);
    default input #0 output #0;
    output ext_tx;
    input can_bus, can_tx, can_irq;  
endclocking

  clocking monitor_cb @(posedge can_clk);
    default input #0 output #0;
    input can_bus, can_rx, can_tx, can_irq;
  endclocking


  modport DRIVER (
    clocking driver_cb,
    input can_clk,
    input can_resetn
  );

  modport MONITOR (
    clocking monitor_cb,
    input can_clk,
    input can_resetn
  );

endinterface
