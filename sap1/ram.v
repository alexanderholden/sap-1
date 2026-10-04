module mem(
    input  wire [3:0] mar_addr,
    input  wire CE,
    output wire [7:0] ram_bus_out
);
    reg [7:0] ram [0:15];

    initial begin
        
        ram[0]  = 8'b00001001;
        ram[1]  = 8'b00011100; 
        ram[2]  = 8'b11101111; 
        ram[3]  = 8'b11111111; 
        ram[9]  = 8'b00000110; 
        ram[10] = 8'b00001000; 
        ram[11] = 8'b00000011;         
        ram[4] = 8'b0;
        ram[5] = 8'b0;
        ram[6] = 8'b0;
        ram[7] = 8'b0;
        ram[8] = 8'b0;
        ram[12] = 8'b00001000;
        ram[13] = 8'b0;
        ram[14] = 8'b0;
        ram[15] = 8'b0;
    end

    assign ram_bus_out = ram[mar_addr];

endmodule
