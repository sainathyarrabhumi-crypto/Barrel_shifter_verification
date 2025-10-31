class barrel_smoke_test extends uvm_test;
  `uvm_component_utils(barrel_smoke_test)
  barrel_env env;
  barrel_config cfg;

  function new(string name = "barrel_smoke_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg = barrel_config::type_id::create("cfg");
    cfg.is_active = UVM_ACTIVE;
    if (!uvm_config_db#(virtual barrel_if)::get(this, " ", "vif",cfg.vif))
      `uvm_fatal("CFG", "Failed to set virtual interface")
    uvm_config_db#(barrel_config)::set(this, "*", "barrel_cfg", cfg);
    env = barrel_env::type_id::create("env", this);
  endfunction
function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_top.print_topology;
  endfunction
  task run_phase(uvm_phase phase);
  barrel_shifter_seq seq;
    phase.raise_objection(this);
    seq= barrel_shifter_seq::type_id::create("seq");
    seq.start(env.agent.seqr);
    phase.drop_objection(this);
  endtask
endclass
class barrel_left_shift_test extends barrel_smoke_test;
  `uvm_component_utils(barrel_left_shift_test)
  
  function new(string name="barrel_left_shift_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_top.print_topology;
  endfunction
  task run_phase(uvm_phase phase);
  left_shift_seq seq1;
    phase.raise_objection(this);
    seq1 = left_shift_seq::type_id::create("seq1");
    seq1.start(env.agent.seqr);
    phase.drop_objection(this);
  endtask
endclass
class barrel_right_shift_test extends barrel_smoke_test;
  `uvm_component_utils(barrel_right_shift_test)

  function new(string name="barrel_right_shift_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
  right_shift_seq seq;
    phase.raise_objection(this);
    seq = right_shift_seq::type_id::create("seq");
    seq.start(env.agent.seqr);
    phase.drop_objection(this);
  endtask
endclass
class barrel_random_shift_test extends barrel_smoke_test;
  `uvm_component_utils(barrel_random_shift_test)

  function new(string name="barrel_random_shift_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
  random_barrel_seq seq;
    phase.raise_objection(this);
    seq = random_barrel_seq::type_id::create("seq");
    seq.start(env.agent.seqr);
    phase.drop_objection(this);
  endtask
endclass
