Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pwm is port (
	SIG_IN : in std_logic_vector(6 downto 0);
	CLK : in std_logic;
	RESET : in std_logic;
	PWM_OUT : out std_logic
);
end entity pwm;

architecture behavioral of pwm is
	Signal compteur : std_logic_vector(6 downto 0) := "0000000";
	Signal signalWidth : std_logic_vector(6 downto 0);

begin
	cycle: process(CLK, RESET, SIG_IN)
	begin
		if (SIG_IN(6) = '0') then
			signalWidth <= SIG_IN + "0111110";
		else
			signalWidth <= "0111110" - SIG_IN;
		end if;
		if reset = '1' then
			PWM_OUT <= '0';
		elsif (CLK'event and CLK = '1') then
			if (compteur < signalWidth) then
				PWM_OUT <= '1';
			else
				PWM_OUT <= '0';
			end if;
			if (compteur >= "1111100") then
				compteur <= "0000000";
			else
				compteur <= compteur + 1;
			end if;
		end if;
	end process cycle;
end architecture behavioral;
