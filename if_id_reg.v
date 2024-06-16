//creating registers between stages
///Register Between IF and Decoder///
module IF_ID_Reg#(parameter i_size=32,ad_size=32)(
  input clk,rst,ID_write,IF_flush,
  input [i_size-1:0] im_Instruction,
  input [ad_size-1:0] pc,
  output reg [i_size-1:0] id_Instruction,
  output reg [ad_size-1:0] id_pc
);
  always@(posedge clk,posedge rst)
    begin
      if(rst==1'b1 ||IF_flush==1'b1)
        id_Instruction=32'd0;
      else if(ID_write==1'b0)
        id_Instruction=id_Instruction;
      else     
        id_Instruction=im_Instruction;
    end
  always@*
    begin     
      id_pc=pc;
    end
endmodule
