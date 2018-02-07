Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity table_sin is port (
	ADDRESS : in std_logic_vector(5 downto 0);
	CLK : in std_logic;
	SIN : out std_logic_vector(5 downto 0)
);
end entity table_sin;

architecture behavioral of table_sin is

begin
	clock: process(ADDRESS)
	begin
		case ADDRESS is
			when "000000" => SIN <= "000000";
			when "000001" => SIN <= "000001";
			when "000010" => SIN <= "000011";
			when "000011" => SIN <= "000100";
			when "000100" => SIN <= "000110";
			when "000101" => SIN <= "000111";
			when "000110" => SIN <= "001000";
			when "000111" => SIN <= "001010";
			when "001000" => SIN <= "001011";
			when "001001" => SIN <= "001100";
			when "001010" => SIN <= "001101";
			when "001011" => SIN <= "001101";
			when "001100" => SIN <= "001110";
			when "001101" => SIN <= "001111";
			when "001110" => SIN <= "001111";
			when "001111" => SIN <= "001111";
			when "010000" => SIN <= "001111";
			when "010001" => SIN <= "001111";
			when "010010" => SIN <= "001111";
			when "010011" => SIN <= "001111";
			when "010100" => SIN <= "001110";
			when "010101" => SIN <= "001101";
			when "010110" => SIN <= "001101";
			when "010111" => SIN <= "001100";
			when "011000" => SIN <= "001011";
			when "011001" => SIN <= "001010";
			when "011010" => SIN <= "001000";
			when "011011" => SIN <= "000111";
			when "011100" => SIN <= "000110";
			when "011101" => SIN <= "000100";
			when "011110" => SIN <= "000011";
			when "011111" => SIN <= "000001";
			when "100000" => SIN <= "000000";
			when "100001" => SIN <= "100001";
			when "100010" => SIN <= "100011";
			when "100011" => SIN <= "100100";
			when "100100" => SIN <= "100110";
			when "100101" => SIN <= "100111";
			when "100110" => SIN <= "101000";
			when "100111" => SIN <= "101010";
			when "101000" => SIN <= "101011";
			when "101001" => SIN <= "101100";
			when "101010" => SIN <= "101101";
			when "101011" => SIN <= "101101";
			when "101100" => SIN <= "101110";
			when "101101" => SIN <= "101111";
			when "101110" => SIN <= "101111";
			when "101111" => SIN <= "101111";
			when "110000" => SIN <= "101111";
			when "110001" => SIN <= "101111";
			when "110010" => SIN <= "101111";
			when "110011" => SIN <= "101111";
			when "110100" => SIN <= "101110";
			when "110101" => SIN <= "101101";
			when "110110" => SIN <= "101101";
			when "110111" => SIN <= "101100";
			when "111000" => SIN <= "101011";
			when "111001" => SIN <= "101010";
			when "111010" => SIN <= "101000";
			when "111011" => SIN <= "100111";
			when "111100" => SIN <= "100110";
			when "111101" => SIN <= "100100";
			when "111110" => SIN <= "100011";
			when "111111" => SIN <= "100001";
			when others => SIN <= "000000";
		end case;
	end process clock;
end architecture behavioral;
