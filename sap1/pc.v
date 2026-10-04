module programcounter(
    input  wire        C_P,      
    input  wire        nCLK,     
    input  wire        nCLR,      
    input  wire        E_P,      
    input  wire [3:0]  pc_bus_in, 
    output wire [7:0]  pc_bus_out 
);

    reg [3:0] programcounter_reg = 4'b0;

    
    always @(negedge nCLK or negedge nCLR) begin
        if (!nCLR)
            programcounter_reg <= 4'b0;
        else if (C_P)
            programcounter_reg <= programcounter_reg + 1;
    end

   
    assign pc_bus_out = {4'b0000, programcounter_reg};

endmodule
