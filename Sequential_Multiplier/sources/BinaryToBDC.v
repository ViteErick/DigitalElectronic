module BinaryToBCD (
//Entradas
input clk,
input [7:0] binario,
//Salidas
output reg [3:0] unos = 0,
output reg [3:0] dieces = 0,
output reg [3:0] cientos = 0);

//Utilizado como contador para la secuencia
reg [3:0] i = 0;
//Registro utilizado para realizar el corrimiento y guardar el valor
reg [19:0] registro_corrimiento;
//Guardadermos los 4 bits que se tomaran como los 1s en BCD
reg [3:0] temp_unos = 0;
//Guardadermos los 4 bits que se tomaran como los 10es en BCD
reg [3:0] temp_dieces = 0;
//Guardadermos los 4 bits que se tomaran como los 100es en BCD
reg [3:0] temp_cientos = 0;
//Registro que nos servira para checar si la entrada valor ha cambiado
reg [7:0] temp_binario = 0;	

always@ (posedge clk)
begin
  // Si el contador se reinicio y el valor de la entrada binario ha cambiado
  if (i == 0 & (temp_binario != binario))
      begin
      //Inicializar el registro de corrimiento en 0
		registro_corrimiento = 20'd0;
		//Asignamos el valor de la variable binario a temp_binario, para que podamos saber despues si hemos tenido una nueva entrada
		temp_binario = binario;
		//Asignamos los 8 bits de la variable binario a los 8 bits menos significativos del registro_corrimiento
      registro_corrimiento[7:0] = binario;
		//Asignamos valores de los unos, dices y cientos a partir de la variable registro_corrimiento
		temp_unos = registro_corrimiento[11:8];
		temp_dieces = registro_corrimiento[15:12];
		temp_cientos = registro_corrimiento[19:16];
		//Aumentamos contador
		i=i+1;
		end
  if (i < 9 & i>0)
      begin
      //Checamos si las variables unos, dices y cientos son mayores o iguales a 5
		if (temp_unos>=5)
		  temp_unos = temp_unos+3;
		if (temp_dieces>=5)
		  temp_dieces = temp_dieces+3;
		if (temp_cientos>=5)
		  temp_cientos = temp_cientos+3;
		//Metemos estos nuevos valores en la variable registro_corrimiento
		registro_corrimiento[19:8] = {temp_cientos,temp_dieces,temp_unos};
		//Despues hacemos un shift left
		registro_corrimiento = registro_corrimiento<<1;
		//Y actualizamos los nuevos valores de los unos, dieces y cienes
		temp_unos = registro_corrimiento[11:8];
		temp_dieces = registro_corrimiento[15:12];
		temp_cientos = registro_corrimiento[19:16];
		//Actualizamos el contador
		i=i+1;
		end
  if (i == 9)
      begin
      //El contador llego al limite y lo reiniciamos
      i=0;
		//Por ultimo asignamos las salidas del BCD
		unos = temp_unos;
		dieces = temp_dieces;
		cientos = temp_cientos;
		end
end
endmodule