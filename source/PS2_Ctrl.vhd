-- PS2_Ctrl.vhd
-- ------------------------------------------------
--   Simplified PS/2 Controller  (kbd, mouse...)
-- ------------------------------------------------
-- Only the Receive function is implemented !
-- (c) ALSE. http://www.alse-fr.com

library IEEE;
  use IEEE.Std_Logic_1164.all;
  use IEEE.Numeric_Std.all;

-- --------------------------------------
    Entity PS2_Ctrl is
-- --------------------------------------
  generic (FilterSize : positive := 8);
  port( Clk       : in  std_logic;  -- System Clock
        Reset     : in  std_logic;  -- System Reset
        PS2_Clk   : in  std_logic;  -- Keyboard Clock Line
        PS2_Data  : in  std_logic;  -- Keyboard Data Line
        DoRead    : in  std_logic;  -- From outside when reading the scan code
        Scan_Err  : out std_logic;  -- To outside : Parity or Overflow error
        Scan_DAV  : out std_logic;  -- To outside when a scan code has arrived
        Scan_Code : out std_logic_vector(7 downto 0) -- Eight bits Data Out
        );
end PS2_Ctrl;

-- --------------------------------------
    Architecture Plain_Wrong of PS2_Ctrl is
-- --------------------------------------
-- Comments : Bad solution !
-- 3 clock domains, no global reset, disguised FSM...
-- There is also a bad problem with the synchronous reset
-- which is not on the right clock domain !
-- Note : the VHDL style has been fixed...

  signal Bit_Cnt    : unsigned (3 downto 0);
  signal Shift_Reg  : std_logic_vector(8 downto 0);
  signal Read_CHAR  : std_logic;
  signal Ready_set  : std_logic;
  signal PS2_Clk_f  : std_logic;
  signal Filter     : std_logic_vector(FilterSize-1 downto 0);

begin

Scan_Err <= '0';  -- not used in this architecture

  -- Clock domain #1 , async reset #1

  process (DoRead, Ready_set)
  begin
    if DoRead = '1' then
      Scan_DAV <= '0';
    elsif rising_edge(Ready_set) then
      Scan_DAV <= '1';
    end if;
  end process;


  -- Clock domain #2, no reset !

-- This process filters the raw clock signal coming from the keyboard
-- using a shift register and two 4-inputs AND gates
-- Implies a 320 ns delay
  Clock_filter : process (Clk)
  begin
    if rising_edge (Clk) then
      Filter <= PS2_Clk & Filter(Filter'high downto 1);
      if Filter = "11111111" then
        PS2_Clk_f <= '1';
      elsif Filter = "00000000" then
        PS2_Clk_f <= '0';
      end if;
    end if;
  end process Clock_filter;

  -- Clock domain #3, partial synchronous reset !
  -- PS2_Data is not resynchronized

  --This process Reads in serial data coming from the keyboard
  process(PS2_Clk_f)
  begin
    if rising_edge (PS2_Clk_f) then
      if RESET = '1' then
        Bit_Cnt  <= (others => '0');
        Read_CHAR <= '0';
      else
        if PS2_Data = '0' and Read_CHAR = '0' then
          Read_CHAR <= '1';
          Ready_set <= '0';
        else
          -- Shift in next 8 data bits to assemble a scan code
          if Read_CHAR = '1' then
            if Bit_Cnt < 9 then
              Bit_Cnt  <= Bit_Cnt + 1;
              Shift_Reg <= PS2_Data & Shift_Reg(8 downto 1);
              Ready_set <= '0';
            else -- End of scan code character, so set flags and exit loop
              Scan_Code <= Shift_Reg (7 downto 0);
              Read_CHAR <= '0';
              Ready_set <= '1';
              Bit_Cnt     <= (others => '0');
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;

end Plain_Wrong;


-- --------------------------------------
    Architecture ALSE_RTL of PS2_Ctrl is
-- --------------------------------------
-- (c) ALSE. http://www.alse-fr.com
-- Author : Bert Cuzeau.
-- Fully synchronous solution, same Filter on PS2_Clk.
-- Still as compact as "Plain_wrong"...
-- Possible improvement : add TIMEOUT on PS2_Clk while shifting
-- Note: PS2_Data is resynchronized though this should not be
-- necessary (qualified by Fall_Clk and does not change at that time).
-- Note the tricks to correctly interpret 'H' as '1' in RTL simulation.

  signal PS2_Datr  : std_logic;

  subtype Filter_t is std_logic_vector(FilterSize-1 downto 0);
  signal Filter    : Filter_t;
  signal Fall_Clk  : std_logic;
  signal Bit_Cnt   : unsigned (3 downto 0);
  signal Parity    : std_logic;
  signal Scan_DAVi : std_logic;

  signal S_Reg     : std_logic_vector(8 downto 0);

  signal PS2_Clk_f : std_logic;

  Type   State_t is (Idle, Shifting);
  signal State : State_t;

begin

Scan_DAV <= Scan_DAVi;

-- This filters digitally the raw clock signal coming from the keyboard :
--  * Eight consecutive PS2_Clk=1 makes the filtered_clock go high
--  * Eight consecutive PS2_Clk=0 makes the filtered_clock go low
-- Implies a (FilterSize+1) x Tsys_clock delay on Fall_Clk wrt Data
-- Also in charge of the re-synchronization of PS2_Data

process (Clk,Reset)
begin
  if Reset='1' then
    PS2_Datr  <= '0';
    PS2_Clk_f <= '0';
    Filter    <= (others=>'0');
    Fall_Clk  <= '0';
  elsif rising_edge (Clk) then
    PS2_Datr <= PS2_Data and PS2_Data; -- also turns 'H' into '1'
    Fall_Clk <= '0';
    Filter   <= (PS2_Clk and PS2_CLK) & Filter(Filter'high downto 1);
    if Filter = Filter_t'(others=>'1') then
      PS2_Clk_f <= '1';
    elsif Filter = Filter_t'(others=>'0') then
      PS2_Clk_f <= '0';
      if PS2_Clk_f = '1' then
        Fall_Clk <= '1';
      end if;
    end if;
  end if;
end process;


-- This simple State Machine reads in the Serial Data
-- coming from the PS/2 peripheral.

process(Clk,Reset)
begin

  if Reset='1' then
    State     <= Idle;
    Bit_Cnt   <= (others => '0');
    S_Reg     <= (others => '0');
    Scan_Code <= (others => '0');
    Parity    <= '0';
    Scan_Davi <= '0';
    Scan_Err  <= '0';

  elsif rising_edge (Clk) then

    if DoRead='1' then
      Scan_Davi <= '0'; -- note: this assgnmnt can be overriden
    end if;

    case State is

      when Idle =>
        Parity  <= '0';
        Bit_Cnt <= (others => '0');
        -- note that we dont need to clear the Shift Register
        if Fall_Clk='1' and PS2_Datr='0' then -- Start bit
          Scan_Err <= '0';
          State <= Shifting;
        end if;

      when Shifting =>
          if Bit_Cnt >= 9 then
            if Fall_Clk='1' then -- Stop Bit
              -- Error is (wrong Parity) or (Stop='0') or Overflow
              Scan_Err  <= (not Parity) or (not PS2_Datr) or Scan_DAVi;
              Scan_Davi <= '1';
              Scan_Code <= S_Reg(7 downto 0);
              State <= Idle;
            end if;
          elsif Fall_Clk='1' then
            Bit_Cnt  <= Bit_Cnt + 1;
            S_Reg <= PS2_Datr & S_Reg (S_Reg'high downto 1); -- Shift right
            Parity <= Parity xor PS2_Datr;
          end if;

      when others => -- never reached
        State <= Idle;

    end case;

    --Scan_Err <= '0'; -- to create an on-purpose error on Scan_Err !

  end if;

end process;

end ALSE_RTL;

