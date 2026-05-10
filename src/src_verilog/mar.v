module mar(
    input  wire       LM,               // active high load from bus
    input  wire       CLK,              // clock
    input  wire [3:0] bus_in,           // 4-bit input bus
    output wire [3:0] mar_addr_bus_out  // 4-bit address output
);

    reg [3:0] mar_reg = 4'b0;

    // Load process
    always @(posedge CLK) begin
        if (LM)
            mar_reg <= bus_in;
    end

    // Output
    assign mar_addr_bus_out = mar_reg;

endmodule