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