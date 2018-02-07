Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sin_testbench is
end entity sin_testbench;


architecture testbench of sin_testbench is
	Signal CLK: std_logic;
	Signal ADDR, S : std_logic_vector(5 downto 0);
begin
	T0: entity work.table_sin(behavioral) port map (ADDR, CLK, S);

	clocked : process
	begin
		CLK <= '0';
		wait for 10 ns;
		CLK <= '1'; 
		wait for 10 ns;
	end process clocked;
		

	test : process
	begin
		ADDR <= "000000";
		wait for 20 ns;
		ADDR <= "010000";
		wait for 20 ns;
		ADDR <= "111111";
		wait for 20 ns;
	end process test;
end architecture testbench;
