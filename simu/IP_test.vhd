Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_IP is 
end entity tb_IP;

architecture testFinal of tb_IP is
  
  	-- Inputs
	signal CLK : std_logic;
	signal RESET : std_logic;

	-- For decodeClavier
	signal Key : std_logic_vector(3 downto 0);
	signal Enable : std_logic;

	-- Output
	signal DTMF_OUT : std_logic;
	
	begin 
	  
	  T0: entity work.IP_DTMF(behavioral) port map (CLK, RESET, Key, Enable, DTMF_OUT);
	    
	    clockSimulator : process
      	begin   
			   	clk<='0';
			   	wait for 8 ns;
				  clk<='1';
				  wait for 8 ns;
	     end process clockSimulator;
	    
	    
	    testMe : process
	    begin
	      Reset<='0';
	      Enable<= '1';
	      Key<="0101";
	      wait for 10 ms;
	    end process testMe;
	    
	    
end architecture testFinal;