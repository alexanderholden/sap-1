module outregister(
    input  wire       LO,              // load enable
    input  wire       CLK,             // clock
    input  wire [7:0] out_bus_in,      // input bus
    output wire [7:0] out_reg_bus_out  // output bus
);

    reg [7:0] out_reg = 8'b0;

    // Load process
    always @(posedge CLK) begin
        if (LO)
            out_reg <= out_bus_in;
    end

    // Output
    assign out_reg_bus_out = out_reg;

endmodule