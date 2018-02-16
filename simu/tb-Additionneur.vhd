library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_additionneur is
end entity tb_additionneur;


architecture testbench of tb_additionneur is
	Signal S1, S2 : std_logic_vector(5 downto 0);
	Signal Somme : std_logic_vector(6 downto 0);
begin
	T0: entity work.Additionneur(a_additionneur) port map (S1, S2, Somme);

	test : process
	begin
		S1 <= "000101";
		S2 <= "000110";
		wait for 20 ps;
		S1 <= "000001";
		S2 <= "000111";
		wait for 20 ps;
	end process test;
end architecture testbench;
