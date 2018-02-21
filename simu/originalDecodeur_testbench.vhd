Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity originalDecodeur_testbench is
end entity originalDecodeur_testbench;


architecture testbench of originalDecodeur_testbench is
	Signal Scan_DAV, Scan_Err, RESET, CLK, Enable, DoRead : std_logic;
	Signal data_in : std_logic_vector(7 downto 0);
	Signal Key : std_logic_vector(3 downto 0);
begin
	T0: entity work.DecodeClavier(a_DecodeClavier) port map (Scan_DAV, Scan_Err, data_in, CLK, RESET, Key, Enable, DoRead);

	clocked : process
	begin
		CLK <= '0';
		wait for 10 ps;
		CLK <= '1'; 
		wait for 10 ps;
	end process clocked;
		

	test : process
	begin
	end process test;
end architecture testbench;
