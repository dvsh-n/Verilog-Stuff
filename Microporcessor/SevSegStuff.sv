
module Dec27Seg (input [7:0] Decimal, output reg [6:0] HexSeg);
   always @ (*) begin
      HexSeg = 7'd0;
      case (Decimal)
      8'h0 : begin
	 HexSeg[6] = 1;
      end
      8'h1 : begin
	 HexSeg[0] = 1; HexSeg[6:3] = 4'b1111;
      end
      8'h2 : begin
	 HexSeg[2] = 1; HexSeg[5] = 1;
      end
      8'h3 : begin
	 HexSeg[4] = 1; HexSeg[5] = 1;
      end
      8'h4 : begin
	 HexSeg[0] = 1; HexSeg[4:3] = 2'b11;
      end
      8'h5 : begin
	 HexSeg[1] = 1; HexSeg[4] = 1;
      end
      8'h6 : begin
	 HexSeg[1] = 1;
      end
      8'h7 : begin
	 HexSeg[6:3] = 4'b1111;
      end
      8'h8 : begin
	 HexSeg[6:0] = 7'd0;
      end
      8'h9 : begin
	 HexSeg[4] = 1;
      end
		8'hA: HexSeg[3] = 1;
		8'hB:  begin
			HexSeg[0] = 1;
			HexSeg[1] = 1;
      end
		8'hC: begin
			HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[6] = 1;
      end
		8'hD: begin
			HexSeg[0] = 1; HexSeg[5] = 1;
      end
		8'hE:  begin
			HexSeg[1] = 1; HexSeg[2] = 1;
      end
		8'hF:begin
			 HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[3] = 1;
      end
		default : HexSeg[6:0] = 7'd0;
      endcase
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
	 HexSeg[1] = 1; HexSeg[4] = 0;
      end
	// s
      8'h73 : begin
	 HexSeg[1] = 1; HexSeg[4] = 0;
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
	 HexSeg[6:0] = 7'd0;
      end
      8'h39 : begin
	 HexSeg[2] = 1;
      end
      default : HexSeg[6] = 1;
      endcase
   end
endmodule
