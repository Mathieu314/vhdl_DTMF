library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DecodeClavier is
  port(
    Scan_DAV: in std_logic;
    Scan_Err: in std_logic;
    data:in std_logic_vector(7 downto 0);
    clk:in std_logic;
    reset:in std_logic;
    Key:out std_logic_vector(3 downto 0);
    Enable:out std_logic_vector;
    DAV_st:out std_logic;
    DoRead:out std_logic
  );
end entity;

architecture a_DecodeClavier of DecodeClavier is
  signal compteur: std_logic;
  signal
Begin
  Process (clk, reset)
   Begin
    if reset='1' then
      RAZ <= '1';
      DAV_st <= '1';
    elsif(clk'event and clk='1')then
      if data = "01110000" then -- 0
        F1 <= "011";
        F2 <= "101";
        DAV_st <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01101001"then -- 1
        F1 <= "000";
        F2 <= "100";
        DAV_st <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01110010"then -- 2
        F1 <= "000";
        F2 <= "101";
        DAV_st <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01111010"then -- 3
        F1 <= "000";
        F2 <= "110";
        DAV_st <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01101011"then -- 4
        F1 <= "001";
        F2 <= "100";
        DAV_st <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01110011"then -- 5
        F1 <= "001";
        F2 <= "101";
        DAV_st <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01110100"then -- 6
        F1 <= "001";
        F2 <= "110";
        DAV_st <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01101100"then -- 7
        F1 <= "010";
        F2 <= "100";
        DAV_st <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01110101"then -- 8
        F1 <= "010";
        F2 <= "110";
        DAV_st <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01111101"then -- 9
        F1 <= "010";
        F2 <= "111";
        DAV_st <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01111101"then -- A
        DoRead <= Scan_DAV;
      elsif data = "01111101"then -- B
        DoRead <= Scan_DAV;
      elsif data = "01111101"then -- C
        DoRead <= Scan_DAV;
      elsif data = "01111101"then -- D
        DoRead <= Scan_DAV;
      elsif data = "01111101"then -- #
        DoRead <= Scan_DAV;
      elsif data = "01111101"then -- *
        DoRead <= Scan_DAV;
      end if;
    end if;
end Process;
end architecture;