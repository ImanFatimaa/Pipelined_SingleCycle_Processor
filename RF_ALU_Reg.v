///Reguster Between Instruction Decoded Register File and ALU control Unit///
module RF_ALU_Reg#(parameter d_size=32,ad_size=32)(
    input clk,rst,

  input [d_size-1:0] rf_in1,rf_in2,rf_dest,
  
  //now the signals that are not going tobe used int this module but are just to store
  input rf_regwrite,rf_memtoreg,rf_mem_write,rf_memread,rf_branch,
                                        //for alu control unit
  input [5:0] rf_function,
  input [4:0] rf_shamt,rf_rt,rf_rd,rf_rs,
  input [ad_size-1:0] se_address,
  
  output reg [ad_size-1:0] br_address,
  output reg alu_regwrite,alu_memtoreg,alu_mem_write,alu_memread,pc_branch,
  output reg [4:0] alu_shamt,alu_rt,alu_rd,alu_rs,
  
  //actual output
  output reg [d_size-1:0] alu_in1,alu_in2,alu_input
);
    always@(posedge clk)
    begin
      alu_in1=rf_in1;
      alu_in2=rf_in2;
      
      //for hazards control
      alu_rs=rf_rs;
      alu_rt=rf_rt;
      alu_rd=rf_rd;
      alu_input=rf_dest;           //data to be saved in memory upon sw
    end
   //transfer excess signal
  always@(posedge clk)
    begin
      
      //data
      alu_shamt=rf_shamt;
      br_address=se_address;

      //signals
      pc_branch=rf_branch;                     //as this  signal and pc_zero will lead to staright away branch
      alu_regwrite=rf_regwrite;
      alu_memtoreg= rf_memtoreg;
      alu_mem_write=rf_mem_write;
      alu_memread=rf_memread;
    end

endmodule
