class apb_adapter extends uvm_reg_adapter;
  `uvm_object_utils(can_apb_adapter)

  function new(string name = "apb_adapter");
    super.new(name);
  endfunction

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_seq_item pkt_item;

    pkt_item = apb_seq_item::type_id::create("pkt_item");

    pkt_item.pwrite = (rw.kind == UVM_WRITE)? 1'b1: 1'b0;
    pkt_item.paddr  = rw.addr;
     if(rw.kind == UVM_WRITE) pkt_item.pwdata = rw.data;
    pkt_item.pstrb  = 4'hF;
    pkt_item.pprot  = 3'b000;

    return pkt_item;
  endfunction

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_seq_item pkt_item;

    if (!$cast(pkt_item, bus_item)) begin
      `uvm_fatal("CAN_APB_ADAPTER", "Failed to cast bus_item to can_apb_seq_item")
    end

    rw.kind   = pkt_item.pwrite ? UVM_WRITE : UVM_READ;
    rw.addr   = pkt_item.paddr;
    rw.data   = pkt_item.pwrite ? pkt_item.pwdata : pkt_item.prdata;
    rw.status = UVM_IS_OK;
  endfunction

endclass
