library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mem is
  port (
    mar_addr    : in std_logic_vector(3 downto 0);
    CE          : in std_logic; -- active high
    ram_bus_out : out std_logic_vector(7 downto 0)
  );
end;

architecture rtl_ram of mem is
  type ram_type is array (0 to 15) of std_logic_vector(7 downto 0);
  signal ram : ram_type := (
  0  => "00001001", --LDA @9h
  1  => "11101111", --OUT
  2  => "00011010", --ADD @Ah
  3  => "11101111", --OUT
  4  => "00101011", --SUB @Bh
  5  => "11101111", --OUT
  6  => "11111111", --HLT
  7  => "00000000",
  8  => "00000000",
  9  => "00000110", --6
  10 => "00001000", --8
  11 => "00000011", --3
  12 => "00000000",
  13 => "11111111",
  14 => "11111111",
  15 => "11111111");
begin
  ram_bus_out <= ram(to_integer(unsigned(mar_addr))) when CE = '1' else
    (others => 'Z');
end architecture;