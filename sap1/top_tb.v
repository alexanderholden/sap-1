module top_tb;

    reg clk;
    reg clr;

    top DUT(
        .clk(clk),
        .clr(clr)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_tb);
    end

    // clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        clr = 0;
        #10;
        clr = 1;
    end

    initial begin
        $monitor(
            "t=%0t A=%b B=%b SU=%b ALU=%b ACC=%b OUT=%b",
            $time,
            DUT.add_sub_input,
            DUT.b_add_sum_in,
            DUT.Su,
            DUT.ADD_SUB_bus_out,
            DUT.acc_bus_out,
            DUT.out_reg_bus_out
        );
    end

    initial begin
        #1000;
        $finish;
    end

endmodule