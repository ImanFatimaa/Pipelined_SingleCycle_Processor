//CONTROL HAZARD FOR BRANCH AND JUMP//
module Branch_Jump_Hazard_Unit(
  input clk,
    input pc_branch,alu_zero,id_jump, 
    output reg IF_flush,ID_flush_branch,EX_flush
);

  always @(posedge clk)
    begin
      if(pc_branch==1'b1 && alu_zero==1'b1)
        begin 
            IF_flush = 1;      
            ID_flush_branch =1; 
            EX_flush =1;                                   //for ALU
        end
      else if(id_jump==1'b1)
        begin
            IF_flush = 1;      
            ID_flush_branch =1; 
           // EX_flush = 0;
        end
        else 
        begin 
            IF_flush = 0; 
            ID_flush_branch = 0; 
            EX_flush = 0; 
        end
    end
endmodule
