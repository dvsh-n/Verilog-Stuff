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
// 25 Million is 25 bits: 1011111010111100001000000

module pmcntr_tb();
logic clk, reset, clkout;
logic [4:0] count;
localparam count_max = 5'd4;
pmcntr #(5) half_ten (clk, reset, count_max, count, clkout);
initial begin
	reset = 1'b1; #5
	reset = 1'b0;
	repeat (40) begin
		clk = 1'b1; #10;
		clk = 1'b0; #10;
	end
end
endmodule
// Initially had max count to divide 10 clk cycles by 2 for testing however, I realized that since the counter starts from 0, going from 0 to 5-1 counts 5 clocks.
// This wont matter as much in the main design because one clock cycle is a very small percentage of the 50M clock cycles.
// Count till 12.5M to get a 2Hz clock.

module clocktime (input clk, enable, reset, input [7:0] Maxval, output logic [7:0] Count, output logic clkout);
localparam Zero = 8'd0, One = 8'd1, zero = 1'b0, one = 1'b1;
always_ff @ (posedge clk or posedge reset) begin
	if (reset) begin
		Count <= Zero;
		clkout <= zero;
	end
	else
		if (enable) 
			if (Count < Maxval) begin
				Count <= Count + One;
				clkout <= zero;		
			end
			else begin
				Count <= Zero;
				clkout <= one;
			end
end
endmodule
// Counts the clock pulses to maxval. After maxval is reached, sends output clock pulse to another clocktime (that resets to 0 after 1 clk) module to keep time and also resets count to Zero. 
// Since clock starts at 0, maxval has to be desired_maxval-1.

module fdivby2 (input clk, reset, output logic clkout);
always_ff @ (posedge reset or posedge clk) begin
	if (reset) 
		clkout <= 1'b0;
	else
		clkout <= ~clkout;
end
endmodule
// Divides the 2Hz clock by 2 to give 1Hz

module fdivby2_tb();
logic clk, reset, clkout;
fdivby2 F1 (clk, reset, clkout);
initial begin
	reset = 1'b1; #5
	reset = 1'b0;
	repeat (40) begin
		clk = 1'b1; #10;
		clk = 1'b0; #10;
	end
end
endmodule

module timer (input oneHz, twoHz, reset, set_min_t, set_hr_t, output logic [7:0] Hours, Minutes, Seconds);
localparam fiftynine = 8'd59, twentythree = 8'd23;

logic clk_min, clk_sec, clk_hr;
logic enable_Sec, enable_Min, enable_Hrs;
logic Min_in, Hr_in, Days_in;

clocktime secClock(clk_sec, enable_Sec, reset, fiftynine, Seconds, Min_in);
clocktime minClock(clk_min, enable_Min, reset, fiftynine, Minutes, Hr_in);
clocktime hrClock(clk_hr, enable_Hrs, reset, twentythree, Hours, Days_in);

always_comb begin
	clk_sec = oneHz;
	clk_min = Min_in;
	clk_hr = Hr_in;
	enable_Sec = 1'b1; enable_Min = 1'b1; enable_Hrs = 1'b1;
	if (set_min_t == 1'b1) begin
		clk_sec = 1'b0; clk_min = twoHz; clk_hr = 1'b0;
		enable_Sec = 1'b0; enable_Min = 1'b1; enable_Hrs = 1'b0;
	end
	if (set_hr_t == 1'b1) begin
		clk_sec = 1'b0; clk_min = 1'b0; clk_hr = twoHz;
		enable_Sec = 1'b0; enable_Min = 1'b0; enable_Hrs = 1'b1;
	end
end
endmodule 
// Keeps time

module timer_tb();
logic oneHz, twoHz, reset, set_min_t, set_hr_t;
logic [7:0] Hours, Minutes, Seconds;
timer T1 (oneHz, twoHz, reset, set_min_t, set_hr_t, Hours, Minutes, Seconds);
fdivby2 F1 (twoHz, reset, oneHz);
initial begin
	reset = 1'b1; #5;
	reset = 1'b0;
	repeat (20) begin
		twoHz = 1'b0; # 5; // Two Hz
		twoHz = 1'b1; # 5;
	end
	repeat (20) begin
		set_min_t = 1'b1;
		twoHz = 1'b0; # 5; // Two Hz
		twoHz = 1'b1; # 5;
	end
	repeat (80) begin
		set_min_t = 1'b0; set_hr_t = 1'b1;
		twoHz = 1'b0; # 5; // Two Hz
		twoHz = 1'b1; # 5;
	end
end
endmodule

module D_FF (input clk, D, enable, reset, output logic Q);
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		Q <= 1'b0;
	else if (enable) 
		Q <= D;
end
endmodule
// D Flip Flop for alarm

module alarm_clock(input CLK_2Hz, reset, time_set, alarm_set, sethrs1min0, run, activatealarm, alarmreset, KEY1, output logic [7:0] sec, min, hrs, sec_alrm, min_alrm, hrs_alrm, output logic alrm);

logic CLK_1Hz, CLK_1Hz_clock, D_out;
fdivby2 F1 (CLK_2Hz, reset, CLK_1Hz);

logic [1:0] set;
logic set_min_clock, set_hr_clock, set_min_alarm, set_hr_alarm;

timer clock (CLK_1Hz_clock, CLK_2Hz, reset, set_min_clock, set_hr_clock, hrs, min, sec); //CLK_1Hz_clock is CLK_1Hz only when time_set and alarm_set are both 0 and run is 1.
timer alarm (1'b0, CLK_2Hz, reset, set_min_alarm, set_hr_alarm, hrs_alrm, min_alrm, sec_alrm); // alarm never runs on the 1Hz clock

always_comb begin
	CLK_1Hz_clock = 1'b0;
	set_min_clock = 1'b0;
	set_hr_clock = 1'b0;
	set_min_alarm = 1'b0;
	set_hr_alarm = 1'b0;

	set = {time_set, alarm_set};
	case (set)
		2'b00: begin
			if (run) CLK_1Hz_clock = CLK_1Hz;
			else CLK_1Hz_clock = 1'b0;
			set_min_clock = 1'b0;
			set_hr_clock = 1'b0;
			set_min_alarm = 1'b0;
			set_hr_alarm = 1'b0;					
		end
		2'b01: begin
			CLK_1Hz_clock = 1'b0;	
			set_min_clock = 1'b0;
			set_hr_clock = 1'b0;
			if (sethrs1min0 == 1'b1 && KEY1 == 1'b0) begin
				set_hr_alarm = 1'b1;
				set_min_alarm = 1'b0;
			end
			else if (sethrs1min0 == 1'b0 && KEY1 == 1'b0) begin
				set_hr_alarm = 1'b0;
				set_min_alarm = 1'b1;		
			end
			else begin
				set_hr_alarm = 1'b0;
				set_min_alarm = 1'b0;				
			end	
		end
		2'b10: begin
			CLK_1Hz_clock = 1'b0;	
			set_min_alarm = 1'b0;
			set_hr_alarm = 1'b0;
			if (sethrs1min0 == 1'b1 && KEY1 == 1'b0) begin
				set_hr_clock = 1'b1;
				set_min_clock = 1'b0;
			end
			else if (sethrs1min0 == 1'b0 && KEY1 == 1'b0) begin
				set_hr_clock = 1'b0;
				set_min_clock = 1'b1;		
			end
			else begin
				set_hr_clock = 1'b0;
				set_min_clock = 1'b0;				
			end	
		end
		2'b11: begin
			CLK_1Hz_clock = 1'b0;	
			if (sethrs1min0 == 1'b1 && KEY1 == 1'b0) begin
				set_hr_clock = 1'b1;
				set_hr_alarm = 1'b1;
			end
			else if (sethrs1min0 == 1'b0 && KEY1 == 1'b0) begin
				set_min_clock = 1'b1;
				set_min_alarm = 1'b1;
			end
			else begin
				set_min_alarm = 1'b0;
				set_hr_alarm = 1'b0;
				set_hr_clock = 1'b0;
				set_min_clock = 1'b0;				
			end	
		end
		default: begin
			if (run) CLK_1Hz_clock = CLK_1Hz;
			else CLK_1Hz_clock = 1'b0;
			set_min_clock = 1'b0;
			set_hr_clock = 1'b0;
			set_min_alarm = 1'b0;
			set_hr_alarm = 1'b0;	
		end
	endcase
end	
D_FF D1 (hrs==hrs_alrm & min==min_alrm, 1'b1, activatealarm, reset|alarmreset, D_out);
and (alrm, D_out, CLK_2Hz);
endmodule
// set_time and set_alarm are just switches that are used to select what gets displayed on the 7 Seg display. Use a case statement and concatenate their inputs in one array.
// SW0 is master reset and resets clock and alarm both to 0.
// 10/31/2022 Take off from here, look at Switch Functions in the lab manual and modify alarm_clock accordingly.
// 11/1/2022 The alarm_clock module sets time or alarm only when one of time_set and alarm_set is 1.
// 11/3/2022 when both time_set and alarm_set are 1, I choose both to be set simultaneously.
// The value of KEY1 only matters when the clock is in any set state. Otherwise, the clock doesnt care about KEY1 value.

module alarm_clock_tb();
logic CLK_2Hz, reset, time_set, alarm_set, sethrs1min0, run, activatealarm, alarmreset, alrm;
logic [7:0] sec, min, hrs, sec_alrm, min_alrm, hrs_alrm;
alarm_clock clock (CLK_2Hz, reset, time_set, alarm_set, sethrs1min0, run, activatealarm, alarmreset, 1'b0, sec, min, hrs, sec_alrm, min_alrm, hrs_alrm, alrm);
initial begin
	time_set = 1'b0; alarm_set = 1'b0; run = 1'b1; activatealarm = 1'b1; alarmreset = 1'b0;
	reset = 1'b1; #5;
	reset = 1'b0;
	repeat (7) begin
		time_set = 1'b1; alarm_set = 1'b1; sethrs1min0 = 1'b1;
		CLK_2Hz = 1'b0; #5;
		CLK_2Hz = 1'b1; #5;
	end
	repeat (21) begin
		time_set = 1'b1; alarm_set = 1'b1; sethrs1min0 = 1'b0;
		CLK_2Hz = 1'b0; #5;
		CLK_2Hz = 1'b1; #5;
	end
	repeat (1) begin
		time_set = 1'b0; alarm_set = 1'b1; sethrs1min0 = 1'b0;
		CLK_2Hz = 1'b0; #5;
		CLK_2Hz = 1'b1; #5;
	end
	repeat (130) begin
		time_set = 1'b0; alarm_set = 1'b0; sethrs1min0 = 1'b0;
		CLK_2Hz = 1'b0; #5;
		CLK_2Hz = 1'b1; #5;
	end
	alarmreset = 1'b1;
end
endmodule
// 11/3/2022 alarm clock tb completed
// Both alarm and time hrs are set to 7
// Both alarm and time mins are set to 21
// Alarm is set to 22
// Time is run
// Alarm goes off at 7:22
// About 5 seconds after the alarm has set off, the alarm is set to 0


module high_low_splitter(input [7:0] number, output logic [7:0] H, L);
function [7:0] msb;
	input [7:0] A;
	integer i;
	msb = 0;
	for (i=0;i<=9;i=i+1)
		if (A>(msb*8'd10+8'd9))
			msb = msb + 8'd1;
endfunction
always_comb begin
	H = msb(number);
	L = number - H * 8'd10;
end
endmodule
// 11/5/2022 high low splitter to split most significant bit of time input

module high_low_splitter_tb();
logic [7:0] number, H, L;
high_low_splitter H1 (number, H, L);

initial begin
number = 8'd23; #10;
number = 8'd24; #10;
end

endmodule
// 11/5/2022 Test for high_low_splitter;

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
		default : HexSeg[6:0] = 7'd0;
      endcase
   end
endmodule
// 11/5/2022 Converts Decimal Values for HexSeg Display

module alarm_clock_pv (input CLK, SW5, SW4, SW3, SW2, SW1, SW0, KEY1, KEY0, output logic [6:0] SEC_LSD, SEC_MSD, MIN_LSD, MIN_MSD, HR_LSD, HR_MSD, output logic LED7, LED5, LED4, LED3, LED2, LED1, LED0, LED9, LED8, LED6);
assign LED5 = SW5;
assign LED4 = SW4;
assign LED3 = SW3;
assign LED2 = SW2;
assign LED1 = SW1;
assign LED0 = SW0;
assign LED9 = 1'b0;
assign LED8 = 1'b0;
assign LED6 = 1'b0;

logic CLK_2Hz;
logic [24:0] count;
logic [7:0] sec, min, hrs, sec_alrm, min_alrm, hrs_alrm, number_sec, number_min, number_hr;
logic [7:0] dSEC_LSD, dSEC_MSD, dMIN_LSD, dMIN_MSD, dHR_LSD, dHR_MSD; // Will hold 8'd values for bits for hexseg

pmcntr CLK2HzGen (CLK, SW0, 25'd12500000, count, CLK_2Hz); // 2Hz Clock Gen

alarm_clock clock (CLK_2Hz, SW0, SW2, SW1, SW3, SW5, SW4, KEY0, KEY1, sec, min, hrs, sec_alrm, min_alrm, hrs_alrm, LED7); // Alarm clock module

high_low_splitter SEC (number_sec, dSEC_MSD, dSEC_LSD); // Splitters
high_low_splitter MIN (number_min, dMIN_MSD, dMIN_LSD);
high_low_splitter HR (number_hr, dHR_MSD, dHR_LSD);

Dec27Seg D1 (dSEC_LSD, SEC_LSD); // HexSeg display Modules
Dec27Seg D2 (dSEC_MSD, SEC_MSD);
Dec27Seg D3 (dMIN_LSD, MIN_LSD);
Dec27Seg D4 (dMIN_MSD, MIN_MSD);
Dec27Seg D5 (dHR_LSD, HR_LSD);
Dec27Seg D6 (dHR_MSD, HR_MSD);


logic [1:0] set;
always_comb begin
	number_sec = sec;
	number_min = min;
	number_hr = hrs;
	set = {SW2, SW1}; // {time_set, alarm_set}
	case (set)
		2'b00: begin
			number_sec = sec;
			number_min = min;
			number_hr = hrs;
		end
		2'b01: begin
			number_sec = sec_alrm;
			number_min = min_alrm;
			number_hr = hrs_alrm;
		end
		2'b10: begin
			number_sec = sec;
			number_min = min;
			number_hr = hrs;
		end
		2'b11: begin
			number_sec = sec;
			number_min = min;
			number_hr = hrs;
		end
		default: begin
			number_sec = sec;
			number_min = min;
			number_hr = hrs;
		end
	endcase
end
endmodule




















