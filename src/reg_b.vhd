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