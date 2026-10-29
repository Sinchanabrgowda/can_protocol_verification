`uvm_analysis_imp_decl(_apb_active)
`uvm_analysis_imp_decl(_apb_passive)
`uvm_analysis_imp_decl(_can_active)
`uvm_analysis_imp_decl(_can_passive)

class can_subscriber extends uvm_component;
  `uvm_component_utils(can_subscriber)

  uvm_analysis_imp_apb_active #(apb_seq_item, can_subscriber) apb_active_port;
  uvm_analysis_imp_apb_passive #(apb_seq_item, can_subscriber) apb_passive_port;
  uvm_analysis_imp_can_active #(can_sequence_item, can_subscriber) can_active_port;
  uvm_analysis_imp_can_passive #(can_sequence_item, can_subscriber) can_passive_port;

  apb_seq_item apb_cov_item;
  can_sequence_item can_cov_item;

  real apb_item_cov;
  real can_item_cov;

  covergroup apb_cg;
    option.per_instance = 1;

    paddr_cp : coverpoint apb_cov_item.paddr {
      bins valid_addr[] = {[12'h000:12'h080]};
      bins invalid_addr = default;
    }

    pwrite_cp : coverpoint apb_cov_item.pwrite {
      bins read = {0};
      bins write = {1};
    }

    pwdata_cp : coverpoint apb_cov_item.pwdata {
      bins zero = {32'h00000000};
      bins non_zero = {[0:32'hFFFFFFFF]};
    }

    pstrb_cp : coverpoint apb_cov_item.pstrb {
      bins all_bytes = {4'b1111};
    }

    pprot_cp : coverpoint apb_cov_item.pprot {
      bins secure = {3'b000, 3'b001, 3'b010, 3'b011};
    }

    psel_cp : coverpoint apb_cov_item.psel {
      bins not_selected = {0};
      bins selected = {1};
    }

    penable_cp : coverpoint apb_cov_item.penable {
      bins setup = {0};
      bins access = {1};
    }

    prdata_cp : coverpoint apb_cov_item.prdata {
      bins zero = {32'h00000000};
      bins all_ones = {[0:32'hFFFFFFFF]};
    }

    pready_cp : coverpoint apb_cov_item.pready {
      bins not_ready = {0};
      bins ready = {1};
    }

    pslverr_cp : coverpoint apb_cov_item.pslverr {
      bins no_error = {0};
      bins error = {1};
    }

    access_cross : cross pwrite_cp, paddr_cp;

    response_cross : cross pwrite_cp, pready_cp, pslverr_cp;
  endgroup

  covergroup can_cg;
    option.per_instance = 1;

    operation_cp : coverpoint can_cov_item.operation;

    ide_cp : coverpoint can_cov_item.ide {
      bins standard_frame = {0};
      bins extended_frame = {1};
    }

    rtr_cp : coverpoint can_cov_item.rtr {
      bins data_frame = {0};
      bins remote_frame = {1};
    }

    id_base_cp : coverpoint can_cov_item.id_base {
      bins low_id = {[11'h000:11'h2AA]};
      bins mid_id = {[11'h2AB:11'h554]};
      bins high_id = {[11'h555:11'h7FF]};
    }

    id_ext_cp : coverpoint can_cov_item.id_ext {
      bins low_id = {[18'h00000:18'h0AAAA]};
      bins mid_id = {[18'h0AAAB:18'h15554]};
      bins high_id = {[18'h15555:18'h3FFFF]};
    }

    dlc_cp : coverpoint can_cov_item.dlc {
      bins zero_bytes = {0};
      bins one_to_four_bytes = {[1:4]};
      bins five_to_eight_bytes = {[5:8]};
    }

    data_size_cp : coverpoint can_cov_item.data.size() {
      bins no_data = {0};
      bins one_to_four_bytes = {[1:4]};
      bins five_to_eight_bytes = {[5:8]};
    }

    crc_error_cp : coverpoint can_cov_item.crc_error {
      bins no_error = {0};
      bins error = {1};
    }

    ack_error_cp : coverpoint can_cov_item.ack_error {
      bins no_error = {0};
      bins error = {1};
    }

    bit_error_cp : coverpoint can_cov_item.bit_error {
      bins no_error = {0};
      bins error = {1};
    }

    stuff_error_cp : coverpoint can_cov_item.stuff_error {
      bins no_error = {0};
      bins error = {1};
    }

    form_error_cp : coverpoint can_cov_item.form_error {
      bins no_error = {0};
      bins error = {1};
    }

    frame_type_cross : cross ide_cp, rtr_cp;

    frame_length_cross : cross ide_cp, dlc_cp;
  endgroup

  function new(string name = "can_subscriber",
               uvm_component parent = null);
    super.new(name, parent);

    apb_active_port = new("apb_active_port", this);
    apb_passive_port = new("apb_passive_port", this);
    can_active_port = new("can_active_port", this);
    can_passive_port = new("can_passive_port", this);

    apb_cg = new();
    can_cg = new();
  endfunction

  function void write_apb_active(apb_seq_item t);
    apb_cov_item = t;
    apb_cg.sample();
  endfunction

  function void write_apb_passive(apb_seq_item t);
    apb_cov_item = t;
    apb_cg.sample();
  endfunction

  function void write_can_active(can_sequence_item t);
    can_cov_item = t;
    can_cg.sample();
  endfunction

  function void write_can_passive(can_sequence_item t);
    can_cov_item = t;
    can_cg.sample();
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    apb_item_cov = apb_cg.get_coverage();
    can_item_cov = can_cg.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    `uvm_info(get_type_name(),
      $sformatf("[APB] Functional Coverage = %0.2f%%",
                apb_item_cov), UVM_MEDIUM)

    `uvm_info(get_type_name(),
      $sformatf("[CAN] Functional Coverage = %0.2f%%",
                can_item_cov), UVM_MEDIUM)
  endfunction

endclass
