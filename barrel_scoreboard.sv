class barrel_shifter_scoreboard extends uvm_component;
  `uvm_component_utils(barrel_shifter_scoreboard)

  uvm_analysis_imp#(barrel_shifter_txn, barrel_shifter_scoreboard) sb_ap;

  // Class variables for coverage
  bit dir;
  bit [1:0] shift;

  // Covergroup
  covergroup cg;
    option.per_instance = 1;
    // CRITICAL FIX HERE: dir=0 is Right Shift, dir=1 is Left Shift
    coverpoint dir { bins right = {0}; bins left = {1}; } // <-- FIXED
    coverpoint shift { bins s[] = {0,1,2,3}; }
    cross dir, shift;
  endgroup

  function new(string name="barrel_shifter_scoreboard", uvm_component parent=null);
    super.new(name, parent);
    sb_ap = new("sb_ap", this);
    cg = new();
  endfunction

  function void write(barrel_shifter_txn tx);
    bit [3:0] expected;

    // Compute expected result (Logic is correct)
    if (tx.dir == 0) // Right Shift
      case (tx.shift)
        2'b00: expected = tx.data;
        2'b01: expected = {tx.data[2:0], 1'b0};
        2'b10: expected = {tx.data[1:0], 2'b00};
        2'b11: expected = {tx.data[0], 3'b000};
      endcase
    else // Left Shift (tx.dir == 1)
      case (tx.shift)
        2'b00: expected = tx.data;
        2'b01: expected = {1'b0, tx.data[3:1]};
        2'b10: expected = {2'b00, tx.data[3:2]};
        2'b11: expected = {3'b000, tx.data[3]};
      endcase

    // Check match
    if (expected !== tx.result)
      `uvm_error("MISMATCH", $sformatf("%s Expected=%0b Got=%0b",
                  sprint(tx), expected, tx.result))
    else
      `uvm_info("MATCH", $sformatf("%s PASS", sprint(tx)), UVM_LOW);

    // Sample coverage
    dir   = tx.dir;
    shift = tx.shift;
    cg.sample();
  endfunction

  // Add sprint method for transactions
  function string sprint(barrel_shifter_txn tx);
    return $sformatf("[data=%0b shift=%0d dir=%0d result=%0b]",
                     tx.data, tx.shift, tx.dir, tx.result);
  endfunction

endclass