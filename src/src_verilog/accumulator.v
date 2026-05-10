module accumulator( // WORKING
    input  wire       LA,          // active high load into accumulator
    input  wire       CLK,         // active high clock
    input  wire       EA,          // active high enable output to bus
    input  wire [7:0] acc_bus_in,  // input bus
    output wire [7:0] acc_bus_out, // output bus
    output wire [7:0] add_sub_input // output for ALU
);

    reg [7:0] accumulator_reg = 8'b0;

    // Load process
    always @(posedge CLK) begin
        if (LA)
            accumulator_reg <= acc_bus_in;
    end

    // Output onto bus (tri-state behavior)
    assign acc_bus_out = accumulator_reg;

    // Always drive add/sub input
    assign add_sub_input = accumulator_reg;

endmodule