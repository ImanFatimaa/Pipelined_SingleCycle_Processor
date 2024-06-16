//DATA MEMORY//
module DataMemory#(parameter d_size=32,ad_size=32,depth=32)(
  input clk,rst,dm_mem_write,dm_memread,           
  input [d_size-1:0] dm_data_input,                                //ALU result in case of save word command
  input [ad_size-1:0] mem_address,                              // address from instruction for lw,sw command-constant+rs
  
  output reg [d_size-1:0] dm_Memory_out_Data                    // output by load ord command
);
  reg[d_size-1:0] data_mem [depth-1:0];                 // initiating the DATA MEMORY
  reg [d_size-1:0] dm_Memory_out_Data1;
initial
  begin
    data_mem[0]=32'b 0000000000000000000000000000001;
    data_mem[1]=32'b 0000000000000000000000000000010;
    data_mem[2]=32'b 0000000000000000000000000000011;
    data_mem[3]=32'b 0000000000000000000000000000000;
    data_mem[4]=32'b 0000000000000000000000000000100;
    data_mem[5]=32'b 0000000000000000000000000000001;
    data_mem[6]=32'b 0000000000000000000000000000110;
    data_mem[7]=32'b 0000000000000000000000000000111;
    data_mem[8]=32'b 0000000000000000000000000000111;
    data_mem[12]=32'b 0000000000000000000000000000111;
    data_mem[16]=32'b 0000000000000000000000001000111;

end
  
  reg [d_size-1:0] data_in_mem;
  always@(dm_memread,dm_mem_write,mem_address,dm_data_input)
  begin
    if (dm_memread==1'b1)
      dm_Memory_out_Data1 <= data_mem[mem_address];                   //load value from adress 
    else if (dm_mem_write==1)
      data_mem[mem_address]<= dm_data_input;                       // save value of ans1 in memory address
  end  
  always@(posedge clk)    
    begin
      dm_Memory_out_Data=dm_Memory_out_Data1;
      data_in_mem = data_mem[mem_address];
    end
endmodule
