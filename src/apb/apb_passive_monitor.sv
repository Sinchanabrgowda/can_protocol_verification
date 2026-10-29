class apb_passive_monitor extends uvm_monitor;
  `uvm_component_utils(apb_passive_monitor)

  virtual apb_interface vif;

  uvm_analysis_port #(apb_seq_item) analysis_port;

  function new(string name = "apb_passive_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "vif", vif))
      `uvm_fatal("APB_PASSIVE_MONITOR", "APB interface not found")
  endfunction

  task run_phase(uvm_phase phase);
    apb_seq_item tr;

    forever begin
      @(vif.monitor_cb);

      if (vif.monitor_cb.s_apb_psel === 1'b1 &&
          vif.monitor_cb.s_apb_penable === 1'b1 &&
          vif.monitor_cb.s_apb_pready === 1'b1) begin

        tr = can_apb_seq_item::type_id::create("tr", this);

        tr.paddr   = vif.monitor_cb.s_apb_paddr;
        tr.pwrite  = vif.monitor_cb.s_apb_pwrite;
        tr.pwdata  = vif.monitor_cb.s_apb_pwdata;
        tr.pstrb   = vif.monitor_cb.s_apb_pstrb;
        tr.pprot   = vif.monitor_cb.s_apb_pprot;
        tr.prdata  = vif.monitor_cb.s_apb_prdata;
        tr.pslverr = vif.monitor_cb.s_apb_pslverr;

        analysis_port.write(tr);
      end
    end
  endtask

endclass
