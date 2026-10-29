class srr_reg extends uvm_reg;
  `uvm_object_utils(srr_reg)

  rand uvm_reg_field cen_alias;
  rand uvm_reg_field cen;
  rand uvm_reg_field srst;
  rand uvm_reg_field reserved_31;
  rand uvm_reg_field reserved_29_2;

  function new(string name = "srr_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build;

    reserved_31 = uvm_reg_field::type_id::create("reserved_31");
    reserved_31.configure(this, 1, 31, "RO", 0, 1'h0, 1, 1, 1);

    cen_alias = uvm_reg_field::type_id::create("cen_alias");
    cen_alias.configure(this, 1, 30, "WO", 0, 1'h0, 1, 1, 1);

    reserved_29_2 = uvm_reg_field::type_id::create("reserved_29_2");
    reserved_29_2.configure(this, 28, 2, "RO", 0, 28'h0, 1, 1, 1);

    cen = uvm_reg_field::type_id::create("cen");
    cen.configure(this, 1, 1, "RW", 0, 1'h0, 1, 1, 1);

    srst = uvm_reg_field::type_id::create("srst");
    srst.configure(this, 1, 0, "WO", 0, 1'h0, 1, 1, 1);

  endfunction
endclass


//MSR
class msr_reg extends uvm_reg;
  `uvm_object_utils(msr_reg)

  rand uvm_reg_field sleep_alias;
  rand uvm_reg_field lback_alias;
  rand uvm_reg_field reserved_29_2;
  rand uvm_reg_field lback;
  rand uvm_reg_field sleep;

  function new(string name = "msr_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build;
    sleep_alias = uvm_reg_field::type_id::create("sleep_alias");
    sleep_alias.configure(this, 1, 31, "WO", 0, 1'h0, 1, 1, 1);

    lback_alias = uvm_reg_field::type_id::create("lback_alias");
    lback_alias.configure(this, 1, 30, "WO", 0, 1'h0, 1, 1, 1);

    reserved_29_2 = uvm_reg_field::type_id::create("reserved_29_2");
    reserved_29_2.configure(this, 28, 2, "RO", 0, 28'h0, 1, 1, 1);

    lback = uvm_reg_field::type_id::create("lback");
    lback.configure(this, 1, 1, "RW", 0, 1'h0, 1, 1, 1);

    sleep = uvm_reg_field::type_id::create("sleep");
    sleep.configure(this, 1, 0, "RW", 0, 1'h0, 1, 1, 1);
  endfunction
endclass


//BRPR
class brpr_reg extends uvm_reg;
  `uvm_object_utils(brpr_reg)

  rand uvm_reg_field brp;
  rand uvm_reg_field reserved;

  function new(string name = "brpr_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build;
    brp = uvm_reg_field::type_id::create("brp");
    brp.configure(this, 8, 0, "RW", 0, 8'h0, 1, 1, 1);

    reserved = uvm_reg_field::type_id::create("reserved");
    reserved.configure(this, 24, 8, "RO", 0, 24'h0, 1, 1, 1);
  endfunction
endclass


//BTR
class btr_reg extends uvm_reg;
  `uvm_object_utils(btr_reg)

  rand uvm_reg_field sjw;
  rand uvm_reg_field tseg2;
  rand uvm_reg_field tseg1;
 rand uvm_reg_field reserved;

  function new(string name = "btr_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build;
    sjw = uvm_reg_field::type_id::create("sjw");
    sjw.configure(this, 2, 7, "RW", 0, 2'h1, 1, 1, 1);

    tseg2 = uvm_reg_field::type_id::create("tseg2");
    tseg2.configure(this, 3, 4, "RW", 0, 3'h2, 1, 1, 1);

    tseg1 = uvm_reg_field::type_id::create("tseg1");
    tseg1.configure(this, 4, 0, "RW", 0, 4'h5, 1, 1, 1);

    reserved = uvm_reg_field::type_id::create("reserved");
    reserved.configure(this, 23, 9, "RO", 0, 23'h0, 1, 1, 1);
  endfunction
endclass


//ECR
class ecr_reg extends uvm_reg;
  `uvm_object_utils(ecr_reg)

  rand uvm_reg_field rec;
  rand uvm_reg_field tec;
  rand uvm_reg_field reserved;

  function new(string name = "ecr_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build;
    rec = uvm_reg_field::type_id::create("rec");
    rec.configure(this, 8, 8, "RO", 1, 8'h0, 1, 1, 1);

    tec = uvm_reg_field::type_id::create("tec");
    tec.configure(this, 8, 0, "RO", 1, 8'h0, 1, 1, 1);

    reserved = uvm_reg_field::type_id::create("reserved");
    reserved.configure(this, 16, 16, "RO", 0, 16'h0, 1, 1, 1);
  endfunction
endclass


//ESR
class esr_reg extends uvm_reg;
  `uvm_object_utils(esr_reg)

  rand uvm_reg_field acker;
  rand uvm_reg_field berr;
  rand uvm_reg_field ster;
  rand uvm_reg_field fmer;
  rand uvm_reg_field crcer;
  rand uvm_reg_field reserved_26_5;
  rand uvm_reg_field acker_mirror;
  rand uvm_reg_field berr_mirror;
  rand uvm_reg_field ster_mirror;
  rand uvm_reg_field fmer_mirror;
  rand uvm_reg_field crcer_mirror;

  function new(string name = "esr_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build;
    acker = uvm_reg_field::type_id::create("acker");
    acker.configure(this, 1, 31, "W1C", 1, 1'h0, 1, 1, 1);

    berr = uvm_reg_field::type_id::create("berr");
    berr.configure(this, 1, 30, "W1C", 1, 1'h0, 1, 1, 1);

    ster = uvm_reg_field::type_id::create("ster");
    ster.configure(this, 1, 29, "W1C", 1, 1'h0, 1, 1, 1);

    fmer = uvm_reg_field::type_id::create("fmer");
    fmer.configure(this, 1, 28, "W1C", 1, 1'h0, 1, 1, 1);

    crcer = uvm_reg_field::type_id::create("crcer");
    crcer.configure(this, 1, 27, "W1C", 1, 1'h0, 1, 1, 1);

    reserved_26_5 = uvm_reg_field::type_id::create("reserved_26_5");
    reserved_26_5.configure(this, 22, 5, "RO", 1, 22'h0, 1, 1, 1);

    acker_mirror = uvm_reg_field::type_id::create("acker_mirror");
    acker_mirror.configure(this, 1, 4, "W1C", 1, 1'h0, 1, 1, 1);

    berr_mirror = uvm_reg_field::type_id::create("berr_mirror");
    berr_mirror.configure(this, 1, 3, "W1C", 1, 1'h0, 1, 1, 1);

    ster_mirror = uvm_reg_field::type_id::create("ster_mirror");
    ster_mirror.configure(this, 1, 2, "W1C", 1, 1'h0, 1, 1, 1);

    fmer_mirror = uvm_reg_field::type_id::create("fmer_mirror");
    fmer_mirror.configure(this, 1, 1, "W1C", 1, 1'h0, 1, 1, 1);

    crcer_mirror = uvm_reg_field::type_id::create("crcer_mirror");
    crcer_mirror.configure(this, 1, 0, "W1C", 1, 1'h0, 1, 1, 1);
  endfunction
endclass


//SR
class sr_reg extends uvm_reg;
  `uvm_object_utils(sr_reg)

  rand uvm_reg_field config;
  rand uvm_reg_field lback;
  rand uvm_reg_field sleep;
  rand uvm_reg_field normal;
  rand uvm_reg_field bidle;
  rand uvm_reg_field bbsy;
  rand uvm_reg_field errwrn;
  rand uvm_reg_field estat;
  rand uvm_reg_field txbfll;
  rand uvm_reg_field txfll;
  rand uvm_reg_field acfbsy;
  rand uvm_reg_field reserved_19_12;

  rand uvm_reg_field acfbsy_mirror;
  rand uvm_reg_field txfll_mirror;
  rand uvm_reg_field txbfll_mirror;
  rand uvm_reg_field estat_mirror;
  rand uvm_reg_field errwrn_mirror;
  rand uvm_reg_field bbsy_mirror;
  rand uvm_reg_field bidle_mirror;
  rand uvm_reg_field normal_mirror;
  rand uvm_reg_field sleep_mirror;
  rand uvm_reg_field lback_mirror;
  rand uvm_reg_field config_mirror;

  function new(string name = "sr_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build;

    config = uvm_reg_field::type_id::create("config");
    config.configure(this, 1, 31, "RO", 1, 1'h1, 1, 1, 1);

    lback = uvm_reg_field::type_id::create("lback");
    lback.configure(this, 1, 30, "RO", 1, 1'h0, 1, 1, 1);

    sleep = uvm_reg_field::type_id::create("sleep");
    sleep.configure(this, 1, 29, "RO", 1, 1'h0, 1, 1, 1);

    normal = uvm_reg_field::type_id::create("normal");
    normal.configure(this, 1, 28, "RO", 1, 1'h0, 1, 1, 1);

    bidle = uvm_reg_field::type_id::create("bidle");
    bidle.configure(this, 1, 27, "RO", 1, 1'h1, 1, 1, 1);

    bbsy = uvm_reg_field::type_id::create("bbsy");
    bbsy.configure(this, 1, 26, "RO", 1, 1'h0, 1, 1, 1);

    errwrn = uvm_reg_field::type_id::create("errwrn");
    errwrn.configure(this, 1, 25, "RO", 1, 1'h0, 1, 1, 1);

    estat = uvm_reg_field::type_id::create("estat");
    estat.configure(this, 2, 23, "RO", 1, 2'b00, 1, 1, 1);

    txbfll = uvm_reg_field::type_id::create("txbfll");
    txbfll.configure(this, 1, 22, "RO", 1, 1'h0, 1, 1, 1);

    txfll = uvm_reg_field::type_id::create("txfll");
    txfll.configure(this, 1, 21, "RO", 1, 1'h0, 1, 1, 1);

    acfbsy = uvm_reg_field::type_id::create("acfbsy");
    acfbsy.configure(this, 1, 20, "RO", 0, 1'h0, 1, 1, 1);

    reserved_19_12 = uvm_reg_field::type_id::create("reserved_19_12");
    reserved_19_12.configure(this, 8, 12, "RO", 0, 8'h00, 1, 1, 1);

    acfbsy_mirror = uvm_reg_field::type_id::create("acfbsy_mirror");
    acfbsy_mirror.configure(this, 1, 11, "RO", 0, 1'h0, 1, 1, 1);

    txfll_mirror = uvm_reg_field::type_id::create("txfll_mirror");
    txfll_mirror.configure(this, 1, 10, "RO", 1, 1'h0, 1, 1, 1);

    txbfll_mirror = uvm_reg_field::type_id::create("txbfll_mirror");
    txbfll_mirror.configure(this, 1, 9, "RO", 1, 1'h0, 1, 1, 1);

    estat_mirror = uvm_reg_field::type_id::create("estat_mirror");
    estat_mirror.configure(this, 2, 7, "RO", 1, 2'b00, 1, 1, 1);

    errwrn_mirror = uvm_reg_field::type_id::create("errwrn_mirror");
    errwrn_mirror.configure(this, 1, 6, "RO", 1, 1'h0, 1, 1, 1);

    bbsy_mirror = uvm_reg_field::type_id::create("bbsy_mirror");
    bbsy_mirror.configure(this, 1, 5, "RO", 1, 1'h0, 1, 1, 1);

    bidle_mirror = uvm_reg_field::type_id::create("bidle_mirror");
    bidle_mirror.configure(this, 1, 4, "RO", 1, 1'h1, 1, 1, 1);

    normal_mirror = uvm_reg_field::type_id::create("normal_mirror");
    normal_mirror.configure(this, 1, 3, "RO", 1, 1'h0, 1, 1, 1);

    sleep_mirror = uvm_reg_field::type_id::create("sleep_mirror");
    sleep_mirror.configure(this, 1, 2, "RO", 1, 1'h0, 1, 1, 1);

    lback_mirror = uvm_reg_field::type_id::create("lback_mirror");
    lback_mirror.configure(this, 1, 1, "RO", 1, 1'h0, 1, 1, 1);

    config_mirror = uvm_reg_field::type_id::create("config_mirror");
    config_mirror.configure(this, 1, 0, "RO", 1, 1'h1, 1, 1, 1);

  endfunction
endclass


//ISR
class isr_reg extends uvm_reg;
  `uvm_object_utils(isr_reg)

  rand uvm_reg_field arblst;
  rand uvm_reg_field txok;
  rand uvm_reg_field txfll;
  rand uvm_reg_field txbfll;
  rand uvm_reg_field rxok;
  rand uvm_reg_field rxuflw;
  rand uvm_reg_field rxoflw;
  rand uvm_reg_field rxnemp;
  rand uvm_reg_field error;
  rand uvm_reg_field bsoff;
  rand uvm_reg_field sleep;
  rand uvm_reg_field wkup;
  rand uvm_reg_field reserved_19_12;

  rand uvm_reg_field arblst_mirror;
  rand uvm_reg_field txok_mirror;
  rand uvm_reg_field txfll_mirror;
  rand uvm_reg_field txbfll_mirror;
  rand uvm_reg_field rxok_mirror;
  rand uvm_reg_field rxuflw_mirror;
  rand uvm_reg_field rxoflw_mirror;
  rand uvm_reg_field rxnemp_mirror;
  rand uvm_reg_field error_mirror;
  rand uvm_reg_field bsoff_mirror;
  rand uvm_reg_field sleep_mirror;
  rand uvm_reg_field wkup_mirror;

  function new(string name = "isr_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build;

    arblst = uvm_reg_field::type_id::create("arblst");
    arblst.configure(this, 1, 31, "RO", 1, 1'h0, 1, 1, 1);

    txok = uvm_reg_field::type_id::create("txok");
    txok.configure(this, 1, 30, "RO", 1, 1'h0, 1, 1, 1);

    txfll = uvm_reg_field::type_id::create("txfll");
    txfll.configure(this, 1, 29, "RO", 1, 1'h0, 1, 1, 1);

    txbfll = uvm_reg_field::type_id::create("txbfll");
    txbfll.configure(this, 1, 28, "RO", 1, 1'h0, 1, 1, 1);

    rxok = uvm_reg_field::type_id::create("rxok");
    rxok.configure(this, 1, 27, "RO", 1, 1'h0, 1, 1, 1);

    rxuflw = uvm_reg_field::type_id::create("rxuflw");
    rxuflw.configure(this, 1, 26, "RO", 1, 1'h0, 1, 1, 1);

    rxoflw = uvm_reg_field::type_id::create("rxoflw");
    rxoflw.configure(this, 1, 25, "RO", 1, 1'h0, 1, 1, 1);

    rxnemp = uvm_reg_field::type_id::create("rxnemp");
    rxnemp.configure(this, 1, 24, "RO", 1, 1'h0, 1, 1, 1);

    error = uvm_reg_field::type_id::create("error");
    error.configure(this, 1, 23, "RO", 1, 1'h0, 1, 1, 1);

    bsoff = uvm_reg_field::type_id::create("bsoff");
    bsoff.configure(this, 1, 22, "RO", 1, 1'h0, 1, 1, 1);

    sleep = uvm_reg_field::type_id::create("sleep");
    sleep.configure(this, 1, 21, "RO", 1, 1'h0, 1, 1, 1);

    wkup = uvm_reg_field::type_id::create("wkup");
    wkup.configure(this, 1, 20, "RO", 1, 1'h0, 1, 1, 1);

    reserved_19_12 = uvm_reg_field::type_id::create("reserved_19_12");
    reserved_19_12.configure(this, 8, 12, "RO", 0, 8'h00, 1, 1, 1);

    arblst_mirror = uvm_reg_field::type_id::create("arblst_mirror");
    arblst_mirror.configure(this, 1, 0, "RO", 1, 1'h0, 1, 1, 1);

    txok_mirror = uvm_reg_field::type_id::create("txok_mirror");
    txok_mirror.configure(this, 1, 1, "RO", 1, 1'h0, 1, 1, 1);

    txfll_mirror = uvm_reg_field::type_id::create("txfll_mirror");
    txfll_mirror.configure(this, 1, 2, "RO", 1, 1'h0, 1, 1, 1);

    txbfll_mirror = uvm_reg_field::type_id::create("txbfll_mirror");
    txbfll_mirror.configure(this, 1, 3, "RO", 1, 1'h0, 1, 1, 1);

    rxok_mirror = uvm_reg_field::type_id::create("rxok_mirror");
    rxok_mirror.configure(this, 1, 4, "RO", 1, 1'h0, 1, 1, 1);

    rxuflw_mirror = uvm_reg_field::type_id::create("rxuflw_mirror");
    rxuflw_mirror.configure(this, 1, 5, "RO", 1, 1'h0, 1, 1, 1);

    rxoflw_mirror = uvm_reg_field::type_id::create("rxoflw_mirror");
    rxoflw_mirror.configure(this, 1, 6, "RO", 1, 1'h0, 1, 1, 1);

    rxnemp_mirror = uvm_reg_field::type_id::create("rxnemp_mirror");
    rxnemp_mirror.configure(this, 1, 7, "RO", 1, 1'h0, 1, 1, 1);

    error_mirror = uvm_reg_field::type_id::create("error_mirror");
    error_mirror.configure(this, 1, 8, "RO", 1, 1'h0, 1, 1, 1);

    bsoff_mirror = uvm_reg_field::type_id::create("bsoff_mirror");
    bsoff_mirror.configure(this, 1, 9, "RO", 1, 1'h0, 1, 1, 1);

    sleep_mirror = uvm_reg_field::type_id::create("sleep_mirror");
    sleep_mirror.configure(this, 1, 10, "RO", 1, 1'h0, 1, 1, 1);

    wkup_mirror = uvm_reg_field::type_id::create("wkup_mirror");
    wkup_mirror.configure(this, 1, 11, "RO", 1, 1'h0, 1, 1, 1);

  endfunction
endclass

//IER
class ier_reg extends uvm_reg;
  `uvm_object_utils(ier_reg)

  rand uvm_reg_field ie;

  function new(string name = "ier_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build;
    ie = uvm_reg_field::type_id::create("ie");
    ie.configure(this, 32, 0, "RW", 0, 32'h00000000, 1, 1, 1);
  endfunction
endclass

//ICR
class icr_reg extends uvm_reg;
  `uvm_object_utils(icr_reg)

  rand uvm_reg_field ic;

  function new(string name = "icr_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build;
    ic = uvm_reg_field::type_id::create("ic");
    ic.configure(this, 32, 0, "WO", 0, 32'h00000000, 0, 1, 1);
  endfunction
endclass


//TX_ID
class tx_id_reg extends uvm_reg;
  `uvm_object_utils(tx_id_reg)

  rand uvm_reg_field id_base;
  rand uvm_reg_field reserved_20;
  rand uvm_reg_field ide;
  rand uvm_reg_field id_ext;
  rand uvm_reg_field rtr;

  function new(string name = "tx_id_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    id_base = uvm_reg_field::type_id::create("id_base");
    id_base.configure(this, 11, 21, "WO", 0, 11'h000, 0, 1, 1);

    reserved_20 = uvm_reg_field::type_id::create("reserved_20");
    reserved_20.configure(this, 1, 20, "WO", 0, 1'h0, 0, 1, 1);

    ide = uvm_reg_field::type_id::create("ide");
    ide.configure(this, 1, 19, "WO", 0, 1'h0, 0, 1, 1);

    id_ext = uvm_reg_field::type_id::create("id_ext");
    id_ext.configure(this, 18, 1, "WO", 0, 18'h00000, 0, 1, 1);

    rtr = uvm_reg_field::type_id::create("rtr");
    rtr.configure(this, 1, 0, "WO", 0, 1'h0, 0, 1, 1);
  endfunction
endclass


//TX_DLC
class tx_dlc_reg extends uvm_reg;
  `uvm_object_utils(tx_dlc_reg)

  rand uvm_reg_field dlc_alias;
  rand uvm_reg_field reserved_27_4;
  rand uvm_reg_field dlc;

  function new(string name = "tx_dlc_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    dlc_alias = uvm_reg_field::type_id::create("dlc_alias");
    dlc_alias.configure(this, 4, 28, "WO", 0, 4'h0, 0, 1, 1);

    reserved_27_4 = uvm_reg_field::type_id::create("reserved_27_4");
    reserved_27_4.configure(this, 24, 4, "RO", 0, 24'h000000, 0, 1, 1);

    dlc = uvm_reg_field::type_id::create("dlc");
    dlc.configure(this, 4, 0, "WO", 0, 4'h0, 0, 1, 1);
  endfunction
endclass

//TX_DW1
class tx_dw1_reg extends uvm_reg;
  `uvm_object_utils(tx_dw1_reg)

  rand uvm_reg_field data;

  function new(string name = "tx_dw1_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "WO", 0, 32'h00000000, 0, 1, 1);
  endfunction
endclass


//TX_DW2
class tx_dw2_reg extends uvm_reg;
  `uvm_object_utils(tx_dw2_reg)

  rand uvm_reg_field data;

  function new(string name = "tx_dw2_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "WO", 0, 32'h00000000, 0, 1, 1);
  endfunction
endclass


//TX_HPB_ID
class txhpb_id_reg extends uvm_reg;
  `uvm_object_utils(txhpb_id_reg)

  rand uvm_reg_field id_base;
  rand uvm_reg_field reserved_20;
  rand uvm_reg_field ide;
  rand uvm_reg_field id_ext;
  rand uvm_reg_field rtr;

  function new(string name = "txhpb_id_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    id_base = uvm_reg_field::type_id::create("id_base");
    id_base.configure(this, 11, 21, "WO", 0, 11'h000, 0, 1, 1);

    reserved_20 = uvm_reg_field::type_id::create("reserved_20");
    reserved_20.configure(this, 1, 20, "WO", 0, 1'h0, 0, 1, 1);

    ide = uvm_reg_field::type_id::create("ide");
    ide.configure(this, 1, 19, "WO", 0, 1'h0, 0, 1, 1);

    id_ext = uvm_reg_field::type_id::create("id_ext");
    id_ext.configure(this, 18, 1, "WO", 0, 18'h00000, 0, 1, 1);

    rtr = uvm_reg_field::type_id::create("rtr");
    rtr.configure(this, 1, 0, "WO", 0, 1'h0, 0, 1, 1);
  endfunction
endclass


//TX_HPB_DLC
class txhpb_dlc_reg extends uvm_reg;
  `uvm_object_utils(txhpb_dlc_reg)

  rand uvm_reg_field dlc_alias;
  rand uvm_reg_field reserved_27_4;
  rand uvm_reg_field dlc;

  function new(string name = "txhpb_dlc_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    dlc_alias = uvm_reg_field::type_id::create("dlc_alias");
    dlc_alias.configure(this, 4, 28, "WO", 0, 4'h0, 0, 1, 1);

    reserved_27_4 = uvm_reg_field::type_id::create("reserved_27_4");
    reserved_27_4.configure(this, 24, 4, "RO", 0, 24'h000000, 0, 1, 1);

    dlc = uvm_reg_field::type_id::create("dlc");
    dlc.configure(this, 4, 0, "WO", 0, 4'h0, 0, 1, 1);
  endfunction
endclass


//TX_HPB_DW1
class txhpb_dw1_reg extends uvm_reg;
  `uvm_object_utils(txhpb_dw1_reg)

  rand uvm_reg_field data;

  function new(string name = "txhpb_dw1_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "WO", 0, 32'h00000000, 0, 1, 1);
  endfunction
endclass


//TX_HPB_DW2
class txhpb_dw2_reg extends uvm_reg;
  `uvm_object_utils(txhpb_dw2_reg)

  rand uvm_reg_field data;

  function new(string name = "txhpb_dw2_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "WO", 0, 32'h00000000, 0, 1, 1);
  endfunction
endclass


//RX_ID
class rx_id_reg extends uvm_reg;
  `uvm_object_utils(rx_id_reg)

  rand uvm_reg_field id_base;
  rand uvm_reg_field rtr_srr;
  rand uvm_reg_field ide;
  rand uvm_reg_field id_ext;
  rand uvm_reg_field rtr;

  function new(string name = "rx_id_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    id_base = uvm_reg_field::type_id::create("id_base");
    id_base.configure(this, 11, 21, "RO", 1, 11'h000, 0, 1, 1);

    rtr_srr = uvm_reg_field::type_id::create("rtr_srr");
    rtr_srr.configure(this, 1, 20, "RO", 1, 1'h0, 0, 1, 1);

    ide = uvm_reg_field::type_id::create("ide");
    ide.configure(this, 1, 19, "RO", 1, 1'h0, 0, 1, 1);

    id_ext = uvm_reg_field::type_id::create("id_ext");
    id_ext.configure(this, 18, 1, "RO", 1, 18'h00000, 0, 1, 1);

    rtr = uvm_reg_field::type_id::create("rtr");
    rtr.configure(this, 1, 0, "RO", 1, 1'h0, 0, 1, 1);
  endfunction
endclass

//RX_DLC
class rx_dlc_reg extends uvm_reg;
  `uvm_object_utils(rx_dlc_reg)

  rand uvm_reg_field dlc;
  rand uvm_reg_field reserved_27_0;

  function new(string name = "rx_dlc_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    dlc = uvm_reg_field::type_id::create("dlc");
    dlc.configure(this, 4, 28, "RO", 1, 4'h0, 0, 1, 1);

    reserved_27_0 = uvm_reg_field::type_id::create("reserved_27_0");
    reserved_27_0.configure(this, 28, 0, "RO", 1, 28'h0000000, 0, 1, 1);
  endfunction
endclass

//RX_DW1
class rx_dw1_reg extends uvm_reg;
  `uvm_object_utils(rx_dw1_reg)

  rand uvm_reg_field data;

  function new(string name = "rx_dw1_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 1, 32'h00000000, 0, 1, 1);
  endfunction
endclass

//RX_DW2
class rx_dw2_reg extends uvm_reg;
  `uvm_object_utils(rx_dw2_reg)

  rand uvm_reg_field data;

  function new(string name = "rx_dw2_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    data = uvm_reg_field::type_id::create("data");
    data.configure(this, 32, 0, "RO", 1, 32'h00000000, 0, 1, 1);
  endfunction
endclass


//AFR
class afr_reg extends uvm_reg;
  `uvm_object_utils(afr_reg)

  rand uvm_reg_field uaf_alias;
  rand uvm_reg_field reserved_27_4;
  rand uvm_reg_field uaf;

  function new(string name = "afr_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    uaf_alias = uvm_reg_field::type_id::create("uaf_alias");
    uaf_alias.configure(this, 4, 28, "WO", 0, 4'h0, 1, 1, 1);

    reserved_27_4 = uvm_reg_field::type_id::create("reserved_27_4");
    reserved_27_4.configure(this, 24, 4, "RO", 0, 24'h000000, 1, 1, 1);

    uaf = uvm_reg_field::type_id::create("uaf");
    uaf.configure(this, 4, 0, "RW", 0, 4'h0, 1, 1, 1);
  endfunction
endclass

//AFMR1- 4
class afmr_reg extends uvm_reg;
  `uvm_object_utils(afmr_reg)

  rand uvm_reg_field mask;

  function new(string name = "afmr_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    mask = uvm_reg_field::type_id::create("mask");
    mask.configure(this, 32, 0, "RW", 0, 32'h00000000, 1, 1, 1);
  endfunction
endclass

//AFIR1 -4
class afir_reg extends uvm_reg;
  `uvm_object_utils(afir_reg)

  rand uvm_reg_field id;

  function new(string name = "afir_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction

  function void build();
    id = uvm_reg_field::type_id::create("id");
    id.configure(this, 32, 0, "RW", 0, 32'h00000000, 1, 1, 1);
  endfunction
endclass

