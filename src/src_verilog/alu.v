module add_sub(
    input  wire [7:0] A,             // accumulator input
    input  wire [7:0] B,             // B register input
    input  wire       SU,            // 0 = add, 1 = sub
    input  wire       EU,            // enable output to bus
    output wire [7:0] ADD_SUB_bus_out
);

    reg [7:0] result;

    // Combinational add/subtract
    always @(*) begin
        if (SU == 1'b0)
            result = A + B;
        else
            result = A - B;
    end

    // Tri-state bus output
    assign ADD_SUB_bus_out = (EU) ? result : 8'bz;

endmodule