typedef enum bit {
  DRIVE_FRAME,
  ACK_DUT_FRAME
} can_operation_e;


class can_sequence_item extends uvm_sequence_item;

  rand can_operation_e operation;

  rand bit ide;
  rand bit rtr;
  rand bit [10:0] id_base;
  rand bit [17:0] id_ext;
  rand bit [3:0] dlc;
  rand bit [7:0] data[];

  bit crc_error;
  bit ack_error;
  bit bit_error;
  bit stuff_error;
  bit form_error;

  `uvm_object_utils_begin(can_sequence_item)
    `uvm_field_enum(can_operation_e, operation, UVM_ALL_ON)
    `uvm_field_int(ide, UVM_ALL_ON)
    `uvm_field_int(rtr, UVM_ALL_ON)
    `uvm_field_int(id_base, UVM_ALL_ON)
    `uvm_field_int(id_ext, UVM_ALL_ON)
    `uvm_field_int(dlc, UVM_ALL_ON)
    `uvm_field_array_int(data, UVM_ALL_ON)
    `uvm_field_int(crc_error, UVM_ALL_ON)
    `uvm_field_int(ack_error, UVM_ALL_ON)
    `uvm_field_int(bit_error, UVM_ALL_ON)
    `uvm_field_int(stuff_error, UVM_ALL_ON)
    `uvm_field_int(form_error, UVM_ALL_ON)
  `uvm_object_utils_end

  constraint dlc_c {
    dlc inside {[0:8]};
    if (rtr)
      data.size() == 0;
    else
      data.size() == dlc;
  }

  constraint id_c {
    if (!ide)
      id_ext == 0;
  }

  function new(string name = "can_sequence_item");
    super.new(name);
  endfunction

endclass
