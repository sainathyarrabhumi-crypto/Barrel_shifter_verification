// ================================================================
// File: barrel_sequences.sv
// Description: Contains all sequences for the Barrel Shifter TB, 
//              organized with inheritance.
// ================================================================

// Base sequence for generic random testing (parent for all others)
class barrel_shifter_seq extends uvm_sequence #(barrel_shifter_txn);
  `uvm_object_utils(barrel_shifter_seq)

  function new(string name="barrel_shifter_seq");
    super.new(name);
  endfunction

  virtual task body();
    barrel_shifter_txn tx;
    `uvm_info("SEQ", "Starting BASE random sequence (16 transactions)", UVM_MEDIUM)
    repeat (16) begin
      tx = barrel_shifter_txn::type_id::create("tx");
      assert(tx.randomize());
      start_item(tx);
      finish_item(tx);
    end
  endtask
endclass


// Specialization for Left Shift testing
class left_shift_seq extends barrel_shifter_seq; // Extends base sequence
  `uvm_object_utils(left_shift_seq)

  function new(string name = "left_shift_seq");
    super.new(name);
  endfunction

  virtual task body();
    barrel_shifter_txn tx;
    `uvm_info("SEQ", "Starting LEFT SHIFT sequence", UVM_MEDIUM)
    for (int i = 0; i < 4; i++) begin
      repeat (4) begin // Repeat 4 times for good data variation per shift amount
        tx = barrel_shifter_txn::type_id::create("tx");
        
        // Force Left Shift (dir == 1) and explicitly set the shift amount (i)
        assert(tx.randomize() with { 
          dir == 1'b1; 
          shift == i; 
        });
        
        start_item(tx);
        finish_item(tx);
      end
    end
  endtask
endclass


// Specialization for Right Shift testing
class right_shift_seq extends barrel_shifter_seq; // Extends base sequence
  `uvm_object_utils(right_shift_seq)

  function new(string name = "right_shift_seq");
    super.new(name);
  endfunction

  virtual task body();
    barrel_shifter_txn tx;
    `uvm_info("SEQ", "Starting RIGHT SHIFT sequence", UVM_MEDIUM)
    for (int i = 0; i < 4; i++) begin
      repeat (4) begin // Repeat 4 times for good data variation per shift amount
        tx = barrel_shifter_txn::type_id::create("tx");
        
        // Force Right Shift (dir == 0) and explicitly set the shift amount (i)
        assert(tx.randomize() with { 
          dir == 1'b0; 
          shift == i; 
        });
        
        start_item(tx);
        finish_item(tx);
      end
    end
  endtask
endclass


// Specialization for boundary and deterministic testing
class random_barrel_seq extends barrel_shifter_seq; // Extends base sequence
  `uvm_object_utils(random_barrel_seq)

  function new(string name = "random_barrel_seq");
    super.new(name);
  endfunction

  virtual task body();
    barrel_shifter_txn tx;
    logic [3:0] boundary_data_values [] = { 4'h0, 4'hF, 4'h1, 4'h8, 4'h5, 4'hA };
    `uvm_info("SEQ", "Starting RANDOM BARREL sequence (boundary constrained)", UVM_MEDIUM)
    
    foreach (boundary_data_values[i]) begin
      // Inner loop to test all 4 shift amounts (0, 1, 2, 3) for both directions
      for (int shift_val = 0; shift_val < 4; shift_val++) begin
        for (int dir_val = 0; dir_val <= 1; dir_val++) begin
          tx = barrel_shifter_txn::type_id::create("tx");
          
          assert(tx.randomize() with { 
            tx.data  == boundary_data_values[i]; 
            tx.shift == shift_val;
            tx.dir   == dir_val;
          });
          
          start_item(tx);
          finish_item(tx);
        end
      end
    end
  endtask
endclass
