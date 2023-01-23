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
	 HexSeg[6:0] = 8'b11111111;
      end
      8'h39 : begin
	 HexSeg[2] = 1;
      end
      default : HexSeg = 8'b11111111;
      endcase
   end
endmodule

module ASCIICodes (input Kkey0, output [6:0] HexSeg4, HexSeg3, HexSeg2, HexSeg1, HexSeg0);
   reg [7:0] Message [4:0];
   always @ (*) begin
      Message[4] = "H";
      Message[3] = "e";
      Message[2] = "l";
      Message[1] = "l";
      Message[0] = "o";

      case (Kkey0)
         1'b1 : begin
            Message[4] = "H";
            Message[3] = "e";
            Message[2] = "l";
            Message[1] = "l";
            Message[0] = "o";
         end
         1'b0 : begin
            Message[4] = "D";
            Message[3] = "N";
            Message[2] = "";
            Message[1] = "";
            Message[0] = "";
         end
         default : begin
            Message[4] = "H";
            Message[3] = "e";
            Message[2] = "l";
            Message[1] = "l";
            Message[0] = "o";
         end
      endcase
   end
   
   ASCII27Seg SevH4 (Message[4], HexSeg4);
   ASCII27Seg SevH3 (Message[3], HexSeg3);
   ASCII27Seg SevH2 (Message[2], HexSeg2);
   ASCII27Seg SevH1 (Message[1], HexSeg1);
   ASCII27Seg SevH0 (Message[0], HexSeg0);   
endmodule

module ascii_numb_tb();
reg [7:0] AsciiCode;
wire [6:0] HexSeg;
ASCII27Seg A1 (AsciiCode, HexSeg);

initial begin
   AsciiCode = 8'h30; #10;sim:/ASCIICodes
   AsciiCode = 8'h31; #10;
   AsciiCode = 8'h32; #10;
   AsciiCode = 8'h33; #10;
   AsciiCode = 8'h34; #10;
   AsciiCode = 8'h35; #10;
   AsciiCode = 8'h36; #10;
   AsciiCode = 8'h37; #10;
   AsciiCode = 8'h38; #10;
   AsciiCode = 8'h39; #10;
end
endmodule

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
	 HexSeg[6:0] = 8'b11111111;
      end
      8'h9 : begin
	 HexSeg[2] = 1;
      end
      endcase
   end
endmodule

module dec_numb_tb();
reg [7:0] Decimal;
wire [6:0] HexSeg;
Dec27Seg A1 (Decimal, HexSeg);

initial begin
   Decimal = 8'h0; #10;
   Decimal = 8'h1; #10;
   Decimal = 8'h2; #10;
   Decimal = 8'h3; #10;
   Decimal = 8'h4; #10;
   Decimal = 8'h5; #10;
   Decimal = 8'h6; #10;
   Decimal = 8'h7; #10;
   Decimal = 8'h8; #10;
   Decimal = 8'h9; #10;
end
endmodule

module ASCIICodes_tb();
reg Kkey0;
wire [6:0] HexSeg4;
wire [6:0] HexSeg3;
wire [6:0] HexSeg2;
wire [6:0] HexSeg1;
wire [6:0] HexSeg0;

ASCIICodes A1 (Kkey0, HexSeg4, HexSeg3, HexSeg2, HexSeg1, HexSeg0);
initial begin
   Kkey0 = 1'b1; #10;
   Kkey0 = 1'b0; #10;
end
endmodule













   
	