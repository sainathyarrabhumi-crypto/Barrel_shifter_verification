package barrel_shifter_package;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // ------------------------------------
  // Include all verification components
  // ------------------------------------
  // Data Items
  `include "barrel_txn.sv"
  `include "barrel_config.sv"
  
  // Agent Components
  `include "barrel_driver.sv"
  `include "barrel_monitor.sv"
  `include "barrel_sequencer.sv"
  `include "barrel_agent.sv"
  
  // Sequences (All sequences are now consolidated)
  `include "barrel_sequence.sv"

  // Environment Components
  `include "barrel_scoreboard.sv"
  `include "barrel_env.sv"
  
  // Tests
  `include "barrel_shifter_test.sv"

endpackage : barrel_shifter_package
