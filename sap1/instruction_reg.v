module instruction_register(
    input  wire        LI,          
    input  wire        CLK,        
    input  wire        CLR,        
    input  wire        EI,          
    input  wire [7:0]  ir_bus_in,   
    output wire [3:0]  ir_addr_out, 
    output wire [3:0]  ir_opcode_out 
);

    reg [7:0] ir_reg = 8'b0;

  
    always @(posedge CLK or negedge CLR) begin
        if (!CLR)
            ir_reg <= 8'b0;
        else if (LI)
            ir_reg <= ir_bus_in;
    end

    
    assign ir_opcode_out = ir_reg[7:4];
    assign ir_addr_out   = ir_reg[3:0];

endmodule
