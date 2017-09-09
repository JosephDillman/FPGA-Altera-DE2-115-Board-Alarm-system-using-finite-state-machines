LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity TBSystem is
	Port ( CLOCK_50:	in std_logic;
			 SW		:	in unsigned(3 downto 0);
			 KEY 		: in unsigned (3 downto 0);
			 LEDG		: out unsigned(3 downto 0);
			 LEDR		: out unsigned(3 downto 0);
			 HEX0		: out unsigned(6 downto 0);
			 HEX1		: out unsigned(6 downto 0);
			 HEX2		: out unsigned(6 downto 0)	);
End Entity;

Architecture TopLevel of TBSystem is
	Signal ButtonTriggered, SlowClock	: std_logic;
	Signal AlarmOnEd : std_logic;
Begin
	Alr : Entity work.System(DelayArch) Port Map ( 
		ButtonTriggered , SlowClock, SW, 
		LEDG(3), -- delay
		LEDG(0), -- ready
		LEDR(1),
		AlarmOnEd, -- alarmOn
		LEDG(2) -- systemArmd
		);
		
LEDG(1) <= AlarmOnEd;

SlwClk: Entity work.PreScale19 port map( CLOCK_50, SlowClock);
pushbut: Entity work.OnlyOnePulse Port Map( SlowClock, NOT KEY(3), ButtonTriggered );
	
	LEDR(0) <= ButtonTriggered;
			
AlarmTriged: Entity work.Alarm Port Map (AlarmOnEd, CLOCK_50, HEX0, HEX1, HEX2);
		
		
End Architecture TopLevel;