
//FORWADING MODULE//
module Forward_Unit(
  input dm_mem_write,
  input [4:0] rf_rt,rf_rs,                    //of instruction 2  for rtype and lw
  input [4:0] alu_rd,                         //of instruction 1  for rtype
  input [4:0] alu_rt,                         //for sw and lw dependency
  output reg [1:0] ForwardA, ForwardB
);

  wire equal_RFALU_rs,equal_RFALU_rt,nonzero_RFALU_rd;          //to check if data dependcy is present in two rtype instructions
  wire equal_Itype_rs,equal_Itype_rt;                           //for checking in i type consectives
  
  assign equal_RFALU_rs=(rf_rs==alu_rd)?1:0;        //if rd of instruction 1 is used as rs of intruction 2
  assign equal_RFALU_rt=(rf_rt==alu_rd)?1:0;        //if rd of instruction 1 is used as ry of intruction 2
  
  assign equal_Itype_rs=(rf_rs==alu_rt)?1:0;        //if rt of lw is used as rs of sw
  assign equal_Itype_rt=(rf_rt==alu_rt)?1:0;        //if rt of lw 1 is used as rt of sw
  
    // Hazard condition - In the event that an instruction in the pipeline has $0 as its destination 
    // - avoid forwarding a possibly nonzero result value.
  assign nonzero_RFALU_rd = (alu_rd == 0) ? 0 : 1;
  
  //n0w forwading will occur in alu state of second  instruction  
  always@*
    begin
        ForwardA=2'b00;
        ForwardB=2'b00;
      if((equal_RFALU_rs & nonzero_RFALU_rd) || (equal_Itype_rs & dm_mem_write))
        ForwardA=2'b01;                          //rs
      else if(equal_RFALU_rt & nonzero_RFALU_rd || (equal_Itype_rt & dm_mem_write))
        ForwardB=2'b01;                           //rt
    end

endmodule
