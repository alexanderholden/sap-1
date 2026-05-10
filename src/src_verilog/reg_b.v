module b_register(
    input  wire       LB,            // load enable
    input  wire       CLK,           // clock
    input  wire [7:0] b_bus_in,      // input bus
    output wire [7:0] b_add_sum_in   // output to add/sub module
);

    reg [7:0] b_reg = 8'b0;

    // Load process
    always @(posedge CLK) begin
        if (LB)
            b_reg <= b_bus_in;
    end

    // Output
    assign b_add_sum_in = b_reg;

endmodule