//ALU CONTROL UNIT//

module ALUControlUnit#(parameter ad_size=32,d_size=32)(
  input clk,rst,
  input [1:0] acu_ALUOp,
  input [5:0] acu_function,
  
  //actual output
  output reg [1:0] alu_op,
  output reg [3:0] alu_opcode
);
  reg [3:0] alu_opcode1;
  always@*
    begin
      case(acu_ALUOp)
        2'b00: alu_opcode1=4'b0010;         //lw and store word
        2'b01: alu_opcode1=4'b0110;         //beq
        2'b10:                             //rtype
        begin
          case(acu_function)
            6'b100000: alu_opcode1=4'b0010;
            6'b100010: alu_opcode1=4'b0110;
            6'b100100: alu_opcode1=4'b0000;
            6'b100101: alu_opcode1=4'b0001;
            6'b101010: alu_opcode1=4'b0111;
          endcase
        end     
      endcase
    end

  always@(posedge clk)
    begin
        alu_op=acu_ALUOp;
        alu_opcode=alu_opcode1;
    end
 
endmodule
