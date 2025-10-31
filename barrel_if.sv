interface barrel_if(input bit clk);

  // DUT connection signals
  logic [3:0] data;
  logic [1:0] shift;
  logic       dir;
  logic [3:0] result;

  
  clocking cb_drv @(posedge clk);
    output data, shift, dir;
    input  result;
  endclocking

  
  clocking cb_mon @(posedge clk);
    // Use #1step for inputs to sample stable values before the clock edge
    default input #1step;
    input data, shift, dir, result;
  endclocking

  modport DRV (clocking cb_drv, input clk);
  modport MON (clocking cb_mon, input clk);
// Direction = 0 (Left shift)
property left_shift_0;
  @(posedge clk)
  (dir == 1'b0 && shift == 2'b00) |=> (result ==$past(data));
endproperty
assert_left_shift_0: assert property(left_shift_0);

property left_shift_1;
  @(posedge clk)
  (dir == 1'b0 && shift == 2'b01) |=> (result == {$past(data[2:0]), 1'b0});
endproperty
assert_left_shift_1: assert property(left_shift_1);

property left_shift_2;
  @(posedge clk)
  (dir == 1'b0 && shift == 2'b10) |=> (result == {$past(data[1:0]), 2'b00});
endproperty
assert_left_shift_2: assert property(left_shift_2);

property left_shift_3;
  @(posedge clk)
  (dir == 1'b0 && shift == 2'b11) |=> (result == {$past(data[0]), 3'b000});
endproperty
assert_left_shift_3: assert property(left_shift_3);

// Direction = 1 (Right shift)
property right_shift_0;
  @(posedge clk)
  (dir == 1'b1 && shift == 2'b00) |=> (result ==$past(data));
endproperty
assert_right_shift_0: assert property(right_shift_0);

property right_shift_1;
  @(posedge clk)
  (dir == 1'b1 && shift == 2'b01) |=> (result == {1'b0,$past(data[3:1])});
endproperty
assert_right_shift_1: assert property(right_shift_1);

property right_shift_2;
  @(posedge clk)
  (dir == 1'b1 && shift == 2'b10) |=> (result == {2'b00,$past(data[3:2])});
endproperty
assert_right_shift_2: assert property(right_shift_2);

property right_shift_3;
  @(posedge clk)
  (dir == 1'b1 && shift == 2'b11) |=> (result == {3'b000,$past(data[3])});
endproperty
assert_right_shift_3: assert property(right_shift_3);

 

endinterface