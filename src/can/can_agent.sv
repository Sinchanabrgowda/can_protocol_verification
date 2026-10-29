class can_agent extends uvm_agent;
  `uvm_component_utils(can_agent)

  can_sequencer sequencer;
  can_driver driver;
  can_active_monitor active_monitor;
  can_passive_monitor passive_monitor;

  function new(string name = "can_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    assert(uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active));

    if (get_is_active() == UVM_ACTIVE) begin
      sequencer = can_sequencer::type_id::create("sequencer", this);
      driver = can_driver::type_id::create("driver", this);
      active_monitor = can_active_monitor::type_id::create("active_monitor", this);
    end
    else begin
      passive_monitor = can_passive_monitor::type_id::create("passive_monitor", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (get_is_active() == UVM_ACTIVE)
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

endclass
