parameter IF = 2'b00;
parameter FD = 2'b01;
parameter EX = 2'b10;
parameter RWB = 2'b11;

module ROM (input [7:0] PC, output logic [15:0] IR);
logic [15:0] mem [20:0];

assign mem[0] = 16'h2000;
assign mem[1] = 16'h2011;
assign mem[2] = 16'h2002;
assign mem[3] = 16'h20A3;
assign mem[4] = 16'hD236;
assign mem[5] = 16'h1014;
assign mem[6] = 16'h4100;
assign mem[7] = 16'h4401;
assign mem[8] = 16'h8022;
assign mem[9] = 16'hE040;
assign mem[10] = 16'h4405;
assign mem[11] = 16'h5536;
assign mem[12] = 16'h6637;
assign mem[13] = 16'h3538;
assign mem[14] = 16'h4239;
assign mem[15] = 16'h709A;
assign mem[16] = 16'h70AB;
assign mem[17] = 16'hBB8C;
assign mem[18] = 16'h9D8E;
assign mem[19] = 16'hC0EF;
assign mem[20] = 16'hF000;

assign IR = mem[PC];

endmodule

module RegFile (input clk, reset, input [3:0] RA, RB, RD, OPCODE, input [1:0] current_state, input [7:0] RF_data_in, output logic [7:0] RF_data_out0, output logic [7:0] RF_data_out1);
localparam One = 8'd1, Zero = 8'd0, one = 1'b1, zero = 1'b0;
logic [4:0] i;
logic [7:0] RF [15:0];

always_ff @ (posedge clk or posedge reset) begin
	i = 5'd0;
	if (reset) begin
		RF_data_out0 <= Zero;
		RF_data_out1 <= Zero;
		for (i = 5'd0; i < 5'd16; i=i+5'd1)
			RF[i] <= Zero;
	end
	else begin
		RF_data_out0 <= RF[RA];
		RF_data_out1 <= RF[RB];
		if ((current_state == RWB) && ~ ((OPCODE == 4'd13) || (OPCODE == 4'd14) || (OPCODE == 4'd15)))
			RF[RD] <= RF_data_in;
	end
end
endmodule

module IRReg (input [15:0] IR, output logic [3:0] OPCODE, RA, RB, RD);
assign OPCODE = IR[15:12];
assign RA = IR[11:8];
assign RB = IR[7:4];
assign RD = IR[3:0];
endmodule

function [7:0] extend_out;
	input [3:0] A;
	if (A[3] == 1'b1)
		extend_out = {4'b1111, A};
	else
		extend_out = {4'd0, A};
endfunction

module ALU (input [7:0] A, B, input [3:0] OPCODE, RA, RB, output logic [7:0] ALUOut, output logic Cout, OF);
localparam One = 8'd1, Zero = 8'd0, one = 1'b1, zero = 1'b0;
logic [7:0] Bn, RTemp, extB;
always_comb begin
	ALUOut = Zero;
	Cout = zero;
	OF = zero;
	RTemp = Zero;
	Bn = Zero;
	extB = Zero;
	case (OPCODE)
		4'h1: begin //ADD
			{Cout, ALUOut} = {zero, A} + {zero, B};
			OF = (~B[7]^Bn[7])&ALUOut[7];
		end
		4'h2: ALUOut = {RA,RB}; //LDI
		4'h3: begin //SUB
			Bn = ~B + One;
			{Cout, ALUOut} = {zero, A} + {zero, Bn};
			OF = (~A[7]^Bn[7])&ALUOut[7];
		end
		4'h4: begin //ADI
			extB = extend_out(RB);
			{Cout, ALUOut} = {zero, A} + {zero, extB};
			OF = (~A[7]^extB[7])&ALUOut[7];
		end
		4'h5: begin //DIV
			ALUOut = A / B; 
			OF = (~A[7]^B[7])&ALUOut[7];
		end
		4'h6: begin //MUL
			{RTemp, ALUOut} = A * B;
			Cout = (RTemp == 8'd0|RTemp == -8'd1) ? 1'b0: 1'b1;
			OF = (ALUOut[7]^A[7]^B[7])|Cout;
		end
		4'h7: begin //DEC
			Bn = ~One + One;
			{Cout, ALUOut} = {zero, B} + {zero, Bn};
			OF = (~B[7]^Bn[7])&ALUOut[7];
		end
		4'h8: begin //INC
			{Cout, ALUOut} = {zero, B} + {zero, One};
			OF = (~B[7]^One[7])&ALUOut[7];
		end
		4'h9: ALUOut = ~(A|B); //NOR
		4'hA: ALUOut = ~(A&B); //NAND
		4'hB: ALUOut = A^B; //XOR
		4'hC: ALUOut = ~(B); //COMP
		4'hD: ALUOut = Zero; //CMPJ, comparision done in control
		4'hE: ALUOut = Zero; //JMP, addr calculated in control
		4'hF: ALUOut = Zero; //HLT
		default: ALUOut = Zero;
	endcase
end
endmodule

module WReg (input clk, reset, input [7:0] Din, output logic [7:0] Dout);
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		Dout <= 8'd0;
	else
		Dout <= Din;
end
endmodule

module lab5 (input clk, reset, output logic [3:0] OPCODE, output logic [1:0] State, output logic [7:0] PC, Alu_out, W_Reg, output logic Cout, OF, output logic [3:0] RA, RB, RD, output logic [15:0] IR);
logic [15:0] Instruction;
logic [7:0] A, B, nextPC;
logic [1:0] nextState;
assign IR = Instruction;
ROM ROM (PC, Instruction);
IRReg IReg (Instruction, OPCODE, RA, RB, RD);
RegFile RF (clk, reset, RA, RB, RD, OPCODE, State, W_Reg, A, B);
ALU ALU (A, B, OPCODE, RA, RB, Alu_out, Cout, OF);
WReg WReg (clk, reset, Alu_out, W_Reg);

always_comb begin
	nextState = 2'b0;
	case (State)
		IF: nextState = FD;
		FD: nextState = EX;
		EX: nextState = RWB;
		RWB: nextState = IF;
		default: nextState = State;
	endcase
	if (OPCODE == 4'hD) // CMPJ
		nextPC = (A >= B)? (PC+extend_out(RD)):(PC+8'd1); // Sign extend RD to 8 bits
	else if (OPCODE == 4'hE)
		nextPC = {RA,RB};
	else
		nextPC = PC + 8'd1;
end

always_ff @ (posedge clk or posedge reset) begin
	if (reset) begin
		State <= IF;
		PC <= 8'd0;
	end
	else begin
		if (OPCODE != 4'hF) begin
			State <= nextState;
			if (State == RWB)
				PC <= nextPC;
		end
	end
end
endmodule

module lab5_tb();
logic clk, reset, Cout, OF;
logic [3:0] OPCODE, RA, RB, RD;
logic [1:0] State;
logic [7:0] PC, Alu_out, W_Reg;
logic [15:0] IR;
integer f;
lab5 MCU (clk, reset, OPCODE, State, PC, Alu_out, W_Reg, Cout, OF, RA, RB, RD, IR);
initial begin
	f = $fopen("log.csv");
	$fwrite(f, "PC, IR, OPCODE, RA, RB, RD, W_Reg, Cout, OF\n");
	reset = 1'b1; #10;
	reset = 1'b0; #10;
	$fwrite(f, "%h, %h, %h, %h, %h, %h, %b, %b, %b\n", PC, IR, OPCODE, RA, RB, RD, W_Reg, Cout, OF);
	repeat (305) begin
		clk = 1'b0; #10;
				$fwrite(f, "%h, %h, %h, %h, %h, %h, %h, %h, %h\n", PC, IR, OPCODE, RA, RB, RD, W_Reg, Cout, OF);
		clk = 1'b1; #10;
	end
	$fclose(f);
end
endmodule

module pmcntr #(parameter siz=25) (input clk, reset, input [siz-1:0] count_max, output logic [siz-1:0] count, output logic clkout);
always_ff @ (posedge clk or posedge reset)
	if (reset) begin
		count <= {siz{1'b0}};
		clkout <= 1'b0;
	end
	else if (count<count_max)
		count <= count + {{(siz-1){1'b0}},1'b1};
	else begin
		count <= {siz{1'b0}};
		clkout <= ~clkout;
	end
endmodule


module lab5_pv(input clk, SW0, SW1, KEY0, SW2, SW3, SW4, output logic [6:0] SevSeg5, SevSeg4, SevSeg3, SevSeg2, SevSeg1, SevSeg0, output logic LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7);
logic Cout, OF, low_freq_clk, MCU_clk;
logic [3:0] OPCODE, RA, RB, RD;
logic [1:0] State;
logic [7:0] PC, Alu_out, W_Reg;
logic [15:0] IR;
logic [2:0] SS_state;
logic [47:0] SevSeg;
logic [24:0] count;

pmcntr P1 (clk, SW0, 25'd5000000, count, low_freq_clk); // 5Hz
lab5 MCU (MCU_clk, SW0, OPCODE, State, PC, Alu_out, W_Reg, Cout, OF, RA, RB, RD, IR);

assign LED0 = PC[0];
assign LED1 = PC[1];
assign LED2 = PC[2];
assign LED3 = PC[3];
assign LED4 = PC[4];
assign LED5 = PC[5];
assign LED6 = PC[6];
assign LED7 = PC[7];

assign SS_state = {SW4, SW3, SW2};

always_comb begin
	MCU_clk = 1'b0;
	SevSeg = 48'd0;
	case(SW1)
		1'b0: MCU_clk = low_freq_clk;
		1'b1: MCU_clk = KEY0;
		default: MCU_clk = low_freq_clk;
	endcase
	case(SS_state)
		3'b000: SevSeg = {8'h4E, 8'h61, 8'h74, 8'h68, 16'd0};
		3'b110: SevSeg = {32'd0,{4'd0,PC[7:4]}, {4'd0, PC[3:0]}};
		3'b101: SevSeg = {32'd0,{4'd0,W_Reg[7:4]}, {4'd0, W_Reg[3:0]}};
		3'b011: SevSeg = {32'd0,{4'd0,Alu_out[7:4]}, {4'd0, Alu_out[3:0]}};
		3'b111: SevSeg = {40'd0, {4'd0, OPCODE[3:0]}};
		default: SevSeg = 48'd0;
	endcase
end

ASCII27Seg A1 (SevSeg[47:40], SevSeg5);
ASCII27Seg A2 (SevSeg[39:32], SevSeg4);
ASCII27Seg A3 (SevSeg[31:24], SevSeg3);
ASCII27Seg A4 (SevSeg[23:16], SevSeg2);
Dec27Seg D1 (SevSeg[15:8], SevSeg1);
Dec27Seg D2 (SevSeg[7:0], SevSeg0);

endmodule















