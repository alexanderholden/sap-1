module b_register(
    input  wire       LB,          
    input  wire       CLK,      
    input  wire [7:0] b_bus_in,    
    output wire [7:0] b_add_sum_in   
);

    reg [7:0] b_reg = 8'b0;

    
    always @(posedge CLK) begin
        if (LB)
            b_reg <= b_bus_in;
    end

    assign b_add_sum_in = b_reg;

endmodule
