-- KBD_TST.vhd
---------------------------------------------------
-- Self-Testing PS/2 Keyboard Test bench (c) ALSE
---------------------------------------------------
-- Author : Bert Cuzeau - ALSE - http://www.alse-fr.com
-- No part of this code can be used without the prior
-- written consent of ALSE.
-- This is a simplified model.
-- Compile with '93 option (hex constants...)

  use STD.Textio.all;
library IEEE;
  use IEEE.Std_Logic_1164.all;
  use IEEE.Numeric_std.all;
  use IEEE.Std_Logic_Textio.all;

-------------------
entity Kbd_tst is
  constant Period    : time := 40 ns; -- 25 MHz System Clock
  constant BitPeriod : time := 60 us; -- Kbd Clock is 16.7 kHz max
end;
-------------------

-------------------
architecture Test of Kbd_tst is
-------------------

Component PS2_Ctrl
port( Clk       : in  std_logic; -- System Clock
      Reset     : in  std_logic; -- System Reset
      PS2_Clk   : in  std_logic; -- Keyboard Clock Line
      PS2_Data  : in  std_logic; -- Keyboard Data Line
      DoRead    : in  std_logic; -- From outside when reading the scan code
      Scan_Err  : out std_logic; -- To outside if wrong parity or Overflow
      Scan_DAV  : out std_logic; -- To outside when a scan code has arrived
      Scan_Code : out std_logic_vector(7 downto 0) ); -- scan code
end component;

signal Clk       : std_logic := '0';
signal Reset     : std_logic;
signal PS2_Clk   : std_logic := 'H';
signal PS2_Data  : std_logic := 'H';
signal DoRead    : std_logic := '0';
signal Scan_Err  : std_logic;
signal Scan_DAV  : std_logic;
signal Scan_Code : std_logic_vector(7 downto 0);

signal Succeeded : boolean := true;

type Code_r is
record
  Cod : std_logic_vector (7 downto 0);
  Err : Std_logic;  -- note: '1' <=> parity error
end record;

type Codes_Table_t is array (natural range <>) of Code_r;
constant Codes_Table : Codes_Table_t -- if you need more codes: just add them!
                     := ( (x"A5",'0'), (x"5A",'0'), (x"00",'0'), (x"FF",'0'),
                          (x"12",'0'), (x"34",'0'), (x"56",'1'), (x"56",'0'),
                          (x"78",'0'), (x"BC",'0') );

-- in Verilog, the function below is just : ^V    ;-)
function Even (V : std_logic_vector) return std_logic is
  variable p : std_logic := '0';
begin
  for i in V'range loop p := p xor V(i); end loop; return p;
end function;

-------------------
begin
-------------------

-- Instanciate the UUT (PS/2 Controller) :

UUT: PS2_Ctrl
  port map ( Clk       => Clk,
             Reset     => Reset,
             PS2_Clk   => PS2_Clk,
             PS2_Data  => PS2_Data,
             DoRead    => DoRead,
             Scan_Err  => Scan_Err,
             Scan_DAV  => Scan_DAV,
             Scan_Code => Scan_Code );

-- System Clock & Reset

Clk <= not Clk after (Period / 2);

Reset <= '1', '0' after Period;

-- Keyboard sending Data to the Controller

Emit: process

  procedure SendCode ( D   : std_logic_vector(7 downto 0);
                       Err : std_logic := '0') is
  begin
    PS2_Clk  <= 'H';
    PS2_Data <= 'H';
    -- (1) verify that Clk was Idle (high) at least for 50 us.
    -- this is not coded here.

    wait for (BitPeriod / 2);
    -- Start bit
    PS2_Data <= '0';
    wait for (BitPeriod / 2);
    PS2_Clk  <= '0'; wait for (BitPeriod / 2);
    PS2_Clk  <= '1';
    -- Data Bits
    for i in 0 to 7 loop
      PS2_Data <= D(i);
      wait for (BitPeriod / 2);
      PS2_Clk  <= '0'; wait for (BitPeriod / 2);
      PS2_Clk  <= '1';
    end loop;
    -- Odd Parity bit
    PS2_Data <= Err xor not Even (D);
    wait for (BitPeriod / 2);
    PS2_Clk  <= '0'; wait for (BitPeriod / 2);
    PS2_Clk  <= '1';
    -- Stop bit
    PS2_Data <= '1';
    wait for (BitPeriod / 2);
    PS2_Clk  <= '0'; wait for (BitPeriod / 2);
    PS2_Clk  <= '1';
    PS2_Data <= 'H';
    wait for (BitPeriod * 3);
  end procedure SendCode;

begin -- process Emit
-----
  Wait for BitPeriod;

  -- Send the Test Frames
  for i in Codes_Table'range loop
    SendCode (Codes_Table(i).Cod,Codes_Table(i).Err);
  end loop;
  if not Succeeded then
    report "End of simulation : " & Lf &
           "  There have been errors in the Data / Err read !"
      severity failure;
  else
    report Lf & "  SUCCESSFULL End of simulation : " & Lf &
           "  There has been no (zero) error !" & Lf & Ht
      severity note;
    report "End of Simulation" severity failure;
  end if;

end process Emit;


-- Host reading (& verifying) Data :

Host: process
  variable L : line;
  variable Index : natural := 0;
begin
  wait until Scan_DAV='1';
  wait for 300 * Period;
  DoRead <= '1';
  write (L,now,right,12);
  write (L,Ht&"Scan code read (hex) = ");
  hwrite (L,Scan_Code);
  if Scan_Err='1' then
    write (L,ht&" >>> Scan_Err <<<");
  end if;
  -- Compare with the original Data-Error :
  if   (Scan_Code /= Codes_Table(Index).Cod)
    or (Scan_Err  /= Codes_Table(Index).Err) then
    Succeeded <= False;
    write (L, Ht&"!!! Mismatch !!!");
  end if;
  Index := Index + 1;
  writeline (output,L);
  wait for Period;
  DoRead <= '0';
end process Host;

end Test;

-- Typical Simulation transcript :
--------------------------------
--#    732380 ns  Scan code read (hex) = A5
--#   1602380 ns  Scan code read (hex) = 5A
--#   2472380 ns  Scan code read (hex) = 00
--#   3342380 ns  Scan code read (hex) = FF
--#   4212380 ns  Scan code read (hex) = 12
--#   5082380 ns  Scan code read (hex) = 34
--#   5952380 ns  Scan code read (hex) = 56  >>> Scan_Err <<<
--#   6822380 ns  Scan code read (hex) = 56
--#   7692380 ns  Scan code read (hex) = 78
--#   8562380 ns  Scan code read (hex) = BC
--# ** Note:
--#   SUCCESSFULL End of simulation :
--#   There has been no (zero) error !
--#
--#    Time: 8760 us  Iteration: 0  Instance: /kbd_tst
--# ** Failure: End of Simulation
--#    Time: 8760 us  Iteration: 0  Instance: /kbd_tst


