library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity shifter_array is
	Port(din : in std_logic_vector(15 downto 0);
		C : in std_logic_vector(7 downto 0);		--how much ur shifting and what direction
		hilo : in std_logic;		--whether starting from msb or lsb	
		x : in std_logic;		--arithmetic or logical
		dout : out std_logic_vector(31 downto 0));
end shifter_array;

Architecture behav of shifter_array is
	signal zero_fill : std_logic_vector(15 downto 0) := "0000000000000000";
	signal one_fill : std_logic_vector(15 downto 0) := "1111111111111111";
	--signal shifting_number : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	--signal unsign_val : std_logic_vector(7 downto 0) := "00000000";
	--signal test : unsigned(31 downto 0) := "00000000000000000000000000000000";
	begin
		process(din, C, hilo, x)
		begin
			if(hilo = '1') then					--1 for high / place number to left occupying msb
				--shifting_number = din & zero_fill;
				if(C >= "10000000") then			--if value is negative/ shift right
					--unsign_val <= not(C); --fix this need to do what i did to shifting_number
					if(x = '1') then			--if arithmetic shift right
						dout <= std_logic_vector(shift_right(signed(din & zero_fill), to_integer(unsigned(not(C))+1)));
					else					--if logic shift right
						dout <= std_logic_vector(shift_right(unsigned(din & zero_fill), to_integer(unsigned(not(C))+1)));
					end if;
				else
					if(x = '1') then			--if arithmetic shift left
						dout <= std_logic_vector(shift_left(signed(din & zero_fill), to_integer(unsigned(C))));
					else					--if logical shift left
						dout <= std_logic_vector(shift_left(unsigned(din & zero_fill), to_integer(unsigned(C))));
					end if;
				end if;
			else
				--shifting_number <= zero_fill & din;
				if(C >= "10000000") then		--if value is negative
					--unsign_val <= not(C);
					if(x = '1') then			--if arithmetic shift right
						if(din(15) = '1') then
							dout <= std_logic_vector(shift_right(signed(one_fill & din), to_integer(unsigned(not(C))+1)));
						else
							dout <= std_logic_vector(shift_right(signed(zero_fill & din), to_integer(unsigned(not(C))+1)));
						end if;
					else					--if logical shift right
						dout <= std_logic_vector(shift_right(unsigned(zero_fill & din), to_integer(unsigned(not(C))+1)));
					end if;
				else
					if(x = '1') then			--if arithmetic shift left
						dout <= std_logic_vector(shift_left(signed(zero_fill & din), to_integer(unsigned(C))));
					else					--if logical shift right
						dout <= std_logic_vector(shift_left(unsigned(zero_fill & din), to_integer(unsigned(C))));
						--test <= shift_left(unsigned(zero_fill & din), 2);
					end if;
				end if;
			end if;
		end process;
	end behav;
