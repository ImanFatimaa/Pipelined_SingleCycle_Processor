
module CHOOSE_OUTPUT#(i_size=32,ad_size=32,d_size=32)(
  input [ad_size-1:0] pc,
  input [i_size-1:0] im_Instruction,id_Instruction,
  input [d_size-1:0] DATA,
  
  //select button
  input [1:0]  sel_out,
  output reg [d_size-1:0] OUT
);
  always@*
    begin
      case(sel_out)
          2'b00: OUT=pc;
          2'b01: OUT=im_Instruction;
          2'b10: OUT=id_Instruction;
          2'b11: OUT=DATA;
        endcase
    end
endmodule
