`ifndef BARREL_CONFIG_SV
`define BARREL_CONFIG_SV

class barrel_config extends uvm_object;
  `uvm_object_utils(barrel_config)

  // --------------------------------------------
  // Configuration Fields
  // --------------------------------------------
  bit is_active;                                    // Active or passive agent
  virtual barrel_if vif;                            // Virtual interface handle
  
  // FIX: Data width should match DUT (4 bits: [3:0])
  int data_width = 4;
  
  // FIX: Shift width should match DUT (2 bits: [1:0])
  int shift_width = 2;
  
  string agent_name = "barrel_agent";              // Identifier for agent

  // --------------------------------------------
  // Constructor
  // --------------------------------------------
  function new(string name = "barrel_config");
    super.new(name);
  endfunction

  // --------------------------------------------
  // Copy configuration from another object
  // --------------------------------------------
  function void copy(uvm_object rhs);
    barrel_config rhs_cfg;
    if (!$cast(rhs_cfg, rhs))
      `uvm_fatal("CFG_CAST", "Type mismatch in barrel_config::copy()")
    this.is_active  = rhs_cfg.is_active;
    this.vif          = rhs_cfg.vif;
    this.data_width  = rhs_cfg.data_width;
    this.shift_width = rhs_cfg.shift_width;
    this.agent_name  = rhs_cfg.agent_name;
  endfunction

  // --------------------------------------------
  // Print configuration
  // --------------------------------------------
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("is_active", is_active, $bits(is_active), UVM_DEC);
    printer.print_field("data_width", data_width, $bits(data_width), UVM_DEC);
    printer.print_field("shift_width", shift_width, $bits(shift_width), UVM_DEC);
    printer.print_string("agent_name", agent_name);
  endfunction

endclass

`endif // BARREL_CONFIG_SV
