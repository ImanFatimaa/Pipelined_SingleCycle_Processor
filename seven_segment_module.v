///SEVEN SEGMENT DISPLAY TO DISPLAY ON FPGA///
module sevensegment(
    input clk1,
	input sw,
    input [31:0] DATA,
    output [6:0] seg,
    output [3:0] an
);
  
    reg [3:0] sw1,sw2,sw3,sw4;
    wire [6:0] seg0, seg1, seg2, seg3;
  
  //coverting the 16-bit input into 4 4-bits number   
    // Slice the input number into four 4-bit segments
	 always@(*) begin
	 case(sw)
	 1'b0: begin
     sw1 = DATA[3:0];
     sw2 = DATA[7:4];
     sw3 = DATA[11:8];
     sw4 = DATA[15:12];
	 end
	 1'b1: begin
	   sw1 = DATA[19:16];
       sw2 = DATA[23:20];
       sw3 = DATA[27:24];
       sw4 = DATA[31:28];
     	 end
	 endcase
	 end

  //converting the 4-bit number to display it on seven segment display
  sseg_display s0(.hex(sw1), .seg(seg0));     
  sseg_display s1(.hex(sw2), .seg(seg1));     
  sseg_display s2(.hex(sw3), .seg(seg2));     
  sseg_display s3(.hex(sw4), .seg(seg3));     
 
  //callinng the module tp display the number on fpga
    sseg_mux display(.clk1(clk1), .rst(1'b0), .dig0(seg0), .dig1(seg1), .dig2(seg2), .dig3(seg3), .an(an), .sseg(seg));
endmodule

//Doing the time multiplexing on our output
module sseg_mux(
    input clk1, rst,
    input [6:0] dig0, dig1, dig2, dig3,
    output reg [3:0] an,
    output reg [6:0] sseg
    );
  
    // refresh rate of ~1526Hz (100 MHz / 2^16)
    localparam BITS = 18;
  wire [BITS - 1 : 0] q;
    counter_n #(.BITS(BITS)) counter(.clk1(clk1), .rst(rst), .q(q));
     
 
     
    always @*
      case (q[BITS - 1 : BITS - 2])
            2'b00:
                begin
                    an = 4'b1110;
                    sseg = dig0;
                end
            2'b01:
                begin
                    an = 4'b1101;
                    sseg = dig1;
                end
            2'b10:
                begin
                    an = 4'b1011;
                    sseg = dig2;
                end
            default:
                begin
                    an = 4'b0111;
                    sseg = dig3;
                end
        endcase                         
endmodule


// seven-segment digit display driver
module sseg_display (
    input [3:0] hex,
    output reg [6:0] seg
    );   
    always @*  begin
        case(hex)
            4'h0: seg[6:0] = 7'b1000000;    // digit 0
            4'h1: seg[6:0] = 7'b1111001;    // digit 1
            4'h2: seg[6:0] = 7'b0100100;    // digit 2
            4'h3: seg[6:0] = 7'b0110000;    // digit 3
            4'h4: seg[6:0] = 7'b0011001;    // digit 4
            4'h5: seg[6:0] = 7'b0010010;    // digit 5
            4'h6: seg[6:0] = 7'b0000010;    // digit 6
            4'h7: seg[6:0] = 7'b1111000;    // digit 7
            4'h8: seg[6:0] = 7'b0000000;    // digit 8
            4'h9: seg[6:0] = 7'b0010000;    // digit 9
            4'ha: seg[6:0] = 7'b0001000;    // digit A
            4'hb: seg[6:0] = 7'b0000011;    // digit B
            4'hc: seg[6:0] = 7'b1000110;    // digit C
            4'hd: seg[6:0] = 7'b0100001;    // digit D
            4'he: seg[6:0] = 7'b0000110;    // digit E
            default: seg[6:0] = 7'b0001110; // digit F
        endcase
    end
endmodule

module counter_n #(parameter BITS = 32) (
    input clk1,
    input rst,
    output reg [BITS - 1:0] q
);
    // Initialize the counter register
  always @ (posedge clk1, posedge rst) begin
        if (rst) begin

            q <= 0;
        end else begin
            q <= q + 1;
        end
    end
  
  
  
endmodule
