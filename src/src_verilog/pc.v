module programcounter(
    input  wire        C_P,        // increment enable
    input  wire        nCLK,       // active-low clock
    input  wire        nCLR,       // active-low clear
    input  wire        E_P,        // enable output to bus
    input  wire [3:0]  pc_bus_in,  // input bus (optional for top-level)
    output wire [7:0]  pc_bus_out  // 8-bit bus output
);

    reg [3:0] programcounter_reg = 4'b0;

    // Counter process
    always @(negedge nCLK or negedge nCLR) begin
        if (!nCLR)
            programcounter_reg <= 4'b0;
        else if (C_P)
            programcounter_reg <= programcounter_reg + 1;
    end

    // Output with zero-extended upper bits
    assign pc_bus_out = (E_P) ? {4'b0000, programcounter_reg} : 8'bz;

endmodule