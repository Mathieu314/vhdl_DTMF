Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IP_DTMF is port (
	-- Inputs
	CLK : in std_logic;
	RESET : in std_logic;

	-- For decodeClavier
	Key : in std_logic_vector(3 downto 0);
	Enable : in std_logic;

	-- Output
	DTMF_OUT : out std_logic
);
end entity IP_DTMF;

architecture behavioral of IP_DTMF is
	Signal Sum : std_logic_vector(6 downto 0);
	Signal Sin1 : std_logic_vector(5 downto 0);
	Signal Sin2 : std_logic_vector(5 downto 0);
	Signal Addr1  : std_logic_vector (5 downto 0);
	Signal Addr2  : std_logic_vector (5 downto 0);
	Signal F1 : std_logic_vector (2 downto 0);
	Signal F2 : std_logic_vector (2 downto 0);
begin
	Decodeur : entity work.Decodeur(a_Decodeur) port map (Key, Enable, F1, F2);

	CompteurBin1 : entity work.counter(samplingCounter) port map (CLK, F1, Addr1);
	CompteurBin2 : entity work.counter(samplingCounter) port map (CLK, F2, Addr2);

	SinTable1 : entity work.table_sin(behavioral) port map (Addr1, RESET, CLK, Sin1);
	SinTable2 : entity work.table_sin(behavioral) port map (Addr2, RESET, CLK, Sin2);

	Additionneur : entity work.Additionneur(a_additionneur) port map (Sin1, Sin2, Sum)

	Pwm : entity work.pwm(behavioral) port map (Sum, CLK, RESET, DTMF_OUT);
end architecture behavioral;
