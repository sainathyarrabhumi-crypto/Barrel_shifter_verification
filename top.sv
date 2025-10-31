`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"
import barrel_shifter_package::*;

module top;
  bit clk = 0;      // initialize clock

  // Clock generation
  always #5 clk = ~clk;  // 100 MHz clock

  // Interface instantiation
  barrel_if intf(clk);

  // DUT instantiation
  barrel_shifter dut (
    .clk   (clk),        // ? CONNECTED clock
    .data  (intf.data),
    .shift (intf.shift),
    .dir   (intf.dir),
    .result(intf.result)
  );

  // UVM configuration and test start
  initial begin
    uvm_config_db #(virtual barrel_if)::set(null, "*", "vif", intf);
    run_test(); // ? specify test name
  end
endmodule
