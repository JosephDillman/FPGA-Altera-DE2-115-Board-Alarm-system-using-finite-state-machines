LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity Alarm is
	Port ( Enable, Clock	: in std_logic;
			 HEX0, HEX1, HEX2 : out unsigned(6 downto 0) );
End;

Architecture Logic of Alarm is
	Signal Scaler : unsigned(6 downto 0) := (others => '0');
	Signal SlowClock: std_logic;
	Signal HexOut0, HexOut1 : unsigned( 6 downto 0 );
Begin
	slowclk: Entity work.PreScale19 port map( Clock, SlowClock );
   Process( SlowClock, Scaler )
   Begin
	if SlowClock'Event and SlowClock = '1' then
        if Scaler = "0000000" then
            Scaler <= "1100100";
        else
            Scaler <= Scaler - 1;
        end if;
	end if;
   end process;
	
	HEX2 <= HexOut0 when ( Scaler < "0110010" AND Enable = '1') else ( others => '1' );
	Hex1 <= HexOut1 when ( Scaler < "0110010" AND Enable = '1') else ( others => '1' );
	Hex0 <= HexOut1 when ( Scaler < "0110010" AND Enable = '1') else ( others => '1');
	
	U1: Entity work.SegDecoder port map ("1001", HexOut0);
	U2: Entity work.SegDecoder port map ("0001", HexOut1);

End Architecture Logic;