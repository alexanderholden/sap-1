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