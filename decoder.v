//DECODER//
module Decoder#(parameter i_size=32)(
  //signals from control unit
  input clk,rst,
  //data
  input [i_size-1:0] id_Instruction,
  
  output  [5:0] id_function,
  output  [15:0] id_itype_address,
  output  [25:0] id_jump_address,
  output  [4:0] id_rs,id_rt,id_rd,id_shamt
);
  
  // splitting the 32 bits number in instr`~ROM

  //for R-type instructions
  assign   id_rs =  id_Instruction [25:21];
  assign   id_rt =  id_Instruction [20:16];
  assign   id_rd =  id_Instruction [15:11];
  assign id_shamt =  id_Instruction [10:6]; 
  assign id_function=  id_Instruction[5:0];
    
    //for I-type instructions 
  assign  id_itype_address =  id_Instruction [15:0];
  
  assign  id_jump_address =  id_Instruction [25:0];
  
endmodule
