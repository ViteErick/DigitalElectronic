module demux_1_2 (
    input enable, selectorDemux,
    input [4:0]inputSelector,
    output [4:0] Y0,Y1
);

    assign Y0 = (enable & inputSelector &(~selectorDemux));
    assign Y1 = (enable & inputSelector & selectorDemux);
    
endmodule