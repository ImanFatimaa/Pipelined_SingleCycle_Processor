//REGISTER FILE//
module RegisterFile#(parameter ad_size=32,d_size=32,depth=32)(
  input clk,rst,rf_ALUSrc,rf_regdst,
  input [1:0] ForwardA,ForwardB,
  input [4:0] rf_rs,rf_rt,rf_rd,                      //address from decoder of regfile
  input [ad_size-1:0] se_un_address,
  input [d_size-1:0] dm_result,
  //this is actual output needed from this module
  output reg [d_size-1:0] rf_in1,rf_in2,rf_dest          // inputs of operation  
 
  );

  reg [d_size-1:0] reg_file [depth-1:0];        // creating REGISTER FILE of 32 bits and depth of 8 bits
  
initial  
  begin
    reg_file[0] = 32'b00000000000000000000000000000000;
    reg_file[1] = 32'b00000000000000000000000000000101;
    reg_file[2] = 32'b00000000000000000000000000000110;
    reg_file[3] = 32'b00000000000000000000000000000111;
    reg_file[4] = 32'b00000000000000000000000000000100;
    reg_file[5] = 32'b00000000000000000000000001000001;
    reg_file[6] = 32'b00000000000000000000000000001000;
    reg_file[7] = 32'b00000000000000000000000000000101;
    reg_file[8] = 32'b00000000000000000000000000001011;
    reg_file[9] = 32'b00000000000000000000000000001001;
  end

  always@(rf_rs,rf_rt,se_un_address,rf_ALUSrc,ForwardA,ForwardB,dm_result)                         // setting in1 and in2 according to the address we got from instructions
    begin    
      if(rf_ALUSrc==1'b0 )
        begin
          if(ForwardA==2'b01)
            begin
              rf_in1 = dm_result;
              rf_in2 = reg_file[rf_rt];
            end
          else if(ForwardB==2'b01)
            begin
              rf_in1 = reg_file[rf_rs];
              rf_in2 = dm_result;
            end
          else
            begin
              rf_in1 = reg_file[rf_rs];
              rf_in2 = reg_file[rf_rt];
            end
        end
      else
        begin
           if(ForwardA==2'b01)
            begin
              rf_in1 = dm_result;
              rf_in2 = se_un_address;
            end
          else
            begin
              rf_in1 = reg_file[rf_rs];
              rf_in2 = se_un_address;
            end             
        end
    end
  //setting destination register
  always@(posedge clk)
    begin
      if(rf_regdst)
        rf_dest=reg_file[rf_rd];
      else
        rf_dest=reg_file[rf_rt];
    end
endmodule
