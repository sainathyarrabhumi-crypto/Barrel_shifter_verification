`ifndef BARREL_ENV_SV
`define BARREL_ENV_SV

class barrel_env extends uvm_env;
  `uvm_component_utils(barrel_env)

  barrel_agent agent;
  barrel_shifter_scoreboard scb;
  barrel_config cfg;

  function new(string name = "barrel_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(barrel_config)::get(this, "", "barrel_cfg", cfg))
      `uvm_fatal("CFG_ERR", "barrel_config not found in env")

    agent = barrel_agent::type_id::create("agent", this);
    scb   = barrel_shifter_scoreboard::type_id::create("scb", this);

    uvm_config_db#(barrel_config)::set(this, "*", "barrel_cfg", cfg);
  endfunction

  function void connect_phase(uvm_phase phase);
    agent.mon.mon_ap.connect(scb.sb_ap);
  endfunction
endclass

`endif
