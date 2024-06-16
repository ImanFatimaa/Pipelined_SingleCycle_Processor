module Pipeline_tb;

  // Parameters
  parameter d_size = 32;
  parameter ad_size = 32;

  // Testbench signals
  reg clk, rst, sw, clk1;
  reg [1:0] sel_out;
  wire [6:0] seg;
  wire [3:0] an;

  // Instantiate the Pipeline module
  Pipeline #(d_size, ad_size) dut (
    .clk(clk),
    .rst(rst),
    .sw(sw),
    .clk1(clk1),
    .sel_out(sel_out),
    .seg(seg),
    .an(an)
  );

  // Clock generation
  always #5 clk = ~clk;  // 100 MHz clock
  always #5 clk1 = ~clk1; // slower clock for seven segment display

  initial begin
    // Initialize signals
    clk = 0;
    clk1 = 0;
    rst = 1;
    sw = 0;
    sel_out = 2'b11;  // Set sel_out to 11

    // Apply reset
    #5;
    rst = 0;
    
    // Wait for some time to observe the behavior
    #280;


    // Finish simulation
    $finish;
  end
  initial begin
$dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
