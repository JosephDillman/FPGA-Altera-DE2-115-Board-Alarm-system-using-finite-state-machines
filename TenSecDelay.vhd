LIBRARY ieee;
USE ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity TenSecDelay is
	Port ( clk, load		:	in std_logic;
			 TC      :  out std_logic );
End Entity;

Architecture behav of TenSecDelay is
signal count : unsigned (9 downto 0):= (others => '0' );
signal tempTC, start: std_logic;

Begin

	process(clk, load)
	begin
	if rising_edge(clk) then
		if load = '1' then
			count <= "1111101000";
		elsif count > "0000000000" then
			count <= count -1;
		else
			count <= count;
		end if ;
	end if;
end process;
		
TC <= '1' when count > "0000000000" else '0';

End behav;
		