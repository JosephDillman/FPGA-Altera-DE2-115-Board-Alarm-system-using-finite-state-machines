LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity JamesBond is
	Port ( Go		: in std_logic;
			 Digit	: in unsigned(2 downto 0);
			 Clock	: in std_logic;
			 GotCode : out std_logic );
End;

Architecture Behave of JamesBond is
	Signal Password			: unsigned(2 downto 0) := "111";
	Signal Truth, Delay		: std_logic;
Begin
	
MakeDelay: Entity work.TenSecDelay Port Map ( Clock, Go, Delay);

Truth <= '1' when ( Digit = Password ) else '0';

DoDelay: Entity work.OnlyOnePulse Port Map ( Clock, Truth AND Delay, GotCode );
End;
