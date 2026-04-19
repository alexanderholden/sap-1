library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- CP = when active increment on falling edge
-- EP = when active put program register onto bus
-- nCLR = active low clr
-- nCLK = active low clk

entity program_counter is -- WORKING
  port (
    CP         : in std_logic;
    nCLK       : in std_logic;
    nCLR       : in std_logic;
    EP         : in std_logic;
    LP         : in std_logic;
    pc_bus_in  : in std_logic_vector(3 downto 0);
    pc_bus_out : out std_logic_vector(7 downto 0)
  );
end;

architecture program_counter_rtl of program_counter is
  signal programcounter_reg : unsigned(3 downto 0) := (others => '0');
begin
  process (nCLK)
  begin
    if nCLR = '0' then
      programcounter_reg <= (others => '0');
    elsif falling_edge(nCLK) then
      if CP = '1' then
        programcounter_reg <= programcounter_reg + 1;
      elsif LP = '1' then
        programcounter_reg <= UNSIGNED(pc_bus_in);
      end if;
    end if;
  end process;
  pc_bus_out <= "0000" & std_logic_vector(programcounter_reg) when EP = '1' else
    (others => 'Z');
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--LA = active low loading into accumulator
--EA = active high loading from accumulator onto bus
--CLK = active high clock

entity accumulator is --WORKING
  port (
    LA            : in std_logic;
    CLK           : in std_logic;
    EA            : in std_logic;
    acc_bus_in    : in std_logic_vector(7 downto 0);
    acc_bus_out   : out std_logic_vector(7 downto 0);
    add_sub_input : out std_logic_vector(7 downto 0)

  );
end;
architecture accumulator_rtl of accumulator is
  signal accumulator_reg : std_logic_vector(7 downto 0) := (others => '0');
begin
  process (CLK)
  begin
    if rising_edge(CLK) then
      if LA = '1' then
        accumulator_reg <= acc_bus_in;
      end if;
    end if;
  end process;

  acc_bus_out <= accumulator_reg when EA = '1' else
    (others => 'Z');

  add_sub_input <= accumulator_reg;
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--nL_B = active low loading b into addsum
-- clk = clock
-- b_bus_in = accepts data from bus
-- b_addsum_in = outputs to addsum (hello hi)

entity b_register is --WORKING
  port (
    LB           : in std_logic;
    CLK          : in std_logic;
    b_bus_in     : in std_logic_vector(7 downto 0);
    b_add_sum_in : out std_logic_vector(7 downto 0)
  );
end;

architecture b_register_rtl of b_register is
  signal b_reg : std_logic_vector(7 downto 0) := (others => '0');
begin
  process (CLK)
  begin
    if rising_edge(CLK) then
      if LB = '1' then
        b_reg <= b_bus_in;
      end if;
    end if;
  end process;
  b_add_sum_in <= b_reg;
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- A = accumulator input
-- B = b register input
-- SU = subtract/add mode swap, 0 = add, 1 = sub
-- EU = output to bus

entity add_sub is
  port (
    A               : in std_logic_vector(7 downto 0);
    B               : in std_logic_vector(7 downto 0);
    SU              : in std_logic;
    EU              : in std_logic;
    ADD_SUB_bus_out : out std_logic_vector(7 downto 0)
  );
end;

architecture add_sub_rtl of add_sub is
  signal result : std_logic_vector(7 downto 0);
begin
  process (A, B, SU)
  begin
    if SU = '0' then
      result <= std_logic_vector(unsigned(A) + unsigned(B));
    else
      result <= std_logic_vector(unsigned(A) - unsigned(B));
    end if;
  end process;
  add_sub_bus_out <= result when EU = '1' else
    (others => 'Z');
end;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram16x8 is
  port (
    mar_addr    : in std_logic_vector(3 downto 0);
    CE          : in std_logic; -- active high
    ram_bus_out : out std_logic_vector(7 downto 0)
  );
end;

architecture rtl_ram of ram16x8 is
  type ram_type is array (0 to 15) of std_logic_vector(7 downto 0);
  signal ram : ram_type := (
  0  => "00001001", -- LDA @9
  1  => "00011100", -- ADD @12
  2  => "11101111", -- OUT
  3  => "01100001", -- JMP @1
  4  => "01100001", -- HLT (unused)
  5  => "00000000",
  6  => "00000000",
  7  => "00000000",
  8  => "00000000",
  9  => "00000001",
  10 => "00000001",
  11 => "00000001",
  12 => "00000001",
  13 => "00000000",
  14 => "00000000",
  15 => "00000000"
  );
begin
  ram_bus_out <= ram(to_integer(unsigned(mar_addr))) when CE = '1' else
    (others => 'Z');
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- nLM = active low allowing input from bus into mar
-- bus_in = bus input
-- mar_addr_out = address output to ram

entity mar is
  port (
    LM               : in std_logic;
    CLK              : in std_logic;
    bus_in           : in std_logic_vector(3 downto 0);
    mar_addr_bus_out : out std_logic_vector(3 downto 0)
  );
end;

architecture mar_rtl of mar is
  signal mar_reg : std_logic_vector(3 downto 0) := (others => '0');
begin
  process (CLK)
  begin
    if rising_edge(CLK) then
      if LM = '1' then
        mar_reg <= bus_in; -- only lower 4 bits
      end if;
    end if;
  end process;

  mar_addr_bus_out <= mar_reg;
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_register is
  port (
    LI            : in std_logic;
    CLK           : in std_logic;
    CLR           : in std_logic;
    EI            : in std_logic;
    ir_bus_in     : in std_logic_vector (7 downto 0);
    ir_addr_out   : out std_logic_vector (3 downto 0);
    ir_opcode_out : out std_logic_vector (3 downto 0)
  );
end;

architecture instruction_register_rtl of instruction_register is
  signal ir_reg : std_logic_vector (7 downto 0) := (others => '0');
begin
  process (clk, CLR)
  begin
    if CLR = '0' then
      ir_reg <= (others => '0');
    elsif rising_edge(clk) then
      if LI = '1' then
        ir_reg <= ir_bus_in;
      end if;
    end if;
  end process;
  ir_opcode_out <= ir_reg(7 downto 4);
  ir_addr_out   <= ir_reg (3 downto 0) when EI = '1' else
    (others => 'Z');
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity outregister is
  port (
    LO              : in std_logic;
    CLK             : in std_logic;
    out_bus_in      : in std_logic_vector (7 downto 0);
    out_reg_bus_out : out std_logic_vector (7 downto 0)
  );
end;

architecture outregister_rtl of outregister is
  signal out_reg : std_logic_vector (7 downto 0) := (others => '0');
begin
  process (clk)
  begin
    if rising_edge(clk) then
      if LO = '1' then
        out_reg <= out_bus_in;
      end if;
    end if;
  end process;
  out_reg_bus_out <= out_reg;
end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Controller is
  port (
    clk     : in std_logic;
    clr     : in std_logic;
    inst_in : in std_logic_vector (3 downto 0);
    Cp      : out std_logic;
    Ep      : out std_logic;
    Lm      : out std_logic;
    CE      : out std_logic;
    Li      : out std_logic;
    Ei      : out std_logic;
    La      : out std_logic;
    Ea      : out std_logic;
    Su      : out std_logic;
    Eu      : out std_logic;
    Lb      : out std_logic;
    Lo      : out std_logic;
    Lp      : out std_logic;
    HLT     : out std_logic);
end Controller;

architecture Behavioral of Controller is

  type state is (idle, t0, t1, t2, t3, t4, t5);
  signal pr_state, nx_state : state                          := t0;
  signal control_signal     : std_logic_vector (12 downto 0) := (others => '0');
  signal HLT_sig            : std_logic                      := '1';

begin
  process (clk, clr)
  begin
    if clr = '0' then
      pr_state <= idle;
    elsif rising_edge(clk) then
      pr_state <= nx_state;
    end if;
  end process;
  process (pr_state)
  begin
    case pr_state is
      when idle =>
        --Do nothing
        control_signal <= "0000000000000";
        HLT_sig        <= '1';
        nx_state       <= t0;

      when t0 =>
        --Enable PC (Ep = 1), Load into MAR (Lm = 1)
        control_signal <= "0011000000000";
        nx_state       <= t1;

      when t1 =>
        --Increment PC (Cp = 1)
        control_signal <= "0100000000000";
        nx_state       <= t2;

      when t2 =>
        --Enable memory (CE = 1), Load into IR (Li = 1)
        control_signal <= "0000110000000";
        nx_state       <= t3;

      when t3 =>
        --OUT
        if inst_in = "1110" then
          --Enable AC, Load into OUT
          control_signal <= "0000000010001";
          --HALT
        elsif inst_in = "1111" then
          control_signal <= "0000000000000";
          HLT_sig        <= '0';
          --Other instructions
        elsif inst_in = "0110" then
          control_signal <= "1000001000000";
        else
          control_signal <= "0001001000000";
        end if;
        nx_state <= t4;

      when t4 =>
        --LDA
        if inst_in = "0000" then
          --Enable memory, Load into AC
          control_signal <= "0000100100000";
          --ADD
        elsif inst_in = "0001" then
          --Enable memory, Load into B
          control_signal <= "0000100000010";
          --SUB
        elsif inst_in = "0010" then
          --Enable memory, Load into B
          control_signal <= "0000100000010";
          --Other instructions
        else
          control_signal <= "0000000000000";
        end if;
        nx_state <= t5;

      when t5 =>
        --ADD
        if inst_in = "0001" then
          --Enable ALU, Load into AC, Su = 0 for ADD
          control_signal <= "0000000100100";
          --SUB
        elsif inst_in = "0010" then
          --Enable ALU, Load into AC, Su = 1 for SUB
          control_signal <= "0000000101100";
          --Other instructions
        else
          control_signal <= "0000000000000";
        end if;
        nx_state <= t0;

    end case;
  end process;

  --Move control signal to output
  Lp  <= control_signal(12);
  Cp  <= control_signal(11);
  Ep  <= control_signal(10);
  Lm  <= control_signal(9);
  CE  <= control_signal(8);
  Li  <= control_signal(7);
  Ei  <= control_signal(6);
  La  <= control_signal(5);
  Ea  <= control_signal(4);
  Su  <= control_signal(3);
  Eu  <= control_signal(2);
  Lb  <= control_signal(1);
  Lo  <= control_signal(0);
  HLT <= HLT_sig;

end Behavioral;