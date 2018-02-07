Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity table_sin is port (
	ADDRESSE : in std_logic_vector(5 downto 0);
	CLK : in std_logic;
	SIN : in std_logic_vector(5 downto 0)
);
end entity table;

architecture behavioral of table_sin is

begin
	clock: process(CLK)
	begin
		if rising_edge(CLK) then
			
