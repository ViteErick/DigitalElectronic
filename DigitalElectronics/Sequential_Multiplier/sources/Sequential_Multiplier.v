module Sequential_Multiplier #(parameter LENGTH = 5)(
    input start, clock, reset,
    input [LENGTH-1:0]multiplier, 
    input [LENGTH-1:0]multiplicand,
    // output ready,
    //Product will be displayed on seven segment displays.
    output seg_a_disp0, seg_b_disp0, seg_c_disp0, seg_d_disp0, seg_e_disp0, seg_f_disp0, seg_g_disp0,
    output seg_a_disp1, seg_b_disp1, seg_c_disp1, seg_d_disp1, seg_e_disp1, seg_f_disp1, seg_g_disp1,
    output seg_a_disp2, seg_b_disp2, seg_c_disp2, seg_d_disp2, seg_e_disp2, seg_f_disp2, seg_g_disp2,
	 output Computing, Ready, Negative, overflow
    );

    wire [LENGTH-1:0]multiplierRegister;
    wire [LENGTH-1:0]multiplicandRegister;

    //Result
    wire [LENGTH*2-1:0]productRegisterIn;
    wire [LENGTH*2-1:0]productRegisterOut;

    // BDC variables outputs
    wire [3:0] unos;
    wire [3:0] dieces;
    wire [3:0] cientos;

register #(.LENGTH(LENGTH)) registerMultiplier_TOP(
    .clock(clock),
    .reset(~reset),
    .enable(~start),
    .D(multiplier),
    .Q(multiplierRegister)
    );

register #(.LENGTH(LENGTH)) registerMultiplicand_TOP(
    .clock(clock),
    .reset(~reset),
    .enable(~start),
    .D(multiplicand),
    .Q(multiplicandRegister)
    );

//Mult_Comb #(.width(LENGTH)) Mult_Comb_TOP(
//    .a(multiplierRegister),
//    .b(multiplicandRegister),
//    .y(productRegisterIn),
//	 .Negative(Negative)
//    );

FSM_SecuentialMultiplier #(.LENGTH(LENGTH)) FSM(
	.clock(clock),
	.reset(~reset),
	.start(~start),
	.multiplicand(multiplicandRegister),
	.multiplier(multiplierRegister),
	.result(productRegisterIn),
	.Computing(Computing),
	.Ready(Ready),
	.Negative(Negative),
    .overflow(overflow)
	);
	
register #(.LENGTH(LENGTH*2)) registerResult_TOP(
    .clock(clock),
    .reset(~reset),
    .enable(Ready),
    .D(productRegisterIn),  //this should be provied by secuential multiplier (ready result) module
    .Q(productRegisterOut)
    );

BinaryToBCD BinaryToBCD_TOP(
    .clk(clock),
    .binario(productRegisterOut[7:0]),
    .unos(unos),
	.dieces(dieces),
	.cientos(cientos)
    );

BinaryToHexadecimal BinaryToHexadecimal_display0_TOP(
//    .control(4'b1111),
	.w(unos[3]),
	.x(unos[2]),
	.y(unos[1]),
	.z(unos[0]),
    .seg_a(seg_a_disp0),
    .seg_b(seg_b_disp0),
    .seg_c(seg_c_disp0),
    .seg_d(seg_d_disp0),
    .seg_e(seg_e_disp0),
    .seg_f(seg_f_disp0),
    .seg_g(seg_g_disp0)
    );

//Pasamos nuestros resultados al modulo BinaryToHexadecimal para poder enviar la salida a los displays de 7 segmentos
BinaryToHexadecimal BinaryToHexadecimal_display1_TOP(
//    .control(4'b1111),
	.w(dieces[3]),
	.x(dieces[2]),
	.y(dieces[1]),
	.z(dieces[0]),
    .seg_a(seg_a_disp1),
    .seg_b(seg_b_disp1),
    .seg_c(seg_c_disp1),
    .seg_d(seg_d_disp1),
    .seg_e(seg_e_disp1),
    .seg_f(seg_f_disp1),
    .seg_g(seg_g_disp1)
    );
	 
//Pasamos nuestros resultados al modulo BinaryToHexadecimal para poder enviar la salida a los displays de 7 segmentos
BinaryToHexadecimal BinaryToHexadecimal_display2_TOP(
//    .control(4'b1111),
	.w(cientos[3]),
	.x(cientos[2]),
	.y(cientos[1]),
	.z(cientos[0]),
    .seg_a(seg_a_disp2),
    .seg_b(seg_b_disp2),
    .seg_c(seg_c_disp2),
    .seg_d(seg_d_disp2),
    .seg_e(seg_e_disp2),
    .seg_f(seg_f_disp2),
    .seg_g(seg_g_disp2)
    );
	 
endmodule