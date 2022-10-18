module BinaryToHexadecimal (
//4 bits de entrada
//input [3:0] control,
//Entradas de las cuales se obtiene su valor del modulo BinaryToBCD o directamente desde result.
input w,x,y,z,
//Salidas a los segmentos
output seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g);

//Logica combinacional para la salida a cada segmento
assign seg_a = ~w&~x&~y&z | ~w&x&~y&~z | w&x&~y&z |w&~x&y&z;
assign seg_b = ~w&x&~y&z | x&y&~z | w&x&~z | w&y&z;
assign seg_c = ~w&~x&y&~z | w&x&~z | w&x&y;
assign seg_d = ~x&~y&z | ~w&x&~y&~z | x&y&z | w&~x&y&~z;
assign seg_e = ~x&~y&z | ~w&z | ~w&x&~y;
assign seg_f = ~w&~x&z | ~w&~x&y | ~w&y&z | w&x&~y&z;
assign seg_g = ~w&~x&~y | ~w&x&y&z | w&x&~y&~z;

endmodule