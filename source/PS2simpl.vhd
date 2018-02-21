-- PS2SIMPL.vhd
-- ---------------------------------------------
-- Simplest PS/2 application
-- ---------------------------------------------
-- (c) ALSE - http://www.alse-fr.com
--
LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;

-- ---------------------------------------------
    Entity PS2SIMPL is
-- ---------------------------------------------
      Port ( Clk      : In  std_logic;
             Reset    : In  std_logic;
             D7SEG_L  : Out std_logic_vector (1 to 7);
             D7SEG_H  : Out std_logic_vector (1 to 7);
             PS2_Data : In  std_logic;
             PS2_Clk  : In  std_logic;
             nLED     : Out std_logic );
end PS2SIMPL;

-- ---------------------------------------------
    Architecture SCHEMATIC of PS2SIMPL is
-- ---------------------------------------------
  component SEVENSEG
     Port (    Data : in  std_logic_vector (3 downto 0);
                Pol : in  std_logic;
             Segout : out std_logic_vector (1 to 7) );
  end component;
  component PS2_CTRL
  Generic ( FILTERSIZE : POSITIVE := 8 );
     Port (     Clk : in  std_logic;
             DoRead : in  std_logic;
            PS2_Clk : in  std_logic;
           PS2_Data : in  std_logic;
              Reset : in  std_logic;
          Scan_Code : out std_logic_vector (7 downto 0);
           Scan_DAV : out std_logic;
           Scan_Err : out std_logic );
  end component;

  signal Gnd,Vcc : std_logic;
  signal LED     : std_logic;
  signal DoRead  : std_logic;
  signal Code    : std_logic_vector (7 downto 0);

begin
  Gnd <= '0';  Vcc <= '1';

  PS2_CTRL_i : PS2_CTRL
    Generic Map ( FILTERSIZE => 8 )
    Port Map ( Clk=>Clk, Reset=>Reset, DoRead=>DoRead,
               PS2_Clk=>PS2_Clk, PS2_Data=>PS2_Data,
                Scan_Code=>Code, Scan_DAV=>DoRead, Scan_Err=>LED );

  -- Note: use Pol=>Gnd if display is active high type.
  Dec7SegL : SEVENSEG
     Port Map ( Data => Code(3 downto 0), Pol=>Vcc, Segout => D7SEG_L );

  Dec7SegH : SEVENSEG
     Port Map ( Data => Code(7 downto 4), Pol=>Vcc, Segout => D7SEG_H );

  nLED <= not LED; -- Note: remove the "not" if nLED is active high

end SCHEMATIC;
