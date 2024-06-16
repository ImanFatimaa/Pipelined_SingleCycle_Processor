//PROGRAM COUNTER//
module Program_Counter#(parameter p_size = 32,a_size=32) (
  input clk,rst,PC_write,IF_flush,pc_jump,pc_branch,alu_zero,
  input [a_size-1:0] j_address,br_address,
  output reg [p_size-1:0] pc
);
  
   always @(posedge clk, posedge rst) 
     begin
       if (rst)
            pc <= 0;
       else if(IF_flush==1'b1)
          begin
            if(pc_jump == 1'b1)
              pc <= j_address;
            else if(pc_branch == 1'b1 && alu_zero == 1'b1)
              pc <= br_address;
          end
       else if(PC_write==1'b1)
              pc <= pc + 1;
       else
              pc <= pc;
    end
endmodule
