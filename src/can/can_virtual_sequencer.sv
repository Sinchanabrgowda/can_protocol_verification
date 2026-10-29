class can_virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(can_virtual_sequencer)

  uvm_sequencer #(apb_seq_item) seqr_apb;
  can_sequencer seqr_can;

  function new(string name = "can_virtual_sequencer",
               uvm_component parent);
    super.new(name, parent);
  endfunction

endclass
