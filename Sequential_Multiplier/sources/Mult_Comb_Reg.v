module Mult_Comb_Reg #(parameter LENGTH = 5)(a, b, y, start, reset, clock, Negative, finish);

input [LENGTH-1:0] a, b;
input start, reset, clock;
output reg [LENGTH*2-1:0] y;
output reg Negative;
output reg finish;

reg [LENGTH*LENGTH*2-1:0] partials;
reg [LENGTH-1:0] a_temp, b_temp;
integer i;

always @(posedge clock, posedge reset)
	begin
	if (reset)
		begin
		y <= 0;
		Negative <= 1'b1;
		i = 1;
		finish = 1'b0;
		end
	else 
		if (start)
			begin
				a_temp <= a[LENGTH-1] ? ~a + 1 : a;
				b_temp <= b[LENGTH-1] ? ~b + 1 : b;
				partials[LENGTH*2-1:0] <= a_temp[0] ? b_temp : 0;
				if (i < LENGTH)
					begin
						partials[LENGTH*2*(i+1)-1-:LENGTH*2] <= (a_temp[i] ? (({LENGTH*2{1'b0}} + b_temp ) << i) : 0) + partials[LENGTH*2*i-1-:LENGTH*2];
						i = i+1;
						finish = 1'b0;
					end
				else
					begin
						y <= partials[LENGTH*LENGTH*2-1:LENGTH*(LENGTH-1)*2];
						Negative <= a[LENGTH-1] ^ b[LENGTH-1] ? 1 : 0;
						i = 1;
						finish = 1'b1;
					end
			end
		else
			y <= y;
	end
endmodule