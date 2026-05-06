-- library IEEE;
-- use IEEE.std_logic_1164.all;
-- use IEEE.numeric_std.all;

-- entity ram16x8 is
--   port (
--     mar_addr    : in std_logic_vector(3 downto 0);
--     CE          : in std_logic; -- active high
--     ram_bus_out : out std_logic_vector(7 downto 0);
--     WE          : in std_logic;
--     data_in     : in std_logic_vector(7 downto 0);
--     clk         : in std_logic;
--     temp_ram_12_out : out STD_LOGIC_VECTOR (7 downto 0)


--   );
-- end;

-- architecture rtl_ram of ram16x8 is
--   type ram_type is array (0 to 15) of std_logic_vector(7 downto 0);
--   signal ram : ram_type := (
--   0  => "00001001", -- LDA @9
--   1  => "00011100", -- ADD @12
--   2  => "11101111", -- OUT
--   3  => "01100001", -- JMP @1
--   4  => "01100001", -- HLT (unused)
--   5  => "00000000",
--   6  => "00000000",
--   7  => "00000000",
--   8  => "00000000",
--   9  => "00000001",
--   10 => "00000001",
--   11 => "00000001",
--   12 => "00000001",
--   13 => "00000000",
--   14 => "00000000",
--   15 => "00000000"
--   );
-- begin
--   process (clk)
--   begin
--     if rising_edge(clk) then
--       if CE = '1' and WE = '1' then
--         ram(to_integer(unsigned(mar_addr))) <= data_in;
--       end if;
--     end if;
--   end process;
--   temp_ram_12_out <= ram(11); 
--   ram_bus_out <= ram(to_integer(unsigned(mar_addr))) when CE = '1' else
--     (others => 'Z');
-- end architecture;

-- library IEEE;
-- use IEEE.std_logic_1164.all;
-- use IEEE.numeric_std.all;

-- -- nLM = active low allowing input from bus into mar
-- -- bus_in = bus input
-- -- mar_addr_out = address output to ram

-- entity mar is
--   port (
--     LM               : in std_logic;
--     CLK              : in std_logic;
--     bus_in           : in std_logic_vector(3 downto 0);
--     mar_addr_bus_out : out std_logic_vector(3 downto 0)
--   );
-- end;

-- architecture mar_rtl of mar is
--   signal mar_reg : std_logic_vector(3 downto 0) := (others => '0');
-- begin
--   process (CLK)
--   begin
--     if rising_edge(CLK) then
--       if LM = '1' then
--         mar_reg <= bus_in; -- only lower 4 bits
--       end if;
--     end if;
--   end process;

--   mar_addr_bus_out <= mar_reg;
-- end architecture;

-- library IEEE;
-- use IEEE.std_logic_1164.all;
-- use IEEE.numeric_std.all;

-- entity instruction_register is
--   port (
--     LI            : in std_logic;
--     CLK           : in std_logic;
--     CLR           : in std_logic;
--     EI            : in std_logic;
--     ir_bus_in     : in std_logic_vector (7 downto 0);
--     ir_addr_out   : out std_logic_vector (3 downto 0);
--     ir_opcode_out : out std_logic_vector (3 downto 0)
--   );
-- end;

-- architecture instruction_register_rtl of instruction_register is
--   signal ir_reg : std_logic_vector (7 downto 0) := (others => '0');
-- begin
--   process (clk, CLR)
--   begin
--     if CLR = '0' then
--       ir_reg <= (others => '0');
--     elsif rising_edge(clk) then
--       if LI = '1' then
--         ir_reg <= ir_bus_in;
--       end if;
--     end if;
--   end process;
--   ir_opcode_out <= ir_reg(7 downto 4);
--   ir_addr_out   <= ir_reg (3 downto 0) when EI = '1' else
--     (others => 'Z');
-- end architecture;

-- library IEEE;
-- use IEEE.std_logic_1164.all;
-- use IEEE.numeric_std.all;

-- entity outregister is
--   port (
--     LO              : in std_logic;
--     CLK             : in std_logic;
--     out_bus_in      : in std_logic_vector (7 downto 0);
--     out_reg_bus_out : out std_logic_vector (7 downto 0)
--   );
-- end;

-- architecture outregister_rtl of outregister is
--   signal out_reg : std_logic_vector (7 downto 0) := (others => '0');
-- begin
--   process (clk)
--   begin
--     if rising_edge(clk) then
--       if LO = '1' then
--         out_reg <= out_bus_in;
--       end if;
--     end if;
--   end process;
--   out_reg_bus_out <= out_reg;
-- end architecture;