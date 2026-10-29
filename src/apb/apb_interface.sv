interface apb_interface(input logic s_apb_pclk, input logic s_apb_presetn);

  logic [11:0] s_apb_paddr;
  logic        s_apb_psel;
  logic        s_apb_penable;
  logic        s_apb_pwrite;
  logic [31:0] s_apb_pwdata;
  logic [3:0]  s_apb_pstrb;
  logic [2:0]  s_apb_pprot;
  logic [31:0] s_apb_prdata;
  logic        s_apb_pready;
  logic        s_apb_pslverr;

  clocking driver_cb @(posedge s_apb_pclk);
    default input #0 output #0;
    output s_apb_paddr;
    output s_apb_psel;
    output s_apb_penable;
    output s_apb_pwrite;
    output s_apb_pwdata;
    output s_apb_pstrb;
    output s_apb_pprot;
    input  s_apb_prdata;
    input  s_apb_pready;
    input  s_apb_pslverr;
  endclocking

  clocking monitor_cb @(posedge s_apb_pclk);
    default input #0 output #0;
    input s_apb_paddr;
    input s_apb_psel;
    input s_apb_penable;
    input s_apb_pwrite;
    input s_apb_pwdata;
    input s_apb_pstrb;
    input s_apb_pprot;
    input s_apb_prdata;
    input s_apb_pready;
    input s_apb_pslverr;
  endclocking

  modport DRIVER (clocking driver_cb, input s_apb_pclk, s_apb_presetn);
  modport MONITOR (clocking monitor_cb, input s_apb_pclk, s_apb_presetn);
endinterface
