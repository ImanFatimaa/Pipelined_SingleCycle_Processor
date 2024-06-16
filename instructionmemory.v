//INSTRUCTION MEMORY//
module Instruction_Memory#(parameter p_size = 32,i_size=32,depth=32) (
  input clk, rst,
  input [p_size-1:0] pc,
  output [i_size-1:0] im_Instruction
);
   //size of instruction i_size=32;                     
   //number of instructions depth=32;                    
    
  reg [i_size-1:0] ROM [depth-1:0]; // ROM containing instructions

    // Initializing ROM with instructions
    initial 
      begin
        //NON-HAZARDOUS INSTRUCTIONS//
        ROM[0]  = 32'b000000_00000_00000_00000_00000_000000;      //nop 
        ROM[1]  = 32'b000000_00010_00001_00001_00000_100000;      //add
        ROM[2]  = 32'b000000_00101_00001_00100_00000_100010;      //sub           //data dependences rs2=rd1
        ROM[3]  = 32'b000000_00010_00001_00100_00000_100100;      //and
        ROM[4]  = 32'b000000_00010_00001_00101_00000_100101;      //or
        ROM[5]  = 32'b000000_00010_00101_00110_00010_101010;      //slt            //data dependence  rt2=rd1
        ROM[6]  = 32'b000000_00010_00001_00011_00010_101010;      
      
        ROM[7]  = 32'b000001_00011_00000_0000000000000101;        //lw      dependency between rtype and lw
              
        ROM[8]  = 32'b000011_00100_00001_0000000000000011;        //beq not applied

        ROM[9]  = 32'b000100_00000000000000000000000010;          //jump    
        
        //HAZARDOUS INSTRUCTIONS//
        ROM[10]  = 32'b000010_00111_00001_0000000000000111;        //sw
        ROM[11]  = 32'b000001_00011_00001_0000000000000001;        //lw  data dependcy between lw and sw
        
        ROM[12]  = 32'b000100_00000000000000000000000010;          //jump  to pc+2 without sll 

        ROM[13]  = 32'b000011_00100_00100_0000000000000011;        //beq applied
                
        ROM[14]  = 32'b000000_00010_00100_00001_00000_100000;      //add       
        
        ROM[15]  = 32'b000000_00010_00001_01001_00000_100101;      //or      data dependcy rt2=rd1
        
        ROM[16]  = 32'b000000_00000_00010_00011_00000_100010;      //sub 
        
        ROM[17]  = 32'b000010_01001_00011_0000000000000010;        //sw      data dependcy between sw and rtype
              
        ROM[18]  = 32'b000010_00100_00000_000000000000001;         //sw with rd updated in above instruction

        ROM[19]  = 32'b000100_00000000000000000000000100;          //jump to pc+4  without sll 
        
        ROM[20] = 32'b000011_00100_00100_0000000000000011;         //beq not applied
        
      
        //NO-USE INSTRUCTIONS
        ROM[21] = 32'b00000000000000000000000000000000;        // nop
        ROM[22] = 32'b00000000000000000000000000000000;        // nop 
        ROM[23] = 32'b00000000000000000000000000000000;        // nop
        ROM[24] = 32'b00000000000000000000000000000000;        // nop
        ROM[25] = 32'b00000000000000000000000000000000;        // nop
        ROM[26] = 32'b00000000000000000000000000000000;        // nop
        ROM[27] = 32'b00000000000000000000000000000000;        // nop
        ROM[28] = 32'b00000000000000000000000000000000;        // nop
        ROM[29] = 32'b00000000000000000000000000000000;        // nop
        ROM[30] = 32'b00000000000000000000000000000000;        // nop
        ROM[31] = 32'b00000000000000000000000000000000;        // nop
        
    end

    // Output instruction based on program counter
    assign im_Instruction = ROM[pc];  

endmodule
