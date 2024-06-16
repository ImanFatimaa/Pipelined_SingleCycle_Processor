//STALL FOR LOAD WORD//
module LW_Stall(
  input alu_memread,clk,
  input [4:0] id_rs,id_rt,alu_rt,
  output reg PC_write,ID_write,
  output reg ID_flush_lw_stall
);
  always@(posedge clk)
    begin
      if(alu_memread && (alu_rt == id_rs || alu_rt == id_rt))
        begin 
            PC_write = 0;           // if instruction in the ID stage is stalled, then the instruction in the IF stage must also be stalled
            ID_write = 0;       // otherwise, we would lose the fetched instruction - set PCWrite as well as IF/IDwrite to 0  
            ID_flush_lw_stall = 1; // for stalling in ID stage
        end
       else 
        begin 
            PC_write = 1;
            ID_write = 1;
            ID_flush_lw_stall=0; 
        end
    end
endmodule
