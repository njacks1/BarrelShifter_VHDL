library ieee;
use ieee.std_logic_1164.all;
	Entity mux_2to1_16_bit is
		Port(sel : in std_logic;
			din0 : in std_logic_vector(15 downto 0);
			din1 : in std_logic_vector(15 downto 0);
			dout : out std_logic_vector(15 downto 0));
	end mux_2to1_16_bit;
	
	Architecture Behavioral of mux_2to1_16_bit is
			begin
				process(din0, din1)
					begin
						if (sel = '0') then
							dout <= din0;
						elsif (sel = '1') then
							dout <= din1;
						end if;
				end process;
			end Behavioral;
