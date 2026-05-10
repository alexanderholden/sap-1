`timescale 1ns/1ps
`default_nettype none

module controller_unit(
    input clk,
    input rst,
    input [7:0] inputInstruction,
    output Cp,
    output Ep,
    output Lm,
    output CE,
    output Li,
    output Ei,
    output La,
    output Ea,
    output Lb,
    output Su,
    output Eu,
    output Lo,
    output HLT
);

    parameter IDLE = 8'b00000001;
    parameter T1   = 8'b00000010;
    parameter T2   = 8'b00000100;
    parameter T3   = 8'b00001000;
    parameter T4   = 8'b00010000;
    parameter T5   = 8'b00100000;
    parameter T6   = 8'b01000000;
    parameter T7   = 8'b10000000;

    reg [7:0] present, next;

    // Present state logic
    always @(negedge clk) begin
        if (rst)
            present <= IDLE;
        else
            present <= next;
    end

    // Next state logic
    always @(present, inputInstruction) begin
        next = IDLE; // default
        case (present)
            IDLE: next = T1;
            T1:   next = T2;
            T2:   next = T3;
            T3:   next = T4;
            T4:   next = T5;
            T5:   next = T6;
            T6:   next = T7;
            T7:   next = T1;
        endcase
    end

    // ----------------------
    // Output assignments
    // ----------------------
    assign Cp  = (present == T2); // increment PC
    assign Ep  = (present == T2); // enable PC onto bus
    assign Lm  = (present == T1 || (present == T4 && (inputInstruction[7:4]==4'b0000 || inputInstruction[7:4]==4'b0001 || inputInstruction[7:4]==4'b0010)));
    assign CE  = (present == T2 || (present == T5 && (inputInstruction[7:4]==4'b0000 || inputInstruction[7:4]==4'b0001 || inputInstruction[7:4]==4'b0010)));
    assign Li  = (present == T3);
    assign Ei  = (present == T4 && (inputInstruction[7:4]==4'b0000 || inputInstruction[7:4]==4'b0001 || inputInstruction[7:4]==4'b0010));
    assign La  = ((present == T6 && inputInstruction[7:4]==4'b0000) || (present == T7 && (inputInstruction[7:4]==4'b0001 || inputInstruction[7:4]==4'b0010)));
    assign Ea  = (present == T6 && inputInstruction[7:4]==4'b0000);
    assign Lb  = (present == T6 && (inputInstruction[7:4]==4'b0001 || inputInstruction[7:4]==4'b0010));
    assign Su  = ((present == T6 || present == T7) && inputInstruction[7:4]==4'b0010);
    assign Eu  = (present == T7 && (inputInstruction[7:4]==4'b0001 || inputInstruction[7:4]==4'b0010));
    assign Lo  = (present == T4 && inputInstruction[7:4]==4'b1110);
    assign HLT = (present == T4 && inputInstruction[7:4]==4'b1111);

endmodule