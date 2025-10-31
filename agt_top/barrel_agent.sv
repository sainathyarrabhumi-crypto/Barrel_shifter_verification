`ifndef BARREL_AGENT_SV
`define BARREL_AGENT_SV

class barrel_agent extends uvm_agent;
  `uvm_component_utils(barrel_agent)

  barrel_config cfg;
  barrel_driver    drv;
  barrel_monitor   mon;
  barrel_sequencer seqr;

  function new(string name = "barrel_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(barrel_config)::get(this, "", "barrel_cfg", cfg))
      `uvm_fatal("CFG_ERR", "barrel_config not found in agent")

    mon = barrel_monitor::type_id::create("mon", this);

    if(cfg.is_active) begin
      drv  = barrel_driver::type_id::create("drv", this);
      seqr = barrel_sequencer::type_id::create("seqr", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    if(cfg.is_active)
      drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass

`endif
