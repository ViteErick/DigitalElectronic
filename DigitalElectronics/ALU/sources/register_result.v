module register_result
    (
	 //Entradas
        input clock,reset,enable,
        input [8:0]D,
	 //Salidas
        output reg [8:0]Q
    );

//Se activa en el flanco positivo del clock o del reset
always @(posedge clock, posedge reset ) 
    begin
	 //En reset, resetear el valor de Q (puede ser las entradas B, A por ejemplo)
        if (reset) 
            Q <= {9'd0};
	 //Si se activo el always y fue por el clock
        else
		  //Si es enable, se pasa el valor al registro para poder ser utilizado en la ALU
            if (enable)
                Q <= D;
		 //Si no se apreto el boton de enable, el registro sigue teniendo el mismo valor de antes.
            else
                Q <= Q;
    end
endmodule