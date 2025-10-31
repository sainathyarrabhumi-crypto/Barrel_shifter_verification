`ifndef BARREL_DRIVER_SV
`define BARREL_DRIVER_SV

class barrel_driver extends uvm_driver #(barrel_shifter_txn);
  `uvm_component_utils(barrel_driver)

  virtual barrel_if.DRV vif;
  barrel_config cfg;

  function new(string name = "barrel_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(barrel_config)::get(this, "", "barrel_cfg", cfg))
      `uvm_fatal("CFG_ERR", "barrel_config not found in driver")
    vif = cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    barrel_shifter_txn tr;
    forever begin
      seq_item_port.get_next_item(tr);
      `uvm_info("DRIVER",$sformatf("printing from driver \n %s", tr.sprint()),UVM_LOW)
          @(vif.cb_drv);
      // Drive input signals
      vif.cb_drv.data  <= tr.data;
      vif.cb_drv.shift <= tr.shift;
      vif.cb_drv.dir   <= tr.dir;
      `uvm_info("DRV",
        $sformatf("Driving: data=%0d shift=%0d dir=%0b",
          tr.data, tr.shift, tr.dir),
        UVM_MEDIUM)

      // Allow DUT to process for 1 cycle
      seq_item_port.item_done();
    end
  endtask

endclass

`endif
