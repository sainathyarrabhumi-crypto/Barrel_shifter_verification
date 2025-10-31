//-----------------------------------------------
// SEQUENCER
//-----------------------------------------------
class barrel_sequencer extends uvm_sequencer #(barrel_shifter_txn);
  `uvm_component_utils(barrel_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
