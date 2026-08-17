module top;

  timeunit 1ns;
  timeprecision 1ps;
  import uvm_pkg::*;
  import tb_pkg::*;

  logic clk = 0;

  always #5 clk = ~clk;

  if_a #(
    .width(8),
    .depth(16)
  ) bus(clk);

FIFO #(
	.width(8),
	.depth(16)
)PIPO(
	bus.UUT
);

  initial begin

    uvm_config_db#(virtual if_a)::set(
      null,
      "uvm_test_top.env.a0.*",
      "vif",
      bus.TB
    );

    run_test("tested");

  end

endmodule