//CONTROL UNIT//
module Control#(parameter i_size=32)(
  input clk, rst,
  // Hazard control signals - lw, beq
  input ID_flush_lw_stall, ID_flush_branch,
  
  input [i_size-1:0] id_Instruction,
  output reg id_regwrite,id_memtoreg,id_mem_write,id_memread,id_ALUSrc,
  output reg id_regdst,id_jump,id_branch,
  output reg [1:0] id_ALUOp
);
      
  //setting the opcode according to our processor demands
  reg[5:0] rtype=6'd0,beq=6'd3,jump=6'd4;
  reg[5:0] itype_lw=6'd1,itype_sw=6'd2;
  
  wire [5:0] cu_opcode;
  assign cu_opcode=id_Instruction[31:26];
  //set the output control signals according to opcode
  //output logic
  always @* 
   begin
     if(rst==1'b1||ID_flush_lw_stall==1'b1 ||ID_flush_branch==1'b1)
        begin
              id_memread=1'b0;
              id_ALUSrc=1'b0;
              id_ALUOp=2'b00;
              id_regwrite=1'b0;
              id_regdst=1'b0;
              id_memtoreg=1'b0;
              id_mem_write=1'b0;
              id_branch=1'b0;
              id_jump=1'b0;
        end
      else
        begin
      case(cu_opcode)
        //rtype
          rtype: 
            begin 
              id_memread=1'b0;
              id_ALUSrc=1'b0;
              id_ALUOp=2'b10;
              id_regwrite=1'b1;
              id_regdst=1'b1;
              id_memtoreg=1'b0;
              id_mem_write=1'b0;
              id_branch=1'b0;
              id_jump=1'b0;
            end
        //for itype
          itype_lw: 
            begin
              id_memread=1'b1;
              id_ALUSrc=1'b1;
              id_ALUOp=2'b00;
              id_regwrite=1'b1;
              id_regdst=1'b0;
              id_memtoreg=1'b1;
              id_mem_write=1'b0;
              id_branch=1'b0;
              id_jump=1'b0;
          end
        
          itype_sw: 
            begin
              id_memread=1'b0;
              id_ALUSrc=1'b1;
              id_ALUOp=2'b00;
              id_regwrite=1'b1;
              id_regdst=1'b0;
              id_memtoreg=1'b0;
              id_mem_write=1'b1;
              id_branch=1'b0;
              id_jump=1'b0;
          end
        //for beq
          beq:
            begin
              id_memread=1'b0;
              id_ALUSrc=1'b0;
              id_ALUOp=2'b01;
              id_regwrite=1'b0;
              id_regdst=1'b0;
              id_memtoreg=1'b0;
              id_mem_write=1'b0;
              id_branch=1'b1;
              id_jump=1'b0;
          end
        //for jump
          jump: 
            begin
              id_memread=1'b0;
              id_ALUSrc=1'b0;
              id_ALUOp=2'b11;
              id_regwrite=1'b0;
              id_regdst=1'b0;
              id_memtoreg=1'b0;
              id_mem_write=1'b0;
              id_branch=1'b0;
              id_jump=1'b1;
          end     
      endcase
        end
  end
  
endmodule
