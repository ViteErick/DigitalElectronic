//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Compania: ITESO
// Estudiantes: Cassandra Yazmin Osobampo Mendoza, Erick Eduardo Vite Lopez.
// Descripcion del modulo: Este modulo describe el disenio de una ALU parametrizada la cual cuenta con las siguientes funciones:
// Suma, Resta, Multiplicacion, Negativo, operaciones logicas: AND, OR, NOT, XOR, Corrimiento de bits izquierda o derecha.
// Fecha: 19 de septiembre del 2022
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ALU_Display
    #(parameter LENGTH_v = 5)
    (
	 //Entradas
    input clock,reset,enable,control,
    input signed [LENGTH_v-1:0]A,B,
	 //Salidas
    output carry,overflow,negative,zero,
    output seg_a_disp0, seg_b_disp0, seg_c_disp0, seg_d_disp0, seg_e_disp0, seg_f_disp0, seg_g_disp0,
    output seg_a_disp1, seg_b_disp1, seg_c_disp1, seg_d_disp1, seg_e_disp1, seg_f_disp1, seg_g_disp1,
    output seg_a_disp2, seg_b_disp2, seg_c_disp2, seg_d_disp2, seg_e_disp2, seg_f_disp2, seg_g_disp2
    );

	 //Variables para hacer el registro
    wire [LENGTH_v-1:0]A_top;
    wire [LENGTH_v-1:0]B_top;
    wire [LENGTH_v*2-1:0]result_top;
    wire [LENGTH_v*2-1:0]result_top_register;

	 wire [3:0] control_top;
	 wire [3:0] unos;
    wire [3:0] dieces;
    wire [3:0] cientos;
	 wire reset_temp = ~reset;
	 wire enable_temp = ~enable;
	 wire control_temp = ~control;
  
//Modulo que nos ayudara para registrar el valor de A en A_top  
register #(.LENGTH_v(LENGTH_v)) register_A_TOP(
    .clock(clock),
    .reset(reset_temp),
    .enable(enable_temp),
    .D(A),
    .Q(A_top)
    );

//Modulo que nos ayudara para registrar el valor de B en B_top 
register #(.LENGTH_v(LENGTH_v)) register_B_TOP(
    .clock(clock),
    .reset(reset_temp),
    .enable(enable_temp),
    .D(B),
    .Q(B_top)
    );
	
//Modulo que nos ayudara para registrar el valor de A[3:0] en control_top 	
register_control register_Control_TOP(
    .clock(clock),
    .reset(reset_temp),
    .enable(control_temp),
    .D(A[3:0]),
    .Q(control_top)
    );

register_result register_result_TOP(
    .clock(clock),
    .reset(reset_temp),
    .enable(enable_temp),
    .D(result_top),
    .Q(result_top_register)
    );

//Enviamos todas nuestras entradas a la ALU para poder obtener un resultado al final
ALU #(.LENGTH_v(LENGTH_v)) ALU_TOP_module(
    //input
    .clock(clock),
    .reset(reset_temp),
    .enable(enable_temp),
    .A(A_top),//CHANGE IT
    .B(B_top),
    .control(control_top),
    //output
    .result(result_top),
    .carry(carry),
    .overflow(overflow),
    .negative(negative),
    .zero(zero)
);

//Enviamos el resultado al modulo BinaryToBCD
BinaryToBCD BinaryToBCD_TOP(
    .clk(clock),
    .binario(result_top_register),
    .unos(unos),
	 .dieces(dieces),
	 .cientos(cientos)
    );

//Pasamos nuestros resultados al modulo BinaryToHexadecimal para poder enviar la salida a los displays de 7 segmentos
BinaryToHexadecimal BinaryToHexadecimal_display0_TOP(
    .control(control_top),
	 .logic_w(result_top_register[3]),
	 .logic_x(result_top_register[2]),
	 .logic_y(result_top_register[1]),
	 .logic_z(result_top_register[0]),
	 .arithmetic_w(unos[3]),
	 .arithmetic_x(unos[2]),
	 .arithmetic_y(unos[1]),
	 .arithmetic_z(unos[0]),
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
    .control(control_top),
	 .logic_w(result_top_register[7]),
	 .logic_x(result_top_register[6]),
	 .logic_y(result_top_register[5]),
	 .logic_z(result_top_register[4]),
	 .arithmetic_w(dieces[3]),
	 .arithmetic_x(dieces[2]),
	 .arithmetic_y(dieces[1]),
	 .arithmetic_z(dieces[0]),
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
    .control(control_top),
	 .logic_w(1'b0),
	 .logic_x(1'b0),
	 .logic_y(1'b0),
	 .logic_z(1'b0),
	 .arithmetic_w(cientos[3]),
	 .arithmetic_x(cientos[2]),
	 .arithmetic_y(cientos[1]),
	 .arithmetic_z(cientos[0]),
    .seg_a(seg_a_disp2),
    .seg_b(seg_b_disp2),
    .seg_c(seg_c_disp2),
    .seg_d(seg_d_disp2),
    .seg_e(seg_e_disp2),
    .seg_f(seg_f_disp2),
    .seg_g(seg_g_disp2)
    );


endmodule