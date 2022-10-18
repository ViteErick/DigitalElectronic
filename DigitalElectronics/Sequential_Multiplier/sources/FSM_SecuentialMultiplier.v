module FSM_SecuentialMultiplier #(parameter LENGTH = 5)(
    input clock, reset, start,
    input [LENGTH-1:0]multiplicand,multiplier,
    //input readyResult,
    output reg [LENGTH*2-1:0] result,
	 output reg Computing, Ready, Negative, overflow
);

localparam IDLE = 2'b00;
localparam COMPUTING = 2'b01;
localparam READY = 2'b10;

reg [1:0]FSM_state;
reg readyResult_temp;
reg [LENGTH*2-1:0]Result_temp;
reg [LENGTH-1:0]multiplicand_temp,multiplier_temp;
reg [LENGTH*LENGTH*2-1:0] partials;
reg Negative_temp;
reg overflow_temp;
integer i;

always @(posedge clock, posedge reset) 
begin
    if (reset)
		begin
        FSM_state <= IDLE;
//		  result <= {LENGTH*2-1{1'b0}};
		end
    else 
        case (FSM_state)
            IDLE:
                    if (start) 
                        FSM_state <= COMPUTING;
            COMPUTING:
                    if (readyResult_temp)
                        FSM_state <= READY;
            READY:
                    if (start)
                        FSM_state <= COMPUTING;
                    else
                        FSM_state <= IDLE;
            default: FSM_state <= IDLE;
        endcase
end


always @(FSM_state) 
begin
    case (FSM_state)
        IDLE:
            begin
              result <= {LENGTH*2-1{1'b0}};
				  Computing <= 1'b0;
				  Ready <= 1'b0;
                  overflow <= 1'b0;
            end

        COMPUTING:
				begin
              result <= {LENGTH*2-1{1'b0}};
                //Mult_Comb_Reg #(.LENGTH(LENGTH)) Mult(.a(multiplicand), .b(multiplier), .y(Result_temp), .start(start), .reset(reset), .clock(clock), .Negative(Negative), .finish(readyResult_temp));
					 Computing <= 1'b1;
					 Ready <= 1'b0;
                     overflow <= overflow_temp;
            end

        READY:
            begin
                result <= Result_temp;
					 Computing <= 1'b0;
					 Ready <= 1'b1;
                     overflow <= overflow_temp;
            end

        default:
            begin
              result <= {LENGTH*2-1{1'b0}};
				  Computing <= 1'b0;
				  Ready <= 1'b0;
                  overflow <= 1'b0;
            end
    endcase
end

always@(posedge clock)
begin
	if (FSM_state == COMPUTING)
	  begin
		multiplicand_temp <= multiplicand[LENGTH-1] ? ~multiplicand + 1'b1 : multiplicand;
		multiplier_temp <= multiplier[LENGTH-1] ? ~multiplier + 1'b1 : multiplier;
		partials[LENGTH*2-1:0] <= multiplicand_temp[0] ? multiplier_temp : {LENGTH{1'b0}};
		if (i < LENGTH)
			begin
				partials[LENGTH*2*(i+1)-1-:LENGTH*2] <= (multiplicand_temp[i] ? (({LENGTH*2{1'b0}} + multiplier_temp ) << i) : 0) + partials[LENGTH*2*i-1-:LENGTH*2];
				i = i+1;
				readyResult_temp = 1'b0;
			end
		else
			begin
				Result_temp <= partials[LENGTH*LENGTH*2-1:LENGTH*(LENGTH-1)*2];
				Negative <= multiplicand[LENGTH-1] ^ multiplier[LENGTH-1] ? 0 : 1;
				i = 1;
				readyResult_temp = 1'b1;
                if (Result_temp[LENGTH*2-1] != Result_temp[LENGTH*2-2])
                    overflow_temp <= 1'b1;
                else
                    overflow_temp <= 1'b0;
			end
		//Mult_Comb_Reg #(.LENGTH(LENGTH)) Mult(.a(multiplicand), .b(multiplier), .y(Result_temp), .start(start), .reset(reset), .clock(clock), .Negative(Negative), .finish(readyResult_temp));
		end
end

endmodule