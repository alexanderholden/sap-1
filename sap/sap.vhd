library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- c_p = when active increment on falling edge
-- e_p = when active put program register onto bus
-- nclr = active low clr
-- nclk = active low clk

entity programcounter is -- WORKING
  port (
    C_P        : in std_logic;
    nCLK       : in std_logic;
    nCLR       : in std_logic;
    E_P        : in std_logic; -- will be used on top level implementation
    pc_bus_out : out std_logic_vector(7 downto 0)
  );
end;

architecture programcounter_rtl of programcounter is
  signal programcounter_reg : unsigned(3 downto 0) := (others => '0');
begin
  process (nCLK)
  begin
    if nCLR = '0' then
      programcounter_reg <= (others => '0');
    elsif falling_edge(nCLK) then
      if C_P = '1' then
        programcounter_reg <= programcounter_reg + 1;
      end if;
    end if;
  end process;
  pc_bus_out <= "0000" & std_logic_vector(programcounter_reg) when E_P = '1' else
    (others => 'Z');
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--L_A = active low loading into accumulator
--e_a = active high loading from accumulator onto bus
-- CLK = active high clock

entity accumulator is --WORKING
  port (
    L_A         : in std_logic;
    CLK         : in std_logic;
    E_A         : in std_logic;
    acc_bus_in  : in std_logic_vector(7 downto 0);
    acc_bus_out : out std_logic_vector(7 downto 0);
    addsub_in   : out std_logic_vector(7 downto 0)

  );
end;
architecture accumulator_rtl of accumulator is
  signal accumulator_reg : std_logic_vector(7 downto 0) := (others => '0');
begin
  process (CLK)
  begin
    if rising_edge(CLK) then
      if L_A = '1' then
        accumulator_reg <= acc_bus_in;
      end if;
    end if;
  end process;

  acc_bus_out <= accumulator_reg when E_A = '1' else
    (others => 'Z');

  addsub_in <= accumulator_reg;
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--nL_B = active low loading b into addsum
-- clk = clock
-- b_bus_in = accepts data from bus
-- b_addsum_in = outputs to addsum (hello hi)

entity b_reg is --WORKING
  port (
    L_B         : in std_logic;
    CLK         : in std_logic;
    b_bus_in    : in std_logic_vector(7 downto 0);
    b_addsum_in : out std_logic_vector(7 downto 0)

  );
end;

architecture b_rtl of b_reg is
  signal b_reg : std_logic_vector(7 downto 0) := (others => '0');
begin
  process (CLK)
  begin
    if rising_edge(CLK) then
      if L_B = '1' then
        b_reg <= b_bus_in;
      end if;
    end if;
  end process;

  b_addsum_in <= b_reg;
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- fucking logisim made me call this shit hello hi, its the add sub
-- A = accumulator input
-- B = b register input
-- s_u = subtract/add mode swap, 0 = add, 1 = sub
-- e_u = output to bus

entity hello_hi is
  port (
    A                : in std_logic_vector(7 downto 0);
    B                : in std_logic_vector(7 downto 0);
    S_U              : in std_logic;
    E_U              : in std_logic;
    hello_hi_bus_out : out std_logic_vector(7 downto 0)
  );
end;

architecture hello_hi_rtl of hello_hi is

  signal result : std_logic_vector(7 downto 0);
begin

  process (A, B, S_U)
  begin
    if S_U = '0' then
      result <= std_logic_vector(unsigned(A) + unsigned(B));
    else
      result <= std_logic_vector(unsigned(A) - unsigned(B));
    end if;
  end process;

  hello_hi_bus_out <= result when E_U = '1' else
    (others => 'Z');

end;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--mar_addr = input from mar for which address to access
-- nCE = active low chip enable (output)
-- data_out_bus = output to bus

entity ram16x8 is
  port (
    mar_addr     : in std_logic_vector (3 downto 0);
    CE           : in std_logic;
    data_out_bus : out std_logic_vector(7 downto 0);
    WE           : in std_logic;
    data_input   : in std_logic_vector (7 downto 0);
    addr_input   : in std_logic_vector (3 downto 0);
    clk          : in std_logic;
    nCLR         : in std_logic
  );
end;

architecture rtl_ram of ram16x8 is
  type ram_type is array (0 to 15) of std_logic_vector(7 downto 0);
  signal ram : ram_type := (
  0 => "00000101", -- LDA 5
  1 => "00010110", -- ADD 6
  2 => "11100000", -- output
  5 => "00000101",
  6 => "00000101",
  others => (others => '0')
  );
begin
  data_out_bus <= ram(to_integer(unsigned(mar_addr))) when CE = '1' else
    (others => 'Z');
  process (clk)
  begin
    if rising_edge(clk) then
      if WE = '1' then
        ram(to_integer(unsigned(addr_input))) <= data_input;
      elsif nCLR = '0' then
        ram <= (others => (others => '0'));
      end if;
    end if;
  end process;
end architecture;

  library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

  -- nLM = active low allowing input from bus into mar
  -- bus_in = bus input
  -- mar_addr_out = address output to ram

  entity mar is
    port (
      LM           : in std_logic;
      CLK          : in std_logic;
      bus_in       : in std_logic_vector(3 downto 0);
      mar_addr_out : out std_logic_vector(3 downto 0)
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

    mar_addr_out <= mar_reg;
  end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instructionregister is
  port (
    L_I           : in std_logic;
    CLK           : in std_logic;
    CLR           : in std_logic;
    E_I           : in std_logic;
    ir_bus_in     : in std_logic_vector (7 downto 0);
    ir_addr_out   : out std_logic_vector (3 downto 0);
    ir_opcode_out : out std_logic_vector (3 downto 0)
  );
end;

architecture instructionregister_rtl of instructionregister is
  signal ir_reg : std_logic_vector (7 downto 0) := (others => '0');
begin
  process (clk, CLR)
  begin
    if CLR = '0' then
      ir_reg <= (others => '0');
    elsif rising_edge(clk) then
      if L_I = '1' then
        ir_reg <= ir_bus_in;
      end if;
    end if;
  end process;
  ir_opcode_out <= ir_reg(7 downto 4);
  ir_addr_out   <= ir_reg (3 downto 0) when E_I = '1' else
    (others => 'Z');
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity outregister is
  port (
    L_O         : in std_logic;
    CLK         : in std_logic;
    out_bus_in  : in std_logic_vector (7 downto 0);
    out_reg_out : out std_logic_vector (7 downto 0)
  );
end;

architecture outregister_rtl of outregister is
  signal out_reg : std_logic_vector (7 downto 0) := (others => '0');
begin
  process (clk)
  begin
    if rising_edge(clk) then
      if L_O = '1' then
        out_reg <= out_bus_in;
      end if;
    end if;
  end process;
  out_reg_out <= out_reg;
end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Controller is
    Port ( clk : in  STD_LOGIC;
			  clr : in  STD_LOGIC;
			  inst_in : in STD_LOGIC_VECTOR (3 downto 0);
			  Cp : out STD_LOGIC;
			  Ep : out STD_LOGIC;
			  Lm : out STD_LOGIC;
			  CE : out STD_LOGIC;
			  Li : out STD_LOGIC;
			  Ei : out STD_LOGIC;
			  La : out STD_LOGIC;
			  Ea : out STD_LOGIC;
			  Su : out STD_LOGIC;
			  Eu : out STD_LOGIC;
			  Lb : out STD_LOGIC;
			  Lo : out STD_LOGIC;
			  HLT : out STD_LOGIC);
end Controller;

architecture Behavioral of Controller is

type state is (idle, t0, t1, t2, t3, t4, t5);
signal pr_state, nx_state : state := t0;
signal control_signal : STD_LOGIC_VECTOR (11 downto 0) := (others => '0');
signal HLT_sig : STD_LOGIC := '1';

begin

-- This process if for updating current state.
process(clk, clr)
begin
	if clr = '0' then
		pr_state <= idle;
	elsif rising_edge(clk) then
		pr_state <= nx_state;
	end if;
end process;


-- This process does the actual transition logic and operations.
process(pr_state)
begin
	case pr_state is
		when idle =>
			--Do nothing
			control_signal <= "000000000000";
			HLT_sig <= '1';
			nx_state <= t0;

		when t0 =>
			--Enable PC (Ep = 1), Load into MAR (Lm = 1)
			control_signal <= "011000000000";
			nx_state <= t1;
		
		when t1 =>
			--Increment PC (Cp = 1)
			control_signal <= "100000000000";
			nx_state <= t2;
		
		when t2 =>
			--Enable memory (CE = 1), Load into IR (Li = 1)
			control_signal <= "000110000000";
			nx_state <= t3;
			
		when t3 =>
			--OUT
			if inst_in = "1110" then
				--Enable AC, Load into OUT
				control_signal <= "000000010001";
			--HALT
			elsif inst_in = "1111" then
				control_signal <= "000000000000";
				HLT_sig <= '0';
			--Other instructions
			else
				control_signal <= "001001000000";
			end if;
			nx_state <= t4;
		
		when t4 =>
			--LDA
			if inst_in = "0000" then
				--Enable memory, Load into AC
				control_signal <= "000100100000";
			--ADD
			elsif inst_in = "0001" then
				--Enable memory, Load into B
				control_signal <= "000100000010";
			--SUB
			elsif inst_in = "0010" then
				--Enable memory, Load into B
				control_signal <= "000100000010";
			--Other instructions
			else
				control_signal <= "000000000000";
			end if;
			nx_state <= t5;
			
		when t5 =>
			--ADD
			if inst_in = "0001" then
				--Enable ALU, Load into AC, Su = 0 for ADD
				control_signal <= "000000100100";
			--SUB
			elsif inst_in = "0010" then
				--Enable ALU, Load into AC, Su = 1 for SUB
				control_signal <= "000000101100";
			--Other instructions
			else
				control_signal <= "000000000000";
			end if;
			nx_state <= t0;
			
	end case;
end process;

--Move control signal to output

Cp <= control_signal(11);
Ep <= control_signal(10);
Lm <= control_signal(9);
CE <= control_signal(8);
Li <= control_signal(7);
Ei <= control_signal(6);
La <= control_signal(5);
Ea <= control_signal(4);
Su <= control_signal(3);
Eu <= control_signal(2);
Lb <= control_signal(1);
Lo <= control_signal(0);
HLT <= HLT_sig;

end Behavioral;