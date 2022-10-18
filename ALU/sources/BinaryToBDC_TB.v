`timescale 1ns/1ps

module BinaryToBCD_TB();
    
reg clock_TB;
reg [7:0]binario_TB;

wire [3:0]unos_TB;
wire [3:0]dieces_TB;
wire [3:0]cientos_TB;

BinaryToBCD UUT(
            .clk(clock_TB), 
            .binario(binario_TB),
            .unos(unos_TB),
            .dieces(dieces_TB),
            .cientos(cientos_TB)
            );

    integer i;

initial 
    begin
        clock_TB = 1'b0;
        binario_TB = 8'b00000000;
        #50;
        for (i = 0; i < 256 ; i=i+1)  
        begin
            binario_TB = binario_TB + 1'b1;
            #10;
        end
    end

 endmodule