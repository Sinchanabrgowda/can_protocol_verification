class apb_sequence_item extends uvm_sequence_item;

    rand bit [11:0]  paddr;
    rand bit         pwrite;
    rand bit [31:0]  pwdata;
    rand bit [3:0]   pstrb;
    rand bit [2:0]   pprot;
    rand bit         psel;
    rand bit         penable;

    bit [31:0] prdata;
    bit        pready;
    bit        pslverr;

    `uvm_object_utils_begin(apb_sequence_item)
        `uvm_field_int(paddr, UVM_ALL_ON)
        `uvm_field_int(pwrite, UVM_ALL_ON)
        `uvm_field_int(pwdata, UVM_ALL_ON)
        `uvm_field_int(pstrb, UVM_ALL_ON)
        `uvm_field_int(pprot, UVM_ALL_ON)
        `uvm_field_int(psel, UVM_ALL_ON)
        `uvm_field_int(penable, UVM_ALL_ON)
        `uvm_field_int(prdata, UVM_ALL_ON)
        `uvm_field_int(pready, UVM_ALL_ON)
        `uvm_field_int(pslverr, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "apb_sequence_item");
        super.new(name);
    endfunction

endclass
