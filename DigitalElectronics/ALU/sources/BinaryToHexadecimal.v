module BinaryToHexadecimal (
//4 bits de entrada
input [3:0] control,
//Entradas de las cuales se obtiene su valor del modulo BinaryToBCD o directamente desde result.
input logic_w,logic_x,logic_y,logic_z,arithmetic_w,arithmetic_x,arithmetic_y,arithmetic_z,
//Salidas a los segmentos
output seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g);

reg w,x,y,z;

//En cualquier cambio
always@ *
begin
//Si es una operacion aritmetica, utilizamos la salida del modulo BinaryToBCD (0 a 9)
if (4 > control)
	begin
	w = arithmetic_w;
	x = arithmetic_x;
	y = arithmetic_y;
	z = arithmetic_z;
	end
//Si es una operacion logica, se utiliza la salida pura de la ALU para que el resultado salga en hexadecimal (del 0 a F).
else
	begin
	w = logic_w;
	x = logic_x;
	y = logic_y;
	z = logic_z;
	end
end

//Logica combinacional para la salida a cada segmento
assign seg_a = ~w&~x&~y&z | ~w&x&~y&~z | w&x&~y&z |w&~x&y&z;
assign seg_b = ~w&x&~y&z | x&y&~z | w&x&~z | w&y&z;
assign seg_c = ~w&~x&y&~z | w&x&~z | w&x&y;
assign seg_d = ~x&~y&z | ~w&x&~y&~z | x&y&z | w&~x&y&~z;
assign seg_e = ~x&~y&z | ~w&z | ~w&x&~y;
assign seg_f = ~w&~x&z | ~w&~x&y | ~w&y&z | w&x&~y&z;
assign seg_g = ~w&~x&~y | ~w&x&y&z | w&x&~y&~z;

endmodule