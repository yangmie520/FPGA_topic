library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test is
end test;

architecture behavior of test is

    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal count : STD_LOGIC_VECTOR(3 downto 0);

    component counter_0_to_9
        Port ( clk    : in  STD_LOGIC;
               reset  : in  STD_LOGIC;
               count  : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

begin
    
    uut: counter_0_to_9 Port map (clk => clk, reset => reset, count => count);

    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    stimulus_process : process
    begin
        reset <= '1';
        wait for 20 ns;  
        reset <= '0'; 
        wait for 1000 ns; 
        reset <= '1';  
        wait for 20 ns;
        reset <= '0';
        wait;
    end process;

end behavior;
