 class barrel_shifter_txn extends uvm_sequence_item;
    rand bit [3:0] data;
    rand bit [1:0] shift;
    rand bit       dir;
         bit [3:0] result;

    `uvm_object_utils_begin(barrel_shifter_txn)
      `uvm_field_int(data,   UVM_ALL_ON)
      `uvm_field_int(shift,  UVM_ALL_ON)
      `uvm_field_int(dir,    UVM_ALL_ON)
      `uvm_field_int(result, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="barrel_shifter_txn");
      super.new(name);
    endfunction
  endclass