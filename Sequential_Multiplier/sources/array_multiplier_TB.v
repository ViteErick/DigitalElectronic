`timescale 1ns/1ps

module array_multiplier_TB();

parameter LENGTH = 4;

// reg clk;
reg [LENGTH:0]A,B;
wire [LENGTH:0]Y;

array_multiplier #(.width(LENGTH)) UUT(
    // .clk(clk),
    .a(A),
    .b(B),
    .y(Y)
    );

    // integer a_;
    // integer b_;

initial begin
    A = 8'b1;
    B = 8'b1;
    // clk = 1'b0;

    // for (a_ = 0; a_ < 9; a_=a_+1) 
    // begin
    //     for (b_ = 0; b_ < 9 ; b_=b_+1) 
    //     begin
    //         B = B + 1'b1;
    //         #10;
    //     end
    //     A = A + 1'b1;
    //     #10;
    // end
end

// always
//     begin
//         #2 clk = ~clk;
//     end    
    
always
    begin
        #10  A = A + 1'b1;
    end    

always
    begin
        #20  B = B + 1'b1;
    end    



endmodule