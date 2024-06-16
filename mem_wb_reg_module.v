///temporary register between memory and write back///
module MEM_WB_Reg#(parameter d_size=32,ad_size=32)(
  //extra signals to be transfered
  input clk,
  input  dm_regwrite,dm_memtoreg,
  input [d_size-1:0] dm_result,
  input dm_memread,
  input EX_flush,
  input [4:0] dm_rd,
  
  output reg [d_size-1:0] rb_result,
  output reg rb_regwrite,rb_memtoreg,rb_memread,
  output reg [4:0] rb_rd
);
  //excessive transfering of signals  as data from behnid ends here but from here new data starts
  always@*
    begin
      // Hazard control - in case of branch/jump hazards, reset WB, MEM and EX control signals to 0 
        // leave the addr, data and reg content unchanged
      if (EX_flush == 1)
        begin
            rb_regwrite <= 1'b0;
            rb_memtoreg <= 1'b0;
            rb_memread <= 1'b0;
        end
      else
        begin
            //signals
           rb_regwrite <= dm_regwrite;
           rb_memtoreg <= dm_memtoreg;
           rb_memread <= dm_memread;

           //data
           rb_rd=dm_rd;
        end
    end
  always@(posedge clk)
    begin
           rb_result = dm_result;
    end
endmodule
