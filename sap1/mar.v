module mar(
    input  wire       LM,             
    input  wire       CLK,             
    input  wire [3:0] bus_in,          
    output wire [3:0] mar_addr_bus_out  
);

    reg [3:0] mar_reg = 4'b0;

    always @(posedge CLK) begin
        if (LM)
            mar_reg <= bus_in;
    end
    assign mar_addr_bus_out = mar_reg;

endmodule
