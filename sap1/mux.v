module mux(
    input  wire [7:0] pc_bus_out,
    input  wire [7:0] acc_bus_out,
    input  wire [7:0] ADD_SUB_bus_out,
    input  wire [7:0] ram_bus_out,
    input  wire [7:0] ir_addr_out, 

    input  wire EP,  
    input  wire CE,  
    input  wire EI,
    input  wire EA,  
    input  wire EU,  

    output reg [7:0] bus
);

    always @(*) begin
        
        if (EP)
            bus = pc_bus_out;
        else if (CE)
            bus = ram_bus_out;
        else if (EI)
            bus = ir_addr_out;
        else if (EA)
            bus = acc_bus_out;
        else if (EU)
            bus = ADD_SUB_bus_out;
        else
            bus = 8'b0;
    end

endmodule
