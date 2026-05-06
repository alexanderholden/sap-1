library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Controller is
  port (
    clk     : in std_logic;
    clr     : in std_logic;
    inst_in : in std_logic_vector (3 downto 0);
    Cp      : out std_logic;
    Ep      : out std_logic;
    Lm      : out std_logic;
    CE      : out std_logic;
    Li      : out std_logic;
    Ei      : out std_logic;
    La      : out std_logic;
    Ea      : out std_logic;
    Su      : out std_logic;
    Eu      : out std_logic;
    Lb      : out std_logic;
    Lo      : out std_logic;
    Lp      : out std_logic;
    HLT     : out std_logic);
end Controller;

architecture Behavioral of Controller is

  type state is (idle, t0, t1, t2, t3, t4, t5);
  signal pr_state, nx_state : state                          := t0;
  signal control_signal     : std_logic_vector (12 downto 0) := (others => '0');
  signal HLT_sig            : std_logic                      := '1';

begin
  process (clk, clr)
  begin
    if clr = '0' then
      pr_state <= idle;
    elsif rising_edge(clk) then
      pr_state <= nx_state;
    end if;
  end process;
  process (pr_state)
  begin
    case pr_state is
      when idle =>
        --Do nothing
        control_signal <= "0000000000000";
        HLT_sig        <= '1';
        nx_state       <= t0;

      when t0 =>
        --Enable PC (Ep = 1), Load into MAR (Lm = 1)
        control_signal <= "0011000000000";
        nx_state       <= t1;

      when t1 =>
        --Increment PC (Cp = 1)
        control_signal <= "0100000000000";
        nx_state       <= t2;

      when t2 =>
        --Enable memory (CE = 1), Load into IR (Li = 1)
        control_signal <= "0000110000000";
        nx_state       <= t3;

      when t3 =>
        --OUT
        if inst_in = "1110" then
          --Enable AC, Load into OUT
          control_signal <= "0000000010001";
          --HALT
        elsif inst_in = "1111" then
          control_signal <= "0000000000000";
          HLT_sig        <= '0';
          --Other instructions
        elsif inst_in = "0110" then
          control_signal <= "1000001000000";
        else
          control_signal <= "0001001000000";
        end if;
        nx_state <= t4;

      when t4 =>
        --LDA
        if inst_in = "0000" then
          --Enable memory, Load into AC
          control_signal <= "0000100100000";
          --ADD
        elsif inst_in = "0001" then
          --Enable memory, Load into B
          control_signal <= "0000100000010";
          --SUB
        elsif inst_in = "0010" then
          --Enable memory, Load into B
          control_signal <= "0000100000010";
          --Other instructions
        else
          control_signal <= "0000000000000";
        end if;
        nx_state <= t5;

      when t5 =>
        --ADD
        if inst_in = "0001" then
          --Enable ALU, Load into AC, Su = 0 for ADD
          control_signal <= "0000000100100";
          --SUB
        elsif inst_in = "0010" then
          --Enable ALU, Load into AC, Su = 1 for SUB
          control_signal <= "0000000101100";
          --Other instructions
        else
          control_signal <= "0000000000000";
        end if;
        nx_state <= t0;

    end case;
  end process;

  --Move control signal to output
  Lp  <= control_signal(12);
  Cp  <= control_signal(11);
  Ep  <= control_signal(10);
  Lm  <= control_signal(9);
  CE  <= control_signal(8);
  Li  <= control_signal(7);
  Ei  <= control_signal(6);
  La  <= control_signal(5);
  Ea  <= control_signal(4);
  Su  <= control_signal(3);
  Eu  <= control_signal(2);
  Lb  <= control_signal(1);
  Lo  <= control_signal(0);
  HLT <= HLT_sig;

end Behavioral;