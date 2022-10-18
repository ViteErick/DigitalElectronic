`timescale 1ns/1ps

module ALU_TB();

parameter LENGTH_TB = 5;

reg clock_TB, reset_TB, enable_TB;
reg [LENGTH_TB-1:0] A_TB, B_TB;
reg [3:0]control_TB;

wire carry_TB, overflow_TB, negative_TB, zero_TB;
wire [LENGTH_TB*2-1:0]result_TB;

ALU #(.LENGTH_v(LENGTH_TB)) UUT(
    //Inputs
    .clock(clock_TB),
    .reset(reset_TB),
    .enable(enable_TB),
    .A(A_TB),
    .B(B_TB),
    .control(control_TB),
    //Outputs
    // .carry(carry_TB),
    .overflow(overflow_TB),
    .negative(negative_TB),
    .zero(zero_TB),
    .result(result_TB)
    );

    integer i;
    integer a_;
    integer b_;

initial 
    begin
        clock_TB = 1'b0;
        reset_TB = 1'b0;
        enable_TB = 1'b1;
        control_TB = 4'b0000;
        A_TB = 5'b00000;
        B_TB = 5'b00000;
        #50;

        for (i = 0; i < 10 ; i=i+1) 
        begin
            for (a_ = 0; a_ < 32 ; a_=a_+1) 
            begin
                for (b_ = 0; b_ < 32 ; b_=b_+1) 
                begin
                    B_TB = B_TB + 1'b1;
                    #10;
                end
                A_TB = A_TB + 1'b1;
                #10;
            end
            control_TB = control_TB + 4'b0001;
            #10;
        end

    end

endmodule