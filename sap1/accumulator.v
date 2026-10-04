module accumulator(
    input  wire       LA,         
    input  wire       CLK,        
    input  wire       EA,         
    input  wire [7:0] acc_bus_in, 
    output wire [7:0] acc_bus_out, 
    output wire [7:0] add_sub_input 
);

    reg [7:0] accumulator_reg = 8'b0;

    always @(posedge CLK) begin
        if (LA)
            accumulator_reg <= acc_bus_in;
    end
    
    assign acc_bus_out = accumulator_reg;


    assign add_sub_input = accumulator_reg;

endmodule
