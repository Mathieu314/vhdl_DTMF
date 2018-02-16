
--This is the file containing the code for the binary counter
--It's purpose is to generate a tick signaling that we should access the memory to fetch the next corresponding sine value
--It has the following missions: Read a frequency
--						                    	Genrate a tick flaging the sampling frequency
--							                   Generate an adress for the sine Table with every sampling flag
--							                   Gives out this adress
--                               reloops
Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;


Entity counter is
	port (
		clk: in std_logic;        --According to the card's manuel it has a frequency of 60MHz
		genericF: in std_logic_vector(2 downto 0);
		adresse: out std_logic_vector(5 downto 0)
		);
end counter;

architecture samplingCounter of counter is 

	subtype digit is integer range 0 to 100000;

	signal buff , genericDiv : digit; 		             --buff is a counter with which we will be waiting for the right rising edge to sample
																		               --genericDiv will contain the corresponding division for the given DTMF frequency
																  
	signal tick: std_logic;                             --tick is a signal 64 times faster then the signal we need to generate at the end, it flags the sampling frequency
	signal buffAdress : std_logic_vector( 5 downto 0) := "000000";  --buffAdress is the signal that will contain the adress we need to give out
	
	begin
	
	
		--buffAdress<="000000"; 
		--tick<='0';    --we initially set our tick to 0
		
		--This block will give us the corresponding division that corresponds to the given frequency ( the so called genericF )
		fetchDiv : process(genericF)
		begin
		  case genericF is
		    --the Low frequencies
		    when "000" => genericDiv<=1345;
		    when "001" => genericDiv<=1217;
		    when "010" => genericDiv<=1100;
		    when "011" => genericDiv<=996;
		    --the high frequencies
		    when "100" => genericDiv<=775;
		    when "101" => genericDiv<=701;
		    when "110" => genericDiv<=634;
		    when "111" => genericDiv<=574;
		    when others => genericDiv<=0;
		  end case;
	  end process fetchDiv;
		      
		
		
		
		
		
		
		--All of the followung processes will take in DAC_st as it is a validation bit
		
		sampleSignal : process( clk ) 
		-- This process will give us the sampling frequency
		-- It will give us a new "clock" that has the frequency of a signal 64 times faster than genericF 
		
		begin
		
		if ( clk'EVENT and clk='1' ) then
		  
			if ( buff = genericDiv*60/64 ) then
				buff<=0;   --we've done a full cycle and we need to restart the counting
				tick<='1';
			else 
				buff<=buff + 1;
				tick<='0';
			end if;
		end if;
		
		end process sampleSignal;
		
		
		
		
		
		
		
		
		buildSignal : process( tick )
		--This process will slow down the sampeling frequency 64 times
		--It will build a signal that has the frequency of genericF
		--It will give out an adresse through out one periode of the signal
		
		begin
		
		--should there be a for loop here?? 
	   
		if (tick'EVENT and tick='1') then
			if (buffAdress = "111111" ) then --equivalent to checking if buffAdress=63 , we can see this as a flag for reaching the end of one period of genericF
				buffAdress<="000000";         --we finished sampling on one periode , we reset
			else
				buffAdress<=buffAdress + "000001";
			end if;
		end if;
		
		end process buildSignal;
		
		
		
		

		sendOut : Process (buffAdress) 
		--This process sends out the output data (in this case it's Adresse)
		--The output data changes every time buffAdress changes
		begin
				Adresse <= buffAdress;
		end process sendOut;
		
	
		
		
end architecture samplingCounter;