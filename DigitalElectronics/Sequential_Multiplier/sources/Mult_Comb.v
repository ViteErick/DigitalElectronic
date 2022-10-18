module Mult_Comb(a, b, y, Negative);

parameter width = 8;
input [width-1:0] a, b;
output [width*2-1:0] y;
output Negative;

wire [width*width*2-1:0] partials;
wire [width-1:0] a_temp, b_temp;

genvar i;
assign a_temp = a[width-1] ? ~a + 1 : a;
assign b_temp = b[width-1] ? ~b + 1 : b;
assign partials[width*2-1:0] = a_temp[0] ? b_temp : 0;
generate 
    for (i = 1; i < width; i = i+1) 
    begin:gen
    assign partials[width*2*(i+1)-1:width*2*i] = (a_temp[i] ? (({width*2{1'b0}} + b_temp ) << i) : 0) + partials[width*2*i-1:width*2*(i-1)];
    end 
endgenerate

assign y = partials[width*width*2-1:width*(width-1)*2];
assign Negative = a[width-1] ^ b[width-1] ? 1 : 0;

endmodule
