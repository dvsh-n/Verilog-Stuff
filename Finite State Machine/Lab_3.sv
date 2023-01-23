module FSM (input clk, reset, SW1, SW2, SW3, SW4, output logic [2:0] state, output logic [1:0] Z);
localparam S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;
logic [2:0] nextState;
logic many_states;
assign many_states = ((SW1&SW2)|(SW1&SW3)|(SW1&SW4)|(SW2&SW3)|(SW2&SW4)|(SW3&SW4));
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		state <= S0;
	else
		if (~many_states) state <= nextState;
end
always_comb begin
	nextState = state;
	Z = 2'b00;
	case (state)
		S0 : begin 
			Z = 2'b01;
			if (SW1) nextState = S1;
			else if (SW3) nextState = S3;
		end
		S1 : begin 
			Z = 2'b01;
			if (SW2) nextState = S2;
		end
		S2 : begin 
			Z = 2'b10;
			if (SW3) nextState = S3;
			else if (SW4) nextState = S1;
		end
		S3 : begin 
			Z = 2'b11;
			if (SW2) nextState = S1;
			else if (SW1) nextState = S4;
		end
		S4 : begin 
			Z = 2'b10;
			if (SW2) nextState = S1;
			else if (SW4) nextState = S0;
		end
		default: begin nextState = S0; Z = 2'b01; end
	endcase
end
endmodule

module FSM_tb1();
logic SW0, SW1, SW2, SW3, SW4, clk;
wire [2:0] state;
wire [1:0] Z;
FSM FSM1 (clk, SW0, SW1, SW2, SW3, SW4, state, Z);
initial begin
	SW0 = 1'b1; SW1 = 1'b0; SW2 = 1'b0; SW3 = 1'b0; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b1; SW2 = 1'b0; SW3 = 1'b0; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b0; SW2 = 1'b1; SW3 = 1'b0; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b0; SW2 = 1'b0; SW3 = 1'b0; SW4 = 1'b1; #10;
	SW0 = 1'b0; SW1 = 1'b0; SW2 = 1'b1; SW3 = 1'b0; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b0; SW2 = 1'b0; SW3 = 1'b1; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b1; SW2 = 1'b0; SW3 = 1'b0; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b0; SW2 = 1'b1; SW3 = 1'b1; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b0; SW2 = 1'b1; SW3 = 1'b0; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b0; SW2 = 1'b1; SW3 = 1'b0; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b0; SW2 = 1'b0; SW3 = 1'b1; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b1; SW2 = 1'b0; SW3 = 1'b0; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b0; SW2 = 1'b0; SW3 = 1'b0; SW4 = 1'b1; #10;
end
initial begin
	repeat (40) begin
		clk = 1'b0; #5;
		clk = 1'b1; #5;
	end
end
endmodule

module FSM_tb2();
logic SW0, SW1, SW2, SW3, SW4, clk;
wire [2:0] state;
wire [1:0] Z;
FSM FSM1 (clk, SW0, SW1, SW2, SW3, SW4, state, Z);
initial begin
	SW0 = 1'b1; SW1 = 1'b0; SW2 = 1'b0; SW3 = 1'b0; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b1; SW2 = 1'b0; SW3 = 1'b0; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b0; SW2 = 1'b1; SW3 = 1'b0; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b0; SW2 = 1'b0; SW3 = 1'b1; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b1; SW2 = 1'b0; SW3 = 1'b0; SW4 = 1'b0; #10;
	SW0 = 1'b0; SW1 = 1'b0; SW2 = 1'b0; SW3 = 1'b0; SW4 = 1'b1; #10;
end
initial begin
	repeat (40) begin
		clk = 1'b0; #5;
		clk = 1'b1; #5;
	end
end
endmodule

module ASCII27Seg (input [7:0] AsciiCode, output reg [6:0] HexSeg);
   always @ (*) begin
      HexSeg = 7'd0;
      case (AsciiCode)
	// A
      8'h41 : HexSeg[3] = 1;
	// a
      8'h61 : HexSeg[3] = 1;
	// B
      8'h42 : begin
	 HexSeg[0] = 1;
	 HexSeg[1] = 1;
      end
	// b
      8'h62 : begin
	 HexSeg[0] = 1;
	 HexSeg[1] = 1;
      end
	// C
      8'h43 : begin
	 HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[6] = 1;
      end
	// c
      8'h63 : begin
	 HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[6] = 1;
      end
	// D
      8'h44 : begin
	 HexSeg[0] = 1; HexSeg[5] = 1;
      end
	// d
      8'h64 : begin
	 HexSeg[0] = 1; HexSeg[5] = 1;
      end
	// E
      8'h45 : begin
	 HexSeg[1] = 1; HexSeg[2] = 1;
      end
	// e
      8'h65 : begin
	 HexSeg[1] = 1; HexSeg[2] = 1;
      end
	// F
      8'h46 : begin
	 HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[3] = 1;
      end
	// f
      8'h66 : begin
	 HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[3] = 1;
      end
	// G
      8'h47 : HexSeg[4] = 1;

	// g
      8'h67 : HexSeg[4] = 1;
	// H
      8'h48 : begin
	 HexSeg[0] = 1; HexSeg[3] = 1;
      end
	// h
      8'h68 : begin
	 HexSeg[0] = 1; HexSeg[3] = 1;
      end
	// I
      8'h49 : begin
	 HexSeg[3:0] = 4'b1111; HexSeg[6] = 1;
      end
	// i
      8'h69 : begin
	 HexSeg[3:0] = 4'b1111; HexSeg[6] = 1;
      end
	// J
      8'h4A : begin
	 HexSeg[6:5] = 2'b11; HexSeg[0] = 1;
      end
	// j
      8'h6A : begin
	 HexSeg[6:5] = 2'b11; HexSeg[0] = 1;
      end
	// K
      8'h4B : begin
	 HexSeg[0] = 1; HexSeg[3] = 1;
      end
	// k
      8'h6B : begin
	 HexSeg[0] = 1; HexSeg[3] = 1;
      end
	// L
      8'h4C : begin
	 HexSeg[2:0] = 3'b111; HexSeg[6] = 1;
      end
	// l
      8'h6C : begin
	 HexSeg[2:0] = 3'b111; HexSeg[6] = 1;
      end
	// M
      8'h4D : begin
	 HexSeg[6:5] = 2'b11; HexSeg[1] = 1; HexSeg[3] = 1;
      end
	// m
      8'h6D : begin
	 HexSeg[6:5] = 2'b11; HexSeg[1] = 1; HexSeg[3] = 1;
      end
	// N
      8'h4E : begin
	 HexSeg[1:0] = 2'b11; HexSeg[5] = 1; HexSeg[3] = 1;
      end
	// n
      8'h6E : begin
	 HexSeg[1:0] = 2'b11; HexSeg[5] = 1; HexSeg[3] = 1;
      end
	// O
      8'h4F : begin
	 HexSeg[6] = 1;
      end
	// o
      8'h6F : begin
	 HexSeg[6] = 1;
      end
	// P
      8'h50 : begin
	 HexSeg[3:2] = 2'b11;
      end
	// p
      8'h70 : begin
	 HexSeg[3:2] = 2'b11;
      end
	// Q
      8'h51 : begin
	 HexSeg[4:3] = 2'b11;
      end
	// q
      8'h71 : begin
	 HexSeg[4:3] = 2'b11;
      end
	// R
      8'h52 : begin
	 HexSeg[3:0] = 4'b1111; HexSeg[5] = 0;
      end
	// r
      8'h72 : begin
	 HexSeg[3:0] = 4'b1111; HexSeg[5] = 0;
      end
	// S
      8'h53 : begin
	 HexSeg[1] = 1; HexSeg[4] = 1;
      end
	// s
      8'h73 : begin
	 HexSeg[1] = 1; HexSeg[4] = 1;
      end
	// T
      8'h54 : begin
	 HexSeg[2:0] = 3'b111;
      end
	// t
      8'h74 : begin
	 HexSeg[2:0] = 3'b111;
      end
	// U
      8'h55 : begin
	 HexSeg[0] = 1; HexSeg[6] = 1;
      end
	// u
      8'h75 : begin
	 HexSeg[0] = 1; HexSeg[6] = 1;
      end
	// V
      8'h56 : begin
	 HexSeg[1:0] = 2'b11; HexSeg[6:5] = 2'b11;
      end
	// v
      8'h76 : begin
	 HexSeg[1:0] = 2'b11; HexSeg[6:5] = 2'b11;
      end
	// W
      8'h57 : begin
	 HexSeg[0] = 1; HexSeg[6] = 1; HexSeg[2] = 1; HexSeg[4] = 1;
      end
	// w
      8'h77 : begin
	 HexSeg[0] = 1; HexSeg[6] = 1; HexSeg[2] = 1; HexSeg[4] = 1;
      end
	// X
      8'h58 : begin
	 HexSeg[0] = 1; HexSeg[3] = 1;
      end
	// x
      8'h78 : begin
	 HexSeg[0] = 1; HexSeg[3] = 1;
      end
	// Y
      8'h59 : begin
	 HexSeg[0] = 1; HexSeg[4] = 1;
      end
	// y
      8'h79 : begin
	 HexSeg[0] = 1; HexSeg[4] = 1;
      end
	// Z
      8'h5A : begin
	 HexSeg[2] = 1; HexSeg[5] = 1;
      end
	// z
      8'h7A : begin
	 HexSeg[2] = 1; HexSeg[5] = 1;
      end
      8'h30 : begin
	 HexSeg[6] = 1;
      end
      8'h31 : begin
	 HexSeg[0] = 1; HexSeg[6:3] = 4'b1111;
      end
      8'h32 : begin
	 HexSeg[2] = 1; HexSeg[5] = 1;
      end
      8'h33 : begin
	 HexSeg[4] = 1; HexSeg[5] = 1;
      end
      8'h34 : begin
	 HexSeg[0] = 1; HexSeg[4:3] = 2'b11;
      end
      8'h35 : begin
	 HexSeg[1] = 1; HexSeg[4] = 1;
      end
      8'h36 : begin
	 HexSeg[1] = 1;
      end
      8'h37 : begin
	 HexSeg[6:3] = 4'b1111;
      end
      8'h38 : begin
	 HexSeg[6:0] = 7'b1111111;
      end
      8'h39 : begin
	 HexSeg[2] = 1;
      end
	// _
		8'h5F : begin
	 HexSeg[2:0] = 3'b111; HexSeg[6:4] = 3'b111; 
		end
    default : HexSeg = 7'b1111111;
      endcase
   end
endmodule

module StateToHexSeg (input [2:0] state, output [6:0] HexSeg3, HexSeg2, HexSeg1, HexSeg0);
logic [7:0] out [3:0];
always_comb begin
	out[3] = "N";
	out[2] = "a";
	out[1] = "t";
	out[0] = "h";

	case (state)
		3'b000: begin
			out[3] = "N";
			out[2] = "a";
			out[1] = "t";
			out[0] = "h";
		end
		3'b001: begin
			out[3] = "S";
			out[2] = "_";
			out[1] = "0";
			out[0] = "1";
		end
		3'b010: begin
			out[3] = "S";
			out[2] = "_";
			out[1] = "0";
			out[0] = "2";
		end
		3'b011: begin
			out[3] = "S";
			out[2] = "_";
			out[1] = "0";
			out[0] = "3";
		end
		3'b100: begin
			out[3] = "S";
			out[2] = "_";
			out[1] = "0";
			out[0] = "4";
		end
		default: begin
			out[3] = "N";
			out[2] = "a";
			out[1] = "t";
			out[0] = "h";
		end
	endcase
end
ASCII27Seg SegH3 (out[3], HexSeg3);
ASCII27Seg SegH2 (out[2], HexSeg2);
ASCII27Seg SegH1 (out[1], HexSeg1);
ASCII27Seg SegH0 (out[0], HexSeg0);   
endmodule

module FSM_pv (input KEY0, SW0, SW1, SW2, SW3, SW4, output logic [6:0] SEG0, SEG1, SEG2, SEG3, output logic [6:0] LED_SW, output [2:0] off_led);
logic [2:0] state;
logic [1:0] Z;
FSM FSM1 (KEY0, SW0, SW1, SW2, SW3, SW4, state, Z);
StateToHexSeg Hex1 (state, SEG3, SEG2, SEG1, SEG0);
assign off_led = 3'b000;
assign LED_SW[0] = SW0;
assign LED_SW[1] = SW1;
assign LED_SW[2] = SW2;
assign LED_SW[3] = SW3;
assign LED_SW[4] = SW4;
assign LED_SW[5] = Z[0];
assign LED_SW[6] = Z[1];
endmodule















