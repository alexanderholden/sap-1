module mux(
    input wire pc_bus_out[7:0],
    input wire acc_bus_out[7:0],
    input wire ADD_SUB_bus_out[7:0],
    input wire ram_bus_out[7:0],
    input wire ir_addr_out[7:0],

    input wire EA,
    input wire EU,
    input wire EI,
    input wire EP,
    input wire CE,

    output reg [7:0] bus
)

always @(*) begin
    case(1'b1)
        EP: bus = pc_bus_out;
        CE: bus = ram_bus_out;
        EI: bus = ir_addr_out;
        EA: bus = acc_bus_out;
        EU: bus = ADD_SUB_bus_out;

        default: bus = 8'b00000000;
    endcase
end

endmodule