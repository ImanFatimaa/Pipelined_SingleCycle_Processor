//temporary register between alu and data memory
module EX_MEM_Reg#(parameter ad_size=32,d_size=32)(
  input clk,rst,
  input EX_flush,
  input [4:0] alu_rd,
  
  input alu_regwrite,alu_memtoreg,alu_mem_write,alu_memread,
  input [ad_size-1:0] dm_itype_address,
  input [d_size-1:0] alu_input,
  
  output reg [d_size-1:0] dm_data_input,
  output reg [ad_size-1:0] mem_address,
  output reg dm_regwrite,dm_memtoreg,dm_mem_write,dm_memread,
  output reg [4:0] dm_rd

);
  //excessive transfering of signals  as data from behnid ends here but from here new data starts

  always@(posedge clk)
    begin
      if(EX_flush==1'b1)
        begin
           dm_regwrite = 1'b0;
           dm_memtoreg = 1'b0;
           dm_mem_write = 1'b0;
           dm_memread = 1'b0;
        end
      else
        begin
           dm_regwrite = alu_regwrite;
           dm_memtoreg = alu_memtoreg;
           dm_mem_write = alu_mem_write;
           dm_memread = alu_memread;
           dm_rd=alu_rd;
           dm_data_input=alu_input;
        end
    end
always@*
  begin
     mem_address=dm_itype_address;
  end
endmodule
