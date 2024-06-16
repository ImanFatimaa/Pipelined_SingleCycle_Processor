//ALU/EXECUTION//
module ALU#(parameter ad_size=32,d_size=32)(
  input clk,rst,
  input [1:0] alu_op,
  input [d_size-1:0] alu_in1,alu_in2,
  input [3:0] alu_opcode,
  input [4:0] alu_shamt,
  
  //actual output of this module
  output reg alu_zero,
  output reg [d_size-1:0] dm_result,
  output reg [ad_size-1:0] dm_itype_address
);

  reg [d_size-1:0] alu_result;
   
  //alu performing functions
  always@*
  begin  
    case(alu_opcode)
      4'b0010: alu_result=alu_in1+alu_in2;
      4'b0110: alu_result=alu_in1-alu_in2;
      4'b0000: alu_result=alu_in1&alu_in2;
      4'b0001: alu_result=alu_in1|alu_in2;
      4'b0111: alu_result=alu_in1<<alu_shamt;
    endcase
  end
  
  always@*
    begin
      if(alu_op==2'b00)
        dm_itype_address=alu_result;
      else if(alu_op==2'b10)
        dm_result=alu_result;
      else if(alu_op==2'b01)
        alu_zero=(alu_result==0)?1:0;
    end

endmodule
