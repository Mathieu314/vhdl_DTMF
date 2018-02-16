library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_decodeur is
end entity tb_decodeur;


architecture testbench of tb_decodeur is
	Signal Enable : std_logic;
	Signal F1, F2 : std_logic_vector(2 downto 0);
	Signal Key : std_logic_vector(3 downto 0);
begin
	T0: entity work.Decodeur(a_decodeur) port map (Key, Enable, F1, F2);

	test : process
	begin
	  Enable <= '1';
		Key <= "0101";
		wait for 20 ps;
		Key <= "0110";
		wait for 20 ps;
		Enable <='1';
		Key <= "0010";
		wait for 20 ps;
	end process test;
end architecture testbench;