library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity barrel_shifter_top is
	port(dmd : inout std_logic_vector(15 downto 0);
		r : inout std_logic_vector(15 downto 0);
		C : in std_logic_vector(7 downto 0);
		hilo : in std_logic;
		x : in std_logic;
		load : in std_logic_vector(2 downto 0);
		sel : in std_logic_vector(1 downto 0);		--dont need all these
		ctr : in std_logic_vector(3 downto 0);
		clk : in std_logic);
end barrel_shifter_top;

architecture behav of barrel_shifter_top is
	component register_16_bit
		Port(din : in std_logic_vector(15 downto 0);
			dout : out std_logic_vector(15 downto 0);
			load : in std_logic;
			clk : in std_logic);
	end component;

	component mux_2to1_16_bit
		Port(sel : in std_logic;
			din0 : in std_logic_vector(15 downto 0);
			din1 : in std_logic_vector(15 downto 0);
			dout : out std_logic_vector(15 downto 0));
	end component;

	component shifter_array
		Port(din : in std_logic_vector(15 downto 0);
			C : in std_logic_vector(7 downto 0);		--how much ur shifting and what direction
			hilo : in std_logic;		--whether starting from msb or lsb	
			x : in std_logic;		--arithmetic or logical
			dout : out std_logic_vector(31 downto 0));
	end component;

	component tri_state_buffer_16
		Port(input : in std_logic_vector(15 downto 0);
			enable : in std_logic;
			output : out std_logic_vector(15 downto 0));
	end component;

	signal si_out : std_logic_vector(15 downto 0);
	signal sr1_and_sr0_in : std_logic_vector(31 downto 0);
	signal sr1_out : std_logic_vector(15 downto 0);
	signal sr0_out : std_logic_vector(15 downto 0);
	signal si_or_r_mux_out : std_logic_vector(15 downto 0);
	signal sr0_or_sr1_mux_out : std_logic_vector(15 downto 0);
	

	begin
		si_reg : register_16_bit port map(dmd, si_out, load(0), clk);
		sr1_reg : register_16_bit port map(sr1_and_sr0_in(31 downto 16), sr1_out, load(1), clk);
		sr0_reg : register_16_bit port map(sr1_and_sr0_in(15 downto 0), sr0_out, load(2), clk);

		shifter_block : shifter_array port map(si_or_r_mux_out, C, hilo, x, sr1_and_sr0_in);

		sr0_or_sr1_mux : mux_2to1_16_bit port map(sel(0), sr1_out, sr0_out, sr0_or_sr1_mux_out);
		si_or_r_mux : mux_2to1_16_bit port map(sel(1), si_out, r, si_or_r_mux_out);
		
		sr0_or_sr1_mux_tri : tri_state_buffer_16 port map(sr0_or_sr1_mux_out, ctr(0), dmd);
		si_tri : tri_state_buffer_16 port map(si_out, ctr(1), dmd);
		sr0_tri : tri_state_buffer_16 port map(sr0_out, ctr(2), r);
		sr1_tri : tri_state_buffer_16 port map(sr1_out, ctr(3), r);

	end behav;




