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