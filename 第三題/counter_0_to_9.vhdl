library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 


entity counter_0_to_9 is
    Port ( clk    : in  STD_LOGIC;
           reset  : in  STD_LOGIC;
           count  : out STD_LOGIC_VECTOR(3 downto 0)
           );
end counter_0_to_9;

architecture Behavioral of counter_0_to_9 is
    signal counter : STD_LOGIC_VECTOR(3 downto 0) := "0000"; 
    signal up_down : STD_LOGIC := '1';  
begin

    process(clk, reset)
    begin
        if reset = '1' then
            counter <= "0000";  
            up_down <= '1';  
        elsif rising_edge(clk) then
            if up_down = '1' then
                if counter = "1001" then
                    up_down <= '0';  
                else
                    counter <= counter + 1;  
                end if;
            else
                if counter = "0000" then
                    up_down <= '1';  
                else
                    counter <= counter - 1; 
                end if;
            end if;
        end if;
    end process;

    
    count <= counter;

end Behavioral;
