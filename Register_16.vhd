library ieee;
use ieee.std_logic_1164.all;

Entity register_16_bit is
	Port(din : in std_logic_vector(15 downto 0);
		dout : out std_logic_vector(15 downto 0);
		load : in std_logic;
		clk : in std_logic);	
end register_16_bit;

Architecture behav of register_16_bit is
	Signal storage : std_logic_vector(15 downto 0);
		begin
			process(din, load, clk)
			begin
				if(clk'event and clk = '1' and load = '1') then
					storage <= din;
				elsif(clk'event and clk = '0') then
					dout <= din;
				end if;
			end process;
		end behav;
