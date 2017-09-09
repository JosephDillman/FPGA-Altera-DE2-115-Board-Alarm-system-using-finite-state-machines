LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity OnlyOnePulse is
	Port( Clock, Switch	: in std_logic;
			OneOut		: out std_logic);
End Entity OnlyOnePulse;

Architecture Behave of OnlyOnePulse is
	Signal Q1, Q2	: std_logic := '0';
Begin
	Q1 <= Switch when Rising_Edge(Clock);
	Q2 <= Q1 when Falling_Edge(Clock);
	OneOut <= Switch AND NOT Q2;
End Architecture Behave;