//JUMP MODULE//
module Jump_Check#(parameter ad_size=32)(
  input clk,
  input  [25:0] id_jump_address,
  input [ad_size-1:0] id_pc,
  output reg [ad_size-1:0] j_address
);
  wire [ad_size-1:0]  j_addr;
  assign j_addr=id_jump_address<<2;
  
  always@(posedge clk)
    begin
      j_address=id_pc+j_addr;
    end
endmodule
