Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pwm_testbench is
end entity pwm_testbench;


architecture testbench of pwm_testbench is
	Signal CLK, RESET, PWM_OUT : std_logic;
	Signal Sig_In : std_logic_vector(6 downto 0);
begin
	T0: entity work.pwm(behavioral) port map (Sig_In, CLK, RESET, PWM_OUT);

	clocked : process
	begin
		CLK <= '0';
		wait for 10 ns;
		CLK <= '1'; 
		wait for 10 ns;
	end process clocked;
		

	test : process
	begin
		Sig_In <= "0000000";
		wait for 20 ns;
		Sig_In <= "0011111";
		wait for 20 ns;
		Sig_In <= "0111110";
		wait for 20 ns;
	end process test;
end architecture testbench;
