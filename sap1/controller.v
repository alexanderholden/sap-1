module controller(
    input  wire       clk,
    input  wire       clr,
    input  wire [3:0] inst_in,

    output reg Cp,
    output reg Ep,
    output reg Lm,
    output reg CE,
    output reg Li,
    output reg Ei,
    output reg La,
    output reg Ea,
    output reg Su,
    output reg Eu,
    output reg Lb,
    output reg Lo,
    output reg HLT
  );

  // State encoding
  parameter IDLE = 3'd0,
            T0   = 3'd1,
            T1   = 3'd2,
            T2   = 3'd3,
            T3   = 3'd4,
            T4   = 3'd5,
            T5   = 3'd6;

  reg [2:0] pr_state = T0;
  reg [2:0] nx_state = T0;
  reg [11:0] control_signal;

  // State register
  always @(posedge clk or negedge clr)
  begin
    if (!clr)
      pr_state <= IDLE;
    else
      pr_state <= nx_state;
  end

  // Next state + control logic
  always @(*)
  begin

    // defaults
    control_signal = 12'b000000000000;
    HLT = 1'b1;
    nx_state = pr_state;

    case (pr_state)

      IDLE:
      begin
        nx_state = T0;
      end

      // MAR <- PC
      T0:
      begin
        control_signal = 12'b011000000000; // EP + LM
        nx_state = T1;
      end

      // PC++
      T1:
      begin
        control_signal = 12'b100000000000; // CP
        nx_state = T2;
      end

      // IR <- RAM
      T2:
      begin
        control_signal = 12'b000110000000; // CE + LI
        nx_state = T3;
      end

      T3:
      begin

        // LDA / ADD / SUB
        if (
          inst_in == 4'b0000 ||
          inst_in == 4'b0001 ||
          inst_in == 4'b0010
        )
        begin
          control_signal = 12'b001001000000; // EI + LM
          nx_state = T4;
        end

        // OUT
        else if (inst_in == 4'b1110)
        begin
          control_signal = 12'b000000010001; // EA + LO
          nx_state = T0;
        end

        // HLT
        else if (inst_in == 4'b1111)
        begin
          HLT = 1'b0;
          control_signal = 12'b000000000000;
          nx_state = T3;
        end

        else
        begin
          control_signal = 12'b000000000000;
          nx_state = T0;
        end
      end

      T4:
      begin

        // LDA
        if (inst_in == 4'b0000)
        begin
          control_signal = 12'b000100100000; // CE + LA
          nx_state = T0;
        end

        // ADD
        else if (inst_in == 4'b0001)
        begin
          control_signal = 12'b000100000010; // CE + LB
          nx_state = T5;
        end

        // SUB
        else if (inst_in == 4'b0010)
        begin
          control_signal = 12'b000100000010; // CE + LB
          nx_state = T5;
        end

        else
        begin
          control_signal = 12'b000000000000;
          nx_state = T0;
        end
      end

      T5:
      begin

        // ADD
        if (inst_in == 4'b0001)
        begin
          control_signal = 12'b000000100100; // EU + LA
        end

        // SUB
        else if (inst_in == 4'b0010)
        begin
          control_signal = 12'b000000101100; // SU + EU + LA
        end

        else
        begin
          control_signal = 12'b000000000000;
        end

        nx_state = T0;
      end

    endcase
  end

  // Control signal decoding
  always @(*)
  begin
    Cp = control_signal[11];
    Ep = control_signal[10];
    Lm = control_signal[9];
    CE = control_signal[8];
    Li = control_signal[7];
    Ei = control_signal[6];
    La = control_signal[5];
    Ea = control_signal[4];
    Su = control_signal[3];
    Eu = control_signal[2];
    Lb = control_signal[1];
    Lo = control_signal[0];
  end

endmodule
