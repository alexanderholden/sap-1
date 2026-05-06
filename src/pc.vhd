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
    pc_bus_in  : in std_logic_vector(3 downto 0);
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