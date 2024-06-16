
//TO LEFT SHIFT THE BRANCH ADDRESS BY TWO//
module Left_Shift_Branch#(parameter ad_size=32) (
  input clk,
  input [ad_size-1:0] se_un_address,br_pc,
  output reg [ad_size-1:0] se_address

);
  always@(posedge clk)
    begin
     se_address=br_pc+{se_un_address[29:0],2'b00};
    end
endmodule
