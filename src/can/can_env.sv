class can_env extends uvm_env;
  `uvm_component_utils(can_env)

  apb_agent apb_agt;
  can_agent can_agt;

  can_virtual_sequencer virtual_seqr;

  can_reg_block can_regmodel;
  can_adapter can_adapter;
  uvm_reg_predictor #(apb_seq_item) can_predictor_inst;

  can_scoreboard can_scb;
  can_subscriber can_subscrb;

  function new(string name = "can_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction


function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  uvm_config_db#(uvm_active_passive_enum)::set(
    this, "apb_agt", "is_active", UVM_ACTIVE
  );

  uvm_config_db#(uvm_active_passive_enum)::set(
    this, "can_agt", "is_active", UVM_PASSIVE
  );

  virtual_seqr = can_virtual_sequencer::type_id::create("virtual_seqr", this);

  apb_agt = apb_agent::type_id::create("apb_agt", this);
  can_agt = can_agent::type_id::create("can_agt", this);

  can_regmodel = can_reg_block::type_id::create("can_regmodel", this);
  can_regmodel.build();

  can_adapter = can_adapter::type_id::create("can_adapter", this);

  can_predictor_inst =
    uvm_reg_predictor#(apb_seq_item)::type_id::create(
      "can_predictor_inst", this
    );

  can_scb = can_scoreboard::type_id::create("can_scb", this);
  can_subscrb = can_subscriber::type_id::create("can_subscrb", this);
endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    virtual_seqr.seqr_apb = apb_agt.sequencer;
    virtual_seqr.seqr_can = can_agt.sequencer;

    can_regmodel.default_map.set_sequencer(
      .sequencer(apb_agt.sequencer),
      .adapter(can_adapter)
    );

    can_regmodel.default_map.set_base_addr(0);

    can_predictor_inst.map = can_regmodel.default_map;
    can_predictor_inst.adapter = can_adapter;

    apb_agt.active_monitor.analysis_port.connect(
      can_predictor_inst.bus_in
    );

    can_regmodel.default_map.set_auto_predict(0);

    apb_agt.active_monitor.analysis_port.connect(
      can_scb.apb_active_imp
    );

    apb_agt.passive_monitor.analysis_port.connect(
      can_scb.apb_passive_imp
    );

    can_agt.active_monitor.analysis_port.connect(
      can_scb.can_active_imp
    );

    can_agt.passive_monitor.analysis_port.connect(
      can_scb.can_passive_imp
    );

    apb_agt.active_monitor.analysis_port.connect(
      can_subscrb.apb_active_port
    );

    apb_agt.passive_monitor.analysis_port.connect(
      can_subscrb.apb_passive_port
    );

    can_agt.active_monitor.analysis_port.connect(
      can_subscrb.can_active_port
    );

    can_agt.passive_monitor.analysis_port.connect(
      can_subscrb.can_passive_port
    );
  endfunction

endclass
