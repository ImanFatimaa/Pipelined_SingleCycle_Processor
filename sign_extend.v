//SIGN EXTENSION MODULE FOR I-TYPE//
module Sign_Extend#(parameter ad_size=32)(
  input clk,
  input [15:0] id_itype_address,
  input [ad_size-1:0] id_pc,
  output reg [ad_size-1:0] br_pc,se_un_address
);
  reg [ad_size-1:0] i_addr;
  always@*
    begin
      //extended[15:0] <= { {8{extend[7]}}, extend[7:0] };
      if(id_itype_address[15]==1)
        i_addr={{16{id_itype_address[15]}},id_itype_address[15:0]};
      else
        i_addr={{16'b0},id_itype_address[15:0]};
    end
  
  always@*
    begin
      se_un_address=i_addr;
      br_pc=id_pc;
    end
endmodule
