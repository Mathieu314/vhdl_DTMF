Library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity Reference_Design is port (
--Inputs
  CLK: in std_logic;
  Reset: in std_logic;
  PS2_Clk : in std_logic;
  PS2_Data : in std_logic;
  
--Output
  DTMF_OUT: out std_logic
);
end entity Reference_Design;

Architecture behavioral of Reference_Design is
    
  --Input for IP_PS/2 and output of Decode Clavier
  signal DoRead : std_logic;
 
  --Outputs from IP PS/2 and inputs to Decode Clavier
  signal Scan_Err : std_logic;
  signal Scan_DAV : std_logic;
  signal data_in : std_logic_vector ( 7 downto 0);
  
  --Outputs from Decode Clavier and inputs to IP_DTMF
  signal Key: std_logic_vector( 3 downto 0);
  signal Enable : std_logic; 
  
Begin 
  
  IP_PS2: entity work.PS2_Ctrl(Plain_Wrong) port map (CLK, Reset, PS2_Clk, PS2_Data, DoRead, Scan_Err, Scan_DAV, data_in);
  Decode_Clavier: entity work.DecodeClavier(a_DecodeClavier) port map (Scan_Dav, Scan_Err, data_in, CLK, Reset, Key, Enable, DoRead);
  IP_DTMF: entity work.IP_DTMF(behavioral√) port map (CLK, Reset, Key, Enable, DTMF_OUT);
    
end architecture behavioral; 
  

  