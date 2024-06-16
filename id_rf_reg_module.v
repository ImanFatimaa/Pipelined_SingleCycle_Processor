///temporary Reg between Decoder and Register file///
module ID_RF_Reg(
    input clk,rst,
  //signals
  input id_regwrite,id_memtoreg,id_mem_write,id_memread,id_ALUSrc,
  input id_regdst,id_branch,id_jump,
  input [1:0] id_ALUOp,
  
  //data from decoder
  input  [5:0] id_function,
  input  [4:0] id_rs,id_rt,id_rd,id_shamt,
 
  output reg [1:0] acu_ALUOp,                                      //for alu control unit
  output reg [5:0] acu_function,
  output reg [4:0] rf_rs,rf_rt,rf_rd,rf_shamt,
  
  //output signals
  output reg rf_regdst,rf_regwrite,rf_memtoreg,rf_ALUSrc,         //for register file
  output reg rf_mem_write,rf_memread,                             //for data memory
  output reg rf_branch,pc_jump  
);
  //shifting tonext state upon clk
  always@*
    begin
      rf_rs=id_rs;
      rf_rt=id_rt; 
      rf_rd=id_rd;
      rf_ALUSrc=id_ALUSrc;
      
      acu_ALUOp=id_ALUOp;
      
      rf_shamt= id_shamt;
      //signals
      rf_regwrite=id_regwrite;
      rf_memtoreg=id_memtoreg;
      rf_mem_write=id_mem_write;
      rf_memread=id_memread;
      rf_regdst=id_regdst;        
      end
  always@(posedge clk)
    begin
        pc_jump=id_jump;
        rf_branch=id_branch;            
        acu_function=id_function;
    end
endmodule
