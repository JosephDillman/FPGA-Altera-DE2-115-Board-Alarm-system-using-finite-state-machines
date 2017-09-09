LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity System is
	Port ( ARM, Clock			  :	in std_logic;
			 Doors				  :	in unsigned(3 downto 0);
			 DelayLED			  :	buffer std_logic;
			 ReadyLED           :	buffer std_logic;
			 DelayLEDOut		  :	out std_logic;
          AlarmOn, SysArmed  :   out std_logic );
End Entity;

Architecture DelayArch of System is
	Type StateSystem is (UnreadySt, ReadySt, ArmedSt, TriggeredSt, DelayedArmedSt, DelayedTriggeredSt);
	Signal CurrentSt, NextSt	: StateSystem;
	Signal Ready, Delay, CheckDelay			: std_logic;
	Signal TriggerDelay, EnableDelay			: std_logic;
	Signal EnableDelayP1, EnableDelayP2		: std_logic;
	Signal SlowClock								: std_logic;
Begin

-- Ready Condition
Ready <= NOT Doors(0) AND NOT Doors(1) AND NOT Doors(2) AND NOT Doors(3);

CheckDelay <= '1' when (NextSt = DelayedArmedSt) OR (NextSt = DelayedTriggeredSt) else '0';
DoDelay: Entity work.OnlyOnePulse Port Map ( Clock, CheckDelay, TriggerDelay );
MakeDelay: Entity work.TenSecDelay Port Map ( Clock, TriggerDelay, Delay);

DelayLEDOut <= Delay;

NextLogic: Process( Clock, CurrentSt, ARM, Ready )
	Begin
	if rising_edge(Clock) then
		CurrentSt <= NextSt;
	end if;
	Case CurrentSt is
		when UnreadySt =>
			if Ready = '1' then 
				NextSt <= ReadySt;
			else
				NextSt <= UnreadySt;
			end if;
			
		when ReadySt =>
			if Ready = '0' then
				NextSt <= UnreadySt;
			elsif READY = '1' AND ARM = '1' then
				NextSt <= DelayedArmedSt;
			else
				NextSt <= ReadySt;
			end if;
			
		when DelayedArmedSt =>
			if ARM = '1' then
				NextSt <= ReadySt;
			elsif Delay = '1' then
				NextSt <= DelayedArmedSt;
			else
				NextSt <= ArmedSt;
			end if;
				
		when ArmedSt =>
			if Ready = '1' AND ARM = '1' then
				NextSt <= ReadySt;
			elsif Ready = '0' then
				NextSt <= DelayedTriggeredSt;
			else
				NextSt <= ArmedSt;
			end if;
			
		when DelayedTriggeredSt =>
			if ARM = '1' AND Ready = '1' then
				NextSt <= ReadySt;
			elsif ARM = '1' AND Ready = '0' then
				NextSt <= UnreadySt;
			elsif Delay = '1' then
				NextSt <= DelayedTriggeredSt;
			else
				NextSt <= TriggeredSt;
			end if;
			
		when TriggeredSt =>
			if ARM = '1' AND Ready = '1' then
				NextSt <= ReadySt;
			elsif ARM = '1' AND Ready = '0' then
				NextSt <= UnreadySt;
			else
				NextSt <= TriggeredSt;
			end if;
		end case;
	end Process NextLogic;

	-- Output Logic
   AlarmOn <= '1' when CurrentSt = TriggeredSt else '0';
   SysArmed <= '1' when CurrentSt = ArmedSt else '0';
	ReadyLED <= '1' when CurrentSt = ReadySt else '0';
	DelayLED <= '1' when (CurrentSt = DelayedArmedSt) OR (CurrentSt = DelayedTriggeredSt) else '0';

End Architecture DelayArch;

Architecture Basic of System is
	Type StateSystem is (UnreadySt, ReadySt, ArmedSt, TriggeredSt);
	Signal CurrentSt, NextSt	: StateSystem;
	Signal Ready					: std_logic;
Begin

Ready <= NOT Doors(0) AND NOT Doors(1) AND NOT Doors(2) AND NOT Doors(3);
ReadyLED <= Ready;

MoveState: Process(Clock)
Begin
	if rising_edge(Clock) then
		CurrentSt <= NextSt;
	end if;
End Process MoveState;

NextLogic: Process( CurrentSt, ARM, Ready )
	Begin
	Case CurrentSt is
		when UnreadySt =>
			if Ready = '1' then 
				NextSt <= ReadySt;
			else
				NextSt <= UnreadySt;
			end if;
			
		when ReadySt =>
			if Ready = '0' then
				NextSt <= UnreadySt;
			elsif READY = '1' AND ARM = '1' then
				NextSt <= ArmedSt;
			else
				NextSt <= ReadySt;
			end if;
				
		when ArmedSt =>
			if Ready = '1' AND ARM = '1' then
				NextSt <= ReadySt;
			elsif Ready = '0' then
				NextSt <= TriggeredSt;
			else
				NextSt <= ArmedSt;
			end if;
			
		when TriggeredSt =>
			if ARM = '1' AND Ready = '1' then
				NextSt <= ReadySt;
			elsif ARM = '1' AND Ready = '0' then
				NextSt <= UnreadySt;
			else
				NextSt <= TriggeredSt;
			end if;
		end case;
	end Process NextLogic;

   AlarmOn <= '1' when CurrentSt = TriggeredSt else '0';
   SysArmed <= '1' when CurrentSt = ArmedSt else '0';

End Architecture Basic;
