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
    Enable:out std_logic;
    DoRead:out std_logic
  );
end entity;

architecture a_DecodeClavier of DecodeClavier is
  signal compteur: std_logic;
Begin
  Process (clk, reset)
   Begin
    if reset='1' then
        Enable <= '0';
    elsif(clk'event and clk='1')then
      if data = "01110000" then -- 0
        Key <= "0000";
        Enable <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01101001"then -- 1
        Key <= "0001";
        Enable <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01110010"then -- 2
        Key <= "0010";
        Enable <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01111010"then -- 3
        Key <= "0011";
        Enable <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01101011"then -- 4
        Key <= "0100";
        Enable <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01110011"then -- 5
        Key <= "0101";
        Enable <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01110100"then -- 6
        Key <= "0110";
        Enable <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01101100"then -- 7
        Key <= "0111";
        Enable <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01110101"then -- 8
        Key <= "1000";
        Enable <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01111101"then -- 9
        Key <= "1001";
        Enable <= '1';
        DoRead <= Scan_DAV;
      elsif data = "01111100"then -- *
        Key <= "1010";
        Enable <= '1';
        DoRead <= Scan_DAV;
      end if;
    end if;
end Process;
end architecture;
