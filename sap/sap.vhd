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
    if rising_edge(nCLK) then
      if nCLR = '0' then
        programcounter_reg <= (others => '0');
      elsif C_P = '1' then
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
--nL_A = active low loading into accumulator
--e_a = active high loading from accumulator onto bus
-- CLK = active high clock

entity accumulator is --WORKING
  port (
    nL_A        : in std_logic;
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
      if nL_A = '0' then
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
    nL_B        : in std_logic;
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
      if nL_B = '0' then
        b_reg <= b_bus_in;
      end if;
    end if;
  end process;

  b_addsum_in <= b_reg;
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-- fucking logisim made me call this shit hello hi
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
    nCE          : in std_logic;
    data_out_bus : out std_logic_vector(7 downto 0)
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
  data_out_bus <= ram(to_integer(unsigned(mar_addr))) when nCE = '0' else
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
    nLM          : in std_logic;
    CLK          : in std_logic;
    bus_in       : in std_logic_vector(7 downto 0);
    mar_addr_out : out std_logic_vector(3 downto 0)
  );
end;

architecture mar_rtl of mar is
  signal mar_reg : std_logic_vector(3 downto 0) := (others => '0');
begin
  process (CLK)
  begin
    if rising_edge(CLK) then
      if nLM = '0' then
        mar_reg <= bus_in(3 downto 0); -- only lower 4 bits
      end if;
    end if;
  end process;

  mar_addr_out <= mar_reg;
end architecture;