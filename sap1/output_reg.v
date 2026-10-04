module outregister(
    input  wire       LO,          
    input  wire       CLK,          
    input  wire [7:0] out_bus_in,    
    output wire [7:0] out_reg_bus_out 
);

    reg [7:0] out_reg = 8'b0;

    
    always @(posedge CLK) begin
        if (LO)
            out_reg <= out_bus_in;
    end

    assign out_reg_bus_out = out_reg;

endmodule
