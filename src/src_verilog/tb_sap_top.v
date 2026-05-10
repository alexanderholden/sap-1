`timescale 1ns/1ps
`default_nettype none

module tb_sap_top;

    reg clk = 0;
    reg clr = 1;

    wire [7:0] out_bus;

    // Instantiate the CPU
    sap_top cpu(
        .clk(clk),
        .clr(clr),
        .out_bus(out_bus)
    );

    // ----------------------
    // Clock generation: 10 ns period
    // ----------------------
    always #5 clk = ~clk;

    // ----------------------
    // Preload memory values (if your mem module supports initialization)
    // ----------------------
    initial begin
        // release reset after 2 cycles
        #2 clr = 0;
        #10 clr = 1;
    end

    // ----------------------
    // Run simulation
    // ----------------------
    initial begin
        $dumpfile("sap_top.vcd");
        $dumpvars(0, tb_sap_top);

        $display("Time\tout_bus");

        // Run enough cycles to execute instructions
        repeat (200) begin
            #10; // wait one clock
            $display("%0t\t%b", $time, out_bus);
        end

        $display("Simulation finished.");
        $finish;
    end

endmodule