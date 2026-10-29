class can_base_reg_seq extends uvm_sequence;
  `uvm_object_utils(can_base_reg_seq)

  can_reg_block regmodel;

  function new(string name = "can_base_reg_seq");
    super.new(name);
  endfunction

  uvm_status_e status;
  uvm_reg_data_t rdata, rdata_m, dout_t;

endclass
