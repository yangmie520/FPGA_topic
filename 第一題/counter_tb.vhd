library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_tb is
end counter_tb;
architecture behavioral of counter_tb is
	signal i_clk          :std_logic:='0'; 
	signal i_ret          :std_logic:='0'; 
	signal i_counter1_ud  :std_logic:='1'; 
	signal i_counter1_max :std_logic_vector(3 downto 0) :="1001";
	signal i_counter1_min :std_logic_vector(3 downto 0) :="0000"; 
	signal i_counter2_ud  :std_logic:='0'; 
	signal i_counter2_max :std_logic_vector(3 downto 0) :="0111"; 
	signal i_counter2_min :std_logic_vector(3 downto 0) :="0010";
	signal o_counter1_out :std_logic_vector(3 downto 0) ;
	signal o_counter2_out :std_logic_vector(3 downto 0) ;
	
	component counter
		port(
			i_clk          :in  std_logic;
			i_ret          :in  std_logic;
			i_counter1_ud  :in  std_logic;
			i_counter1_max :in  std_logic_vector(3 downto 0);
			i_counter1_min :in  std_logic_vector(3 downto 0);
			o_counter1_out :out std_logic_vector(3 downto 0);
			i_counter2_ud  :in  std_logic;
			i_counter2_max :in  std_logic_vector(3 downto 0);
			i_counter2_min :in  std_logic_vector(3 downto 0);
			o_counter2_out :out std_logic_vector(3 downto 0)
		);
	end component;
	
begin 
	uut: counter 
		port map(
			i_clk          => i_clk,
			i_ret          => i_ret,
			i_counter1_ud  => i_counter1_ud,
			i_counter1_max => i_counter1_max,
			i_counter1_min => i_counter1_min,
			o_counter1_out => o_counter1_out,
			i_counter2_ud  => i_counter2_ud,
			i_counter2_max => i_counter2_max,
			i_counter2_min => i_counter2_min,
			o_counter2_out => o_counter2_out
		);
	i_clk_process: process
	begin
		i_clk <= '0';
		wait for 10 ns;
		i_clk <= '1';
		wait for 10 ns;
	end process;
	
	stim_proc: process
	begin 
		i_ret <= '1';
      wait for 20 ns;
      i_ret <= '0';
		
		wait for 200 ns;
      i_counter1_ud <= '0';
		
		wait for 200 ns;
      i_counter2_ud <= '1';
		
		wait;
	end process;
end behavioral;