module ALU 
    #(parameter LENGTH_v = 5)
    (
	 //Entradas
        input signed [LENGTH_v-1:0]A,B,
        input clock,reset,enable,
        input [3:0]control,
	 //Salidas
        output reg [LENGTH_v*2-1:0]result,
        output reg carry,overflow,negative,zero
    );
//Parametros que se utilizaran para saber que operaciones realizara la ALU
    parameter ADDITION_ARITHMETIC      = 4'b0000;
    parameter SUBTRACTION_ARITHMETIC   = 4'b0001;
    parameter NEGATIVE_ARITHMETIC      = 4'b0010;
    parameter MULTIPLICATION_ARITHMETIC = 4'b0011;
    parameter AND_LOGIC                = 4'b0100;
    parameter OR_LOGIC                 = 4'b0101;
    parameter NEGATIVE_LOGIC           = 4'b0110;
    parameter XOR_LOGIC                = 4'b0111;
    parameter SHIFT_LEFT               = 4'b1000;
    parameter SHIFT_RIGHT              = 4'b1001;
	 
//Temporales para trabajar con el valor de resultado
   reg [LENGTH_v*2-1:0] result_temp;
	reg [12:0] result_temp2;
    reg signed [4:0]negative_val = 5'b11111;


//Se activa solamente si hay un flanco de subida del clock o del reset
    always @(posedge clock, posedge reset)
        begin
//Le da mayor importancia al reset, y si es apretado se resetea el valor del resultado devolviendolo a 0 e igualmente el de las banderas.
            if (reset) 
                begin
                    result <= {LENGTH_v*2-1{1'b0}};
						//   carry = 1'b0;
						  zero = 1'b1;
						  overflow = 1'b0;
						  negative = 1'b1;
                end
//Si no hay un reset hace lo siguiente
            else
//Si se aprieta el boton de enable comienza a hacer las operaciones elegidas
                if (enable) 
                begin 
					 //Reseteamos el bit de overflow cuando se requiere volver a hacer otra operacion
                    overflow <= 1'b0;
					//Comienza el case para hacer funcionar la ALU con todas sus operaciones.
                    case (control)
                        ADDITION_ARITHMETIC : 
                            begin
                                result_temp <= A + B;
                            end
                        
                        SUBTRACTION_ARITHMETIC :
                            begin
                                result_temp <= A - B;
                            end

                        NEGATIVE_ARITHMETIC:
                            begin
                                result_temp <= B * negative_val;
                            end

                        MULTIPLICATION_ARITHMETIC:
                            begin
                                result_temp <= A * B;
										  if (result_temp[LENGTH_v*2-1] != result_temp[LENGTH_v*2-2])
                                    overflow <= 1'b1;
                                else
                                    overflow <= 1'b0;
                            end

                        AND_LOGIC:
                            begin
                                result_temp <=  {3'b000,A & B};
                            end

                        OR_LOGIC:
                            begin
                                result_temp <= {3'b000,A | B};
                            end

                        NEGATIVE_LOGIC:
                            begin
                                result_temp <= {3'b000,~A};
                            end

                        XOR_LOGIC:
                            begin
                                result_temp <= {3'b000,A ^ B};
                            end

                        SHIFT_LEFT:
                            begin
                                result_temp2 <= A << B[3:0];
										  result_temp <= result_temp2[LENGTH_v*2-1:0];
										  if (result_temp2 > 255)
                                    overflow <= 1'b1;
                                else
                                    overflow <= 1'b0;
                            end

                        SHIFT_RIGHT:
                            begin
                                result_temp <= A >> B[3:0];
                            end

                    endcase

	//Si es una operacion aritmetica, el resultado tiene que ser checado para saber si es negativo o positivo y se enciende la bandera de negativo.					  
						  if (result_temp[9] & control < 4)
						  begin
						      result <= ~result_temp + 1'b1;
								negative <= 1'b0;
						  end
	//Si es positivo, el resultado se envia tal y como esta y la bandera de negativo es 0.					  
						  else
						  begin
						      result <= result_temp;
								negative <= 1'b1;
						  end
//Si el resultado es 0, se enciende la bandera de zero.						  
						  if (result == 0)
						      zero <= 1'b1;
								
						  else
						      zero <= 1'b0;
								
                end// end if enable
		end //Always end





endmodule