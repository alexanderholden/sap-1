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