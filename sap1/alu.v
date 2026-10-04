module add_sub(
    input  wire [7:0] A,            
    input  wire [7:0] B,            
    input  wire       SU,           
    input  wire       EU,           
    output wire [7:0] ADD_SUB_bus_out
);

    reg [7:0] result;

    always @(*) begin
        if (SU == 1'b0)
            result = A + B;
        else
            result = A - B;
    end

    assign ADD_SUB_bus_out = result;

endmodule
