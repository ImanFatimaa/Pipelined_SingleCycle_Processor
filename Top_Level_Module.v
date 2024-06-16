
//COMPLETE PIPELINE MODULE//
module Pipeline#(parameter d_size = 32,ad_size=32)(
  input clk, rst,
   input sw,clk1,                   //switch to check 32 bit num in 2 chunks of 16 16 bits and clk1 for fpga
 // output reg [d_size-1:0] DATA
  input [1:0] sel_out,
  output  [6:0] seg,
  output  [3:0] an
);
  
    // Wires to connect different modules
  wire id_regwrite, id_memtoreg, id_mem_write, id_memread, id_ALUSrc, id_regdst, id_jump, id_branch;
  wire rf_regdst, rf_regwrite, rf_memtoreg, rf_ALUSrc, rf_mem_write, rf_memread, rf_branch;
  wire alu_regwrite, alu_memtoreg, alu_mem_write, alu_memread, alu_jump, alu_branch;
  wire dm_regwrite, dm_memtoreg, dm_mem_write, dm_memread, dm_branch;
  wire rb_regwrite, rb_memtoreg, rb_memread;
  wire rb_branch,pc_branch,pc_jump;
  wire alu_zero;
  
  //signals for hazards
  wire ID_flush_lw_stall,ID_flush_branch,EX_flush,IF_flush,PC_write,ID_write;
  wire [1:0] ForwardA,ForwardB;
  wire [4:0] rb_rd,alu_rs,alu_rd,acu_rd,dm_rd,alu_rt,acu_rt,dm_rt;
  
  
  wire [1:0] id_ALUOp,rf_ALUOp, acu_ALUOp,alu_op;
  wire [3:0] alu_opcode,alu_opcode1;
  wire [5:0] acu_opcode,acu_function,rf_function,id_opcode,id_function;
  wire [4:0] rf_rs,rf_rt, rf_rd,rf_shamt,alu_shamt,acu_shamt,id_rs,id_rt,id_rd,id_shamt,rb_rt;
  wire [15:0] se_itype_address,id_itype_address;
  wire [25:0] id_jump_address;
  
  wire [d_size-1:0] im_Instruction,id_Instruction,pc,alu_in1,alu_in2,dm_data_input,dm_result,alu_input;
  wire [d_size-1:0] rb_result,dm_Memory_out_Data,rf_in1,rf_in2,rf_dest;
  wire [ad_size-1:0] se_address,br_address,mem_address,se_un_address,j_address,dm_itype_address,if_pc,id_pc,br_pc;
 
  //final output data of  processor and one to be displayed on fpga
  wire [d_size-1:0] OUT,DATA;
  
  
  // Module instantiations
 Program_Counter #(32,32) prog(clk,rst,PC_write,IF_flush,pc_jump,pc_branch,alu_zero,j_address,br_address,pc);
 
 Instruction_Memory #(32,32,32) im(clk, rst, pc, im_Instruction);
    
 IF_ID_Reg #(32,32) if_id(clk,rst,ID_write,IF_flush,im_Instruction,pc,id_Instruction,id_pc);
   
 Control #(32) con(clk, rst,ID_flush_lw_stall,ID_flush_branch,id_Instruction,id_regwrite,id_memtoreg,id_mem_write,id_memread,
               id_ALUSrc,id_regdst,id_jump,id_branch,id_ALUOp);
 ID_RF_Reg  id_rf(clk,rst,id_regwrite,id_memtoreg,id_mem_write,id_memread,id_ALUSrc,id_regdst,id_branch,id_jump,id_ALUOp,
                  id_function,id_rs,id_rt,id_rd,id_shamt,acu_ALUOp,acu_function,rf_rs,rf_rt,rf_rd,rf_shamt,rf_regdst,
                  rf_regwrite,rf_memtoreg,rf_ALUSrc,rf_mem_write,rf_memread,rf_branch,pc_jump);
						
 Decoder #(32) dec(clk,rst,id_Instruction,id_function,id_itype_address,id_jump_address,id_rs,id_rt,id_rd,id_shamt);
  
  RegisterFile #(32) rf(clk,rst,rf_ALUSrc,rf_regdst,ForwardA,ForwardB,rf_rs,rf_rt,rf_rd,se_un_address,dm_result,rf_in1,
                        rf_in2,rf_dest);  
  
  RF_ALU_Reg #(32,32) rf_alu_reg(clk,rst,rf_in1,rf_in2,rf_dest,rf_regwrite,rf_memtoreg,rf_mem_write,rf_memread,
                                 rf_branch,rf_function,rf_shamt,rf_rt,rf_rd,rf_rs,se_address,br_address,alu_regwrite,
                                 alu_memtoreg,alu_mem_write,alu_memread,pc_branch,alu_shamt,alu_rt,alu_rd,alu_rs,
                                 alu_in1,alu_in2,alu_input);
  
 ALUControlUnit #(32,32) acu(clk,rst,acu_ALUOp,acu_function,alu_op,alu_opcode);
  
 ALU #(32,32)  alu(clk,rst,alu_op,alu_in1,alu_in2,alu_opcode,alu_shamt,alu_zero,dm_result,dm_itype_address);
  
  EX_MEM_Reg #(32,32)  ex_mem(clk,rst,EX_flush,alu_rd,alu_regwrite,alu_memtoreg,alu_mem_write,alu_memread,dm_itype_address,
                          alu_input,dm_data_input,mem_address,dm_regwrite,dm_memtoreg,dm_mem_write,dm_memread,dm_rd);
  
  DataMemory #(32,32,32) dm(clk,rst,dm_mem_write,alu_memread,dm_data_input,mem_address,dm_Memory_out_Data);
  
 MEM_WB_Reg #(32,32)  memtoreg(clk,dm_regwrite,dm_memtoreg,dm_result,dm_memread,EX_flush,dm_rd,rb_result,rb_regwrite,
                               rb_memtoreg,rb_memread,rb_rd);
  
 WriteRegister #(32,32) rb(clk,rst,rb_memtoreg,rb_memread,rb_regwrite,dm_Memory_out_Data,rb_result,DATA);
  
  ////JUMP AND BRANCH MODULE CHECK////
   
 Jump_Check #(32) jmp(clk, id_jump_address, id_pc,j_address);
 
 Sign_Extend #(32)  se(clk, id_itype_address, id_pc,br_pc,se_un_address);
  
 Left_Shift_Branch #(32) lsb(clk,se_un_address,br_pc,se_address);
  
  ////HAZARD CONTROL MODULES////
  
  Branch_Jump_Hazard_Unit bjhu(clk,pc_branch,alu_zero,id_jump,IF_flush,ID_flush_branch,EX_flush);
  
 LW_Stall lws(rf_memread,clk,id_rs,id_rt,alu_rt,PC_write,ID_write,ID_flush_lw_stall);

  
  /////DISPLAYING ON FPGA///////
 Forward_Unit fu(rf_rt,rf_rs,alu_rd, ForwardA, ForwardB);
  
  //chosing module
 CHOOSE_OUTPUT #(32,32,32)  ch_out(pc,im_Instruction,id_Instruction, DATA,sel_out,OUT);
  
  //seven segment display calling  
 sevensegment ssd(clk1,sw,OUT,seg,an);
  
endmodule
