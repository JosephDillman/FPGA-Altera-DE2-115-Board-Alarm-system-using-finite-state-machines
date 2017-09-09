Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity PreScale19 is
	Port ( Clock : in std_logic;
			 ClkOut: out std_logic);
End PreScale19;

Architecture behavour of PreScale19 is
	Signal Count, NextCount : unsigned (18 downto 0) := (others => '0' );
Begin
	Process( Clock )
	Begin
		if rising_edge( Clock ) then
			Count <= Count + 1;
		end if;
	end Process;

ClkOut <= Count(18);
End behavour;