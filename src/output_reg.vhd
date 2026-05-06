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