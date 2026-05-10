`default_nettype none
`timescale 1ns/1ps

module sap_top(
    input  wire       clk,
    input  wire       clr,
    output wire [7:0] out_bus
);

    // ----------------------
    // Internal bus and pipeline
    // ----------------------
    reg [7:0] bus;
    reg [7:0] bus_reg;

    // ----------------------
    // Control signals
    // ----------------------
    wire [11:0] ctrl_out;
    wire Cp, Ep, Lm, CE, Li, Ei, La, Ea, Su, Eu, Lb, Lo, HLT;

    controller ctrl(
        .clk(clk),
        .rst(clr),
        .opcode(ir_opcode_out),
        .out(ctrl_out)
    );

    // Unpack controller outputs
    assign {HLT, Cp, Ep, Lm, CE, Li, Ei, La, Ea, Su, Eu, Lb, Lo} = ctrl_out;

    // ----------------------
    // Program Counter
    // ----------------------
    wire [7:0] pc_bus_out;
    programcounter pc(
        .C_P(Cp),
        .nCLK(clk),
        .nCLR(clr),
        .E_P(Ep),
        .pc_bus_in(bus[3:0]),
        .pc_bus_out(pc_bus_out)
    );

    // ----------------------
    // MAR
    // ----------------------
    wire [3:0] mar_addr_bus_out;
    mar mar_inst(
        .LM(Lm),
        .CLK(clk),
        .bus_in(bus[3:0]),
        .mar_addr_bus_out(mar_addr_bus_out)
    );

    // ----------------------
    // Memory
    // ----------------------
    wire [7:0] ram_bus_out;
    mem ram_inst(
        .mar_addr(mar_addr_bus_out),
        .CE(CE),
        .ram_bus_out(ram_bus_out)
    );

    // ----------------------
    // Instruction Register
    // ----------------------
    wire [3:0] ir_addr_out;
    wire [3:0] ir_opcode_out;
    instruction_register ir(
        .LI(Li),
        .CLK(clk),
        .CLR(clr),
        .EI(Ei),
        .ir_bus_in(ram_bus_out),
        .ir_addr_out(ir_addr_out),
        .ir_opcode_out(ir_opcode_out)
    );

    // ----------------------
    // Accumulator
    // ----------------------
    wire [7:0] acc_bus_out;
    accumulator acc(
        .LA(La),
        .CLK(clk),
        .EA(Ea),
        .acc_bus_in(bus),
        .acc_bus_out(acc_bus_out),
        .add_sub_input(b_add_sum_in)
    );

    // ----------------------
    // B Register
    // ----------------------
    wire [7:0] b_add_sum_in;
    b_register breg(
        .LB(Lb),
        .CLK(clk),
        .b_bus_in(bus),
        .b_add_sum_in(b_add_sum_in)
    );

    // ----------------------
    // ALU (Add/Sub unit)
    // ----------------------
    wire [7:0] add_sub_bus_out;
    add_sub alu(
        .A(acc_bus_out),
        .B(b_add_sum_in),
        .SU(Su),
        .EU(Eu),
        .ADD_SUB_bus_out(add_sub_bus_out)
    );

    // ----------------------
    // OUT Register
    // ----------------------
    wire [7:0] out_reg_bus_out;
    outregister outreg(
        .LO(Lo),
        .CLK(clk),
        .out_bus_in(bus),
        .out_reg_bus_out(out_reg_bus_out)
    );

    // ----------------------
    // Bus logic (priority mux)
    // ----------------------
    always @(*) begin
        if (Ei)
            bus = {ir_opcode_out, ir_addr_out}; // 8-bit IR output
        else if (Eu)
            bus = add_sub_bus_out;
        else if (Ea)
            bus = acc_bus_out;
        else if (CE)
            bus = ram_bus_out;
        else if (Ep)
            bus = pc_bus_out;
        else
            bus = 8'b0;
    end

    // Bus pipeline
    always @(posedge clk) begin
        if (clr)
            bus_reg <= 8'b0;
        else
            bus_reg <= bus;
    end

    // ----------------------
    // Connect OUT register to top-level
    // ----------------------
    assign out_bus = out_reg_bus_out;

endmodule