module register_control
    (
	 //Entradas
        input clock,reset,enable,
        input [3:0]D,
	//Salidas
        output reg [3:0]Q
    );

	 //Se activa solamente en un flanco de subida del reloj o del reset
always @(posedge clock, posedge reset ) 
    begin
	 //Si se resetea, el registro toma el valor de 0
        if (reset) 
            Q <= 0;
	//Si se activo y no hay reset
        else
		  //Si esta apretado el boton, en este caso utilizamos el de control, el registro de control_top toma el valor deseado
            if (enable)
                Q <= D;
			//Sino, se queda igual
            else
                Q <= Q;        
    end
endmodule