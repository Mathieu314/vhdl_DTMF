library ieee;
use .std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity additionneur is
  port(
    sin1:in std_logic_vector(5 downto 0;
    sin2:in std_logic_vector(5 downto 0);
    somme:out std_logic_vector(6 downto 0)
  );

architecture a_additionneur of additionneur is
Begin
  somme <= sin1+sin2;
end architecture;