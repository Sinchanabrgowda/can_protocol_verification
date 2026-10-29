class apb_driver extends uvm_driver #(apb_seq_item);
  `uvm_component_utils(apb_driver)

  virtual apb_interface vif;

  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif))
      `uvm_fatal("APB_DRIVER", "APB interface not found")
  endfunction

  task run_phase(uvm_phase phase);
    apb_seq_item req;

    vif.driver_cb.s_apb_psel    <= 1'b0;
    vif.driver_cb.s_apb_penable <= 1'b0;
    vif.driver_cb.s_apb_pwrite  <= 1'b0;
    vif.driver_cb.s_apb_paddr   <= '0;
    vif.driver_cb.s_apb_pwdata  <= '0;
    vif.driver_cb.s_apb_pstrb   <= '0;
    vif.driver_cb.s_apb_pprot   <= '0;


    forever begin
      seq_item_port.get_next_item(req);
      drive_transfer(req);
      seq_item_port.item_done();
    end
  endtask

  task drive_transfer(can_apb_seq_item req);
    @(vif.driver_cb);

    vif.driver_cb.s_apb_paddr   <= req.paddr;
    vif.driver_cb.s_apb_pwrite  <= req.pwrite;
    vif.driver_cb.s_apb_pwdata  <= req.pwdata;
    vif.driver_cb.s_apb_pstrb   <= req.pstrb;
    vif.driver_cb.s_apb_pprot   <= req.pprot;
    vif.driver_cb.s_apb_psel    <= 1'b1;
    vif.driver_cb.s_apb_penable <= 1'b0;

    @(vif.driver_cb);
    vif.driver_cb.s_apb_penable <= 1'b1;

    do begin
      @(vif.driver_cb);
    end while (vif.driver_cb.s_apb_pready !== 1'b1);

    req.prdata  = vif.driver_cb.s_apb_prdata;
    req.pslverr = vif.driver_cb.s_apb_pslverr;

    vif.driver_cb.s_apb_psel    <= 1'b0;
    vif.driver_cb.s_apb_penable <= 1'b0;
    vif.driver_cb.s_apb_pwrite  <= 1'b0;
    vif.driver_cb.s_apb_paddr   <= '0;
    vif.driver_cb.s_apb_pwdata  <= '0;
    vif.driver_cb.s_apb_pstrb   <= '0;
    vif.driver_cb.s_apb_pprot   <= '0;
  endtask

endclass
