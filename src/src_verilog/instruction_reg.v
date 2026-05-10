module instruction_register(
    input  wire        LI,           // load instruction
    input  wire        CLK,          // clock
    input  wire        CLR,          // active low clear
    input  wire        EI,           // enable output
    input  wire [7:0]  ir_bus_in,    // input bus
    output wire [3:0]  ir_addr_out,  // address output
    output wire [3:0]  ir_opcode_out // opcode output
);

    reg [7:0] ir_reg = 8'b0;

    // Load process with asynchronous clear
    always @(posedge CLK or negedge CLR) begin
        if (!CLR)
            ir_reg <= 8'b0;
        else if (LI)
            ir_reg <= ir_bus_in;
    end

    // Outputs
    assign ir_opcode_out = ir_reg[7:4];
    assign ir_addr_out   = (EI) ? ir_reg[3:0] : 4'bz;

endmodule