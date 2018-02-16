
Library IEEE;
use IEEE.std_logic_1164.all;

entity tb_Counter is
end entity tb_Counter ;

architecture tb_BinaryCounter of tb_Counter is

	subtype digit is integer range 0 to 128;
	signal clk: std_logic;
	signal genericF: std_logic_vector ( 2 downto 0);
	signal adress: std_logic_vector ( 5 downto 0);
	
	begin
	  
	  
	  
	  
	T0: entity work.counter(samplingCounter) port map( clk, genericF, adress);
	
	
	
	clockSimulator : process
	begin   
				clk<='0';
				wait for 8 ns;
				clk<='1';
				wait for 8 ns;
	end process clockSimulator;
	
	
	
	test: process
	begin
	  genericF<="010";
	  wait for 300 ms;
	end process test;
	  
	
			
			
			
	end architecture tb_BinaryCounter;
			