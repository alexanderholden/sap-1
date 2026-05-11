module top(
    input wire clk,
    input wire clr
);

    wire Cp;
    wire Ep;
    wire Lm;
    wire CE;
    wire Li;
    wire Ei;
    wire La;
    wire Ea;
    wire Su;
    wire Eu;
    wire Lb;
    wire Lo;
    wire HLT;

    wire [7:0] bus;

    wire [7:0] acc_bus_out;
    wire [7:0] add_sub_input;
    wire [7:0] ADD_SUB_bus_out;

    wire [3:0] ir_addr_out;
    wire [3:0] ir_opcode_out;

    wire [3:0] mar_addr_bus_out;

    wire [7:0] out_reg_bus_out;

    wire [7:0] pc_bus_out;

    wire [7:0] ram_bus_out;
    wire [7:0] b_add_sum_in;

    controller CTRL(
        .clk(clk),
        .clr(clr),
        .inst_in(ir_opcode_out),
        .Cp(Cp),
        .Ep(Ep),
        .Lm(Lm),
        .CE(CE),
        .Li(Li),
        .Ei(Ei),
        .La(La),
        .Ea(Ea),
        .Su(Su),
        .Eu(Eu),
        .Lb(Lb),
        .Lo(Lo),
        .HLT(HLT)
        
    );

    mux BUSMUX(
        .pc_bus_out(pc_bus_out),
        .acc_bus_out(acc_bus_out),
        .ADD_SUB_bus_out(ADD_SUB_bus_out),
        .ram_bus_out(ram_bus_out),
        .ir_addr_out({4'b0000, ir_addr_out}),

        .EA(Ea),
        .EU(Eu),
        .EI(Ei),
        .EP(Ep),
        .CE(CE),

        .bus(bus)
    );

    accumulator acc(
        .LA(La),
        .CLK(clk),
        .EA(Ea),

        .acc_bus_in(bus),

        .acc_bus_out(acc_bus_out),

        .add_sub_input(add_sub_input)
    );


    add_sub ALU(
        .A(add_sub_input),
        .B(b_add_sum_in),

        .SU(Su),
        .EU(Eu),

        .ADD_SUB_bus_out(ADD_SUB_bus_out)
    );


    instruction_register IR(
        .LI(Li),
        .CLK(clk),
        .CLR(clr),
        .EI(Ei),

        .ir_bus_in(bus),

        .ir_addr_out(ir_addr_out),
        .ir_opcode_out(ir_opcode_out)
    );

    mar MAR(
        .LM(Lm),
        .CLK(clk),

        .bus_in(bus[3:0]),

        .mar_addr_bus_out(mar_addr_bus_out)
    );


    outregister OUTREG(
        .LO(Lo),
        .CLK(clk),

        .out_bus_in(bus),

        .out_reg_bus_out(out_reg_bus_out)
    );

    programcounter PC(
        .C_P(Cp),
        .nCLK(clk),
        .nCLR(clr),

        .pc_bus_out(pc_bus_out)
    );
    

    mem RAM(
        .mar_addr(mar_addr_bus_out),
        .CE(CE),

        .ram_bus_out(ram_bus_out)
    );

    b_register BREG(
        .LB(Lb),
        .CLK(clk),

        .b_bus_in(bus),

        .b_add_sum_in(b_add_sum_in)
    );
endmodule