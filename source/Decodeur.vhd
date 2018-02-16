library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decodeur is
  port(
    Key:in std_logic_vector(3 downto 0);
    Enable:in std_logic;
    F1:out std_logic_vector(2 downto 0);
    F2:out std_logic_vector(2 downto 0)
  );
end entity;

architecture a_Decodeur of Decodeur is
Begin
  Process
   Begin
    if(enable='1' and key="0000")then -- 0
        F1 <= "011";
        F2 <= "101";
      elsif (enable='1' and key="0001") then -- 1
        F1 <= "000";
        F2 <= "100";
      elsif (enable='1' and key="0010") then -- 2
        F1 <= "000";
        F2 <= "101";
      elsif (enable='1' and key="0011") then -- 3
        F1 <= "000";
        F2 <= "110";
      elsif (enable='1' and key="0100") then -- 4
        F1 <= "001";
        F2 <= "100";
      elsif (enable='1' and key="0101") then -- 5
        F1 <= "001";
        F2 <= "101";
      elsif (enable='1' and key="0110") then -- 6
        F1 <= "001";
        F2 <= "110";
      elsif (enable='1' and key="0111") then -- 7
        F1 <= "010";
        F2 <= "100";
      elsif (enable='1' and key="1000") then -- 8
        F1 <= "010";
        F2 <= "110";
      elsif (enable='1' and key="1001") then -- 9
        F1 <= "010";
        F2 <= "111";
      end if;
end Process;
end architecture;