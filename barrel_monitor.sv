class barrel_monitor extends uvm_monitor;
  `uvm_component_utils(barrel_monitor)

  // Virtual interface for monitor modport
  virtual barrel_if.MON vif;
  barrel_config cfg;
  uvm_analysis_port #(barrel_shifter_txn) mon_ap;
  
  // Cache variable to hold the transaction being processed by the DUT
  // This holds inputs from Cycle N, which will yield output at Cycle N+1.
  barrel_shifter_txn tr_in_flight; 

  function new(string name="barrel_monitor", uvm_component parent);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(barrel_config)::get(this, "", "barrel_cfg", cfg))
      `uvm_fatal("CFG_ERR", "barrel_config not found in monitor")
    vif = cfg.vif;
  endfunction

  // --------------------------------------------------------------------------
  // Main monitoring logic
  // --------------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    
    // Start with tr_in_flight set to null.
    // The first transaction (Cycle 1) will only populate inputs, and skip the scoreboard write.
    tr_in_flight = null; 

    forever begin
      barrel_shifter_txn new_tr;
      
      // 1. Wait for the clock edge (Start of Cycle N+1)
      // On this cycle, we sample the new inputs, AND the result from the previous cycle's inputs.
      @(vif.cb_mon);

      // --- OUTPUT CAPTURE & REPORT (from Cycle N inputs) ---
      // We process the result if a transaction is currently in flight (i.e., not the very first cycle)
      if (tr_in_flight != null) begin // <-- FIXED: Check for null instead of 'x'
        // Capture the corresponding result from the current cycle (N+1)
        tr_in_flight.result = vif.cb_mon.result;

        // Debug information
        `uvm_info("MON",
          $sformatf("Monitored @%0t (Result Cycle): Inputs: data=%0b shift=%0d dir=%0b | Result=%0b",
                    $time, tr_in_flight.data, tr_in_flight.shift, tr_in_flight.dir, tr_in_flight.result),
          UVM_LOW)

        // Send the fully populated transaction to scoreboard
        mon_ap.write(tr_in_flight);
      end

      // --- INPUT CAPTURE (for Cycle N+1 inputs) ---
      // Create a new transaction object to hold the inputs for the next cycle's check
      new_tr = barrel_shifter_txn::type_id::create("tr_new", this);
      new_tr.data  = vif.cb_mon.data;
      new_tr.shift = vif.cb_mon.shift;
      new_tr.dir   = vif.cb_mon.dir;
      
      // Store the new transaction as the 'in-flight' transaction for the next cycle
      tr_in_flight = new_tr;

    end
  endtask

endclass

