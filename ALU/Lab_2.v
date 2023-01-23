module HA(input A, B, output Sum, Cout);
assign Sum = A^B;
assign Cout = A&B;
endmodule

module FA(input A, B, Cin, output Sum, Cout);
wire Sum1, Cout1, Cout2;
HA ha1 (A, B, Sum1, Cout1);
HA ha2 (Sum1, Cin, Sum, Cout2);
assign Cout = Cout1|Cout2;
endmodule

module FA_tb();
reg A, B, Cin;
wire Sum, Cout;
FA fa1 (A, B, Cin, Sum, Cout);
initial begin
	A = 0; B = 0; Cin = 0; #10;
	A = 1; B = 0; #10;
	A = 0; B = 1; #10;
	A = 1; B = 1; #10;
	A = 0; B = 0; Cin = 1; #10;
	A = 1; B = 0; #10;
	A = 0; B = 1; #10;
	A = 1; B = 1; #10;
end
endmodule

module FA4(input [3:0] A, B, input Cin, output [3:0] Sum, output Cout, OF);
wire Cout1, Cout2, Cout3;
FA fa1 (A[0], B[0], Cin, Sum[0], Cout1);
FA fa2 (A[1], B[1], Cout1, Sum[1], Cout2);
FA fa3 (A[2], B[2], Cout2, Sum[2], Cout3);
FA fa4 (A[3], B[3], Cout3, Sum[3], Cout);
assign OF = Cout3^Cout;
endmodule

module com2s(input [3:0] B, output [3:0] Bn);
wire [3:0] Bn_temp;
wire Cout, OF;
assign Bn_temp = ~B;
FA4 fa1 (Bn_temp, 4'b0001, 1'b0, Bn, Cout, OF); 
endmodule

module ALU(input [3:0] A, B, OPCODE, input Cin, output [3:0] Out, output Cout, output OF);
reg [3:0] Bin, Ain, Out_, Cout_, OF_;
reg C_in;
wire [3:0] Bn, Sum;
wire CO, OFlow;
com2s C1 (B, Bn);
FA4 fa1 (Ain, Bin, C_in, Sum, CO, OFlow);
assign Out = Out_;
assign Cout = Cout_;
assign OF = OF_;
always @ (*) begin
	Ain = 4'd0; Bin = 4'd0; C_in = 0'b0; Out_ = 4'd0; Cout_ = 1'b0; OF = 1'b0;
	case(OPCODE)
		// Add A, B
		4'b0001: begin
			Ain = A; Bin = B; C_in = 0'b0; Out_ = Sum; Cout_ = CO; OF_ = OFlow;
		end
		// Add A, B, Cin
		4'b0010: begin 
			Ain = A; Bin = B; C_in = Cin; Out_ = Sum; Cout_ = CO; OF_ = OFlow;
		end
		// Add A, -B
		4'b0011: begin 
			Ain = A; Bin = Bn; C_in = 0'b0; Out_ = Sum; Cout_ = CO; OF_ = OFlow;
		end
		// Bitwise AND	
		4'b0100: begin 
			Out_ = A&B; Cout_ = 0'b0; OF_ = 0'b0;
		end	
		// Bitwise NOR
		4'b0101: begin 
			Out_ = ~(A|B); Cout_ = 0'b0; OF_ = 0'b0;
		end	
		// Bitwise XNOR
		4'b0110: begin 
			Out_ = A~^B; Cout_ = 0'b0; OF_ = 0'b0;
		end
		// Bitwise NOT A
		4'b0111: begin 
			Out_ = ~A; Cout_ = 0'b0; OF_ = 0'b0;
		end	
		// Shfit A to right by 1
		4'b1000: begin
			Out_ = A >> 1;  Cout_ = 0'b0; OF_ = 0'b0;
		end	
		// Custom func
		4'b1001: begin
			Ain = A|B; Bin = ~(A&B) >> 1; C_in = 0'b0; Out_ = Sum; Cout_ = CO; OF_ = OFlow;
		end
		default: begin
			Out_ = 4'b0000; Cout_ = 0'b0; OF_ = 0'b0; 
		end
	endcase
end
endmodule