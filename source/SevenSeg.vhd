-- SevenSeg.vhd
-- -----------------------------------------
--   Hexadecimal to 7 segments encoder
-- -----------------------------------------
-- http://www.alse-fr.com
-- Notes : outputs are active high if Pol='0' else active low.
--         order is : Segout(1)=a, ... Segout(7)=g

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

-- --------------------------------
    Entity SevenSeg is
-- --------------------------------
  port ( Data   : in  std_logic_vector(3 downto 0);
         Pol    : in  std_logic;
         Segout : out std_logic_vector(1 to 7) ); -- a, b c d e f g
end;

-- --------------------------------------------------
    Architecture Comb of SevenSeg is
-- --------------------------------------------------

  signal Seg : std_logic_vector(SegOut'range);

begin

Xrg: for i in SegOut'range generate
  SegOut(i) <= Seg(i) xor Pol;
end generate;

process(Data)
begin
  case Data is
    when  x"0"  => Seg <= "1111110";
    when  x"1"  => Seg <= "0110000";
    when  x"2"  => Seg <= "1101101";
    when  x"3"  => Seg <= "1111001";
    when  x"4"  => Seg <= "0110011";
    when  x"5"  => Seg <= "1011011";
    when  x"6"  => Seg <= "1011111";
    when  x"7"  => Seg <= "1110000";
    when  x"8"  => Seg <= "1111111";
    when  x"9"  => Seg <= "1111011";
    when  x"A"  => Seg <= "1110111";
    when  x"B"  => Seg <= "0011111";
    when  x"C"  => Seg <= "0001101";
    when  x"D"  => Seg <= "0111101";
    when  x"E"  => Seg <= "1001111";
    when  x"F"  => Seg <= "1000111";
    when others => Seg <= (others => '-');
  end case;
end process;

end Comb;

