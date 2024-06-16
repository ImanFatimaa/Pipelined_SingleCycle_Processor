//WRITE BACK REGISTER//
module WriteRegister#(parameter d_size=32,ad_size=32)(
  input clk,rst,rb_memtoreg,rb_memread,rb_regwrite,
  input [d_size-1:0] dm_Memory_out_Data,rb_result,
  //the final output displaying the data stored in registe file
  output reg[d_size-1:0] DATA
);
  reg [d_size-1:0] data;
  always@*
    begin
      if(rb_regwrite)
        begin
          if(rb_memread || rb_memtoreg)
            data=dm_Memory_out_Data;
          else
             data=rb_result;
        end
    end
  always@(posedge clk)
    begin
      DATA=data;
    end

endmodule
