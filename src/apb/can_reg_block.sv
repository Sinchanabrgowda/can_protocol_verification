class can_reg_block extends uvm_reg_block;
  `uvm_object_utils(can_reg_block)

  rand srr_reg srr_reg_inst;
  rand msr_reg msr_reg_inst;
  rand brpr_reg brpr_reg_inst;
  rand btr_reg btr_reg_inst;
  rand ecr_reg ecr_reg_inst;
  rand esr_reg esr_reg_inst;
  rand sr_reg sr_reg_inst;
  rand isr_reg isr_reg_inst;
  rand ier_reg ier_reg_inst;
  rand icr_reg icr_reg_inst;
  rand tx_id_reg tx_id_reg_inst;
  rand tx_dlc_reg tx_dlc_reg_inst;
  rand tx_dw1_reg tx_dw1_reg_inst;
  rand tx_dw2_reg tx_dw2_reg_inst;
  rand txhpb_id_reg txhpb_id_reg_inst;
  rand txhpb_dlc_reg txhpb_dlc_reg_inst;
  rand txhpb_dw1_reg txhpb_dw1_reg_inst;
  rand txhpb_dw2_reg txhpb_dw2_reg_inst;
  rand rx_id_reg rx_id_reg_inst;
  rand rx_dlc_reg rx_dlc_reg_inst;
  rand rx_dw1_reg rx_dw1_reg_inst;
  rand rx_dw2_reg rx_dw2_reg_inst;
  rand afr_reg afr_reg_inst;
  rand afmr_reg afmr1_reg_inst;
  rand afir_reg afir1_reg_inst;
  rand afmr_reg afmr2_reg_inst;
  rand afir_reg afir2_reg_inst;
  rand afmr_reg afmr3_reg_inst;
  rand afir_reg afir3_reg_inst;
  rand afmr_reg afmr4_reg_inst;
  rand afir_reg afir4_reg_inst;

  function new(string name = "can_reg_block");
    super.new(name, build_coverage(UVM_NO_COVERAGE));
  endfunction

  function void build();
    uvm_reg::include_coverage("*", UVM_CVR_ALL);

    srr_reg_inst = srr_reg::type_id::create("srr_reg_inst");
    srr_reg_inst.build();
    srr_reg_inst.configure(this);
    srr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    msr_reg_inst = msr_reg::type_id::create("msr_reg_inst");
    msr_reg_inst.build();
    msr_reg_inst.configure(this);
    msr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    brpr_reg_inst = brpr_reg::type_id::create("brpr_reg_inst");
    brpr_reg_inst.build();
    brpr_reg_inst.configure(this);
    brpr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    btr_reg_inst = btr_reg::type_id::create("btr_reg_inst");
    btr_reg_inst.build();
    btr_reg_inst.configure(this);
    btr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    ecr_reg_inst = ecr_reg::type_id::create("ecr_reg_inst");
    ecr_reg_inst.build();
    ecr_reg_inst.configure(this);
    ecr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    esr_reg_inst = esr_reg::type_id::create("esr_reg_inst");
    esr_reg_inst.build();
    esr_reg_inst.configure(this);
    esr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    sr_reg_inst = sr_reg::type_id::create("sr_reg_inst");
    sr_reg_inst.build();
    sr_reg_inst.configure(this);
    sr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    isr_reg_inst = isr_reg::type_id::create("isr_reg_inst");
    isr_reg_inst.build();
    isr_reg_inst.configure(this);
    isr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    ier_reg_inst = ier_reg::type_id::create("ier_reg_inst");
    ier_reg_inst.build();
    ier_reg_inst.configure(this);
    ier_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    icr_reg_inst = icr_reg::type_id::create("icr_reg_inst");
    icr_reg_inst.build();
    icr_reg_inst.configure(this);
    icr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    tx_id_reg_inst = tx_id_reg::type_id::create("tx_id_reg_inst");
    tx_id_reg_inst.build();
    tx_id_reg_inst.configure(this);
    tx_id_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    tx_dlc_reg_inst = tx_dlc_reg::type_id::create("tx_dlc_reg_inst");
    tx_dlc_reg_inst.build();
    tx_dlc_reg_inst.configure(this);
    tx_dlc_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    tx_dw1_reg_inst = tx_dw1_reg::type_id::create("tx_dw1_reg_inst");
    tx_dw1_reg_inst.build();
    tx_dw1_reg_inst.configure(this);
    tx_dw1_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    tx_dw2_reg_inst = tx_dw2_reg::type_id::create("tx_dw2_reg_inst");
    tx_dw2_reg_inst.build();
    tx_dw2_reg_inst.configure(this);
    tx_dw2_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    txhpb_id_reg_inst = txhpb_id_reg::type_id::create("txhpb_id_reg_inst");
    txhpb_id_reg_inst.build();
    txhpb_id_reg_inst.configure(this);
    txhpb_id_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    txhpb_dlc_reg_inst = txhpb_dlc_reg::type_id::create("txhpb_dlc_reg_inst");
    txhpb_dlc_reg_inst.build();
    txhpb_dlc_reg_inst.configure(this);
    txhpb_dlc_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    txhpb_dw1_reg_inst = txhpb_dw1_reg::type_id::create("txhpb_dw1_reg_inst");
    txhpb_dw1_reg_inst.build();
    txhpb_dw1_reg_inst.configure(this);
    txhpb_dw1_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    txhpb_dw2_reg_inst = txhpb_dw2_reg::type_id::create("txhpb_dw2_reg_inst");
    txhpb_dw2_reg_inst.build();
    txhpb_dw2_reg_inst.configure(this);
    txhpb_dw2_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    rx_id_reg_inst = rx_id_reg::type_id::create("rx_id_reg_inst");
    rx_id_reg_inst.build();
    rx_id_reg_inst.configure(this);
    rx_id_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    rx_dlc_reg_inst = rx_dlc_reg::type_id::create("rx_dlc_reg_inst");
    rx_dlc_reg_inst.build();
    rx_dlc_reg_inst.configure(this);
    rx_dlc_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    rx_dw1_reg_inst = rx_dw1_reg::type_id::create("rx_dw1_reg_inst");
    rx_dw1_reg_inst.build();
    rx_dw1_reg_inst.configure(this);
    rx_dw1_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    rx_dw2_reg_inst = rx_dw2_reg::type_id::create("rx_dw2_reg_inst");
    rx_dw2_reg_inst.build();
    rx_dw2_reg_inst.configure(this);
    rx_dw2_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    afr_reg_inst = afr_reg::type_id::create("afr_reg_inst");
    afr_reg_inst.build();
    afr_reg_inst.configure(this);
    afr_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    afmr1_reg_inst = afmr_reg::type_id::create("afmr1_reg_inst");
    afmr1_reg_inst.build();
    afmr1_reg_inst.configure(this);
    afmr1_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    afir1_reg_inst = afir_reg::type_id::create("afir1_reg_inst");
    afir1_reg_inst.build();
    afir1_reg_inst.configure(this);
    afir1_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    afmr2_reg_inst = afmr_reg::type_id::create("afmr2_reg_inst");
    afmr2_reg_inst.build();
    afmr2_reg_inst.configure(this);
    afmr2_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    afir2_reg_inst = afir_reg::type_id::create("afir2_reg_inst");
    afir2_reg_inst.build();
    afir2_reg_inst.configure(this);
    afir2_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    afmr3_reg_inst = afmr_reg::type_id::create("afmr3_reg_inst");
    afmr3_reg_inst.build();
    afmr3_reg_inst.configure(this);
    afmr3_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    afir3_reg_inst = afir_reg::type_id::create("afir3_reg_inst");
    afir3_reg_inst.build();
    afir3_reg_inst.configure(this);
    afir3_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    afmr4_reg_inst = afmr_reg::type_id::create("afmr4_reg_inst");
    afmr4_reg_inst.build();
    afmr4_reg_inst.configure(this);
    afmr4_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    afir4_reg_inst = afir_reg::type_id::create("afir4_reg_inst");
    afir4_reg_inst.build();
    afir4_reg_inst.configure(this);
    afir4_reg_inst.set_coverage(UVM_CVR_FIELD_VALS);

    default_map = create_map("default_map", 'h000, 4, UVM_LITTLE_ENDIAN);

    default_map.add_reg(srr_reg_inst,       'h000, "RW");
    default_map.add_reg(msr_reg_inst,       'h004, "RW");
    default_map.add_reg(brpr_reg_inst,      'h008, "RW");
    default_map.add_reg(btr_reg_inst,       'h00C, "RW");
    default_map.add_reg(ecr_reg_inst,       'h010, "RO");
    default_map.add_reg(esr_reg_inst,       'h014, "RW");
    default_map.add_reg(sr_reg_inst,        'h018, "RO");
    default_map.add_reg(isr_reg_inst,       'h01C, "RO");
    default_map.add_reg(ier_reg_inst,       'h020, "RW");
    default_map.add_reg(icr_reg_inst,       'h024, "WO");

    default_map.add_reg(tx_id_reg_inst,     'h030, "WO");
    default_map.add_reg(tx_dlc_reg_inst,    'h034, "WO");
    default_map.add_reg(tx_dw1_reg_inst,    'h038, "WO");
    default_map.add_reg(tx_dw2_reg_inst,    'h03C, "WO");

    default_map.add_reg(txhpb_id_reg_inst,  'h040, "WO");
    default_map.add_reg(txhpb_dlc_reg_inst, 'h044, "WO");
    default_map.add_reg(txhpb_dw1_reg_inst, 'h048, "WO");
    default_map.add_reg(txhpb_dw2_reg_inst, 'h04C, "WO");

    default_map.add_reg(rx_id_reg_inst,     'h050, "RO");
    default_map.add_reg(rx_dlc_reg_inst,    'h054, "RO");
    default_map.add_reg(rx_dw1_reg_inst,    'h058, "RO");
    default_map.add_reg(rx_dw2_reg_inst,    'h05C, "RO");

    default_map.add_reg(afr_reg_inst,       'h060, "RW");
    default_map.add_reg(afmr1_reg_inst,     'h064, "RW");
    default_map.add_reg(afir1_reg_inst,     'h068, "RW");
    default_map.add_reg(afmr2_reg_inst,     'h06C, "RW");
    default_map.add_reg(afir2_reg_inst,     'h070, "RW");
    default_map.add_reg(afmr3_reg_inst,     'h074, "RW");
    default_map.add_reg(afir3_reg_inst,     'h078, "RW");
    default_map.add_reg(afmr4_reg_inst,     'h07C, "RW");
    default_map.add_reg(afir4_reg_inst,     'h080, "RW");

    lock_model();
  endfunction
endclass

