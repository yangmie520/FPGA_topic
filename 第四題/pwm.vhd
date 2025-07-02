library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity breath_led is
    port (
        i_clk   : in std_logic;  
        i_rst   : in std_logic;  
        o_pwm   : out std_logic  
    );
end breath_led;

architecture Behavioral of breath_led is
    signal count     : unsigned(7 downto 0) := (others => '0');  
    signal c1        : unsigned(7 downto 0) := to_unsigned(0, 8);  
    signal c2        : unsigned(7 downto 0) := to_unsigned(255, 8);
    signal sw        : std_logic := '1';  
    signal clk_div   : unsigned(1 downto 0) := (others => '0'); 
    signal state     : std_logic := '0';  
begin

    
    process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            clk_div <= (others => '0');
        elsif rising_edge(i_clk) then
            if clk_div(1) = '1' then  
                clk_div <= (others => '0');
            else
                clk_div <= clk_div + 1;
            end if;
        end if;
    end process;

    process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            c1 <= to_unsigned(0, 8);  
            c2 <= to_unsigned(255, 8);
            sw <= '1'; 
            state <= '0';
        elsif rising_edge(i_clk) then
            if clk_div(1) = '1' then
                if state = '0' then
                    if c1 = to_unsigned(255, 8) then  
                        state <= '1';  
                    else
                        c1 <= c1 + 1;
                        c2 <= 255 - unsigned(c1); 
                    end if;
                else
                    if c1 = to_unsigned(0, 8) then  
                        state <= '0'; 
                    else
                        c1 <= c1 - 1;
                        c2 <= 255 - unsigned(c1);  
                    end if;
                end if;
            end if;
        end if;
    end process;

    process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            count <= (others => '0');
            o_pwm <= '0';
        elsif rising_edge(i_clk) then
            if state = '0' then
                if count < c1 then
                    o_pwm <= '1';
                else
                    o_pwm <= '0';  
                end if;
            else
                if count < c2 then
                    o_pwm <= '0';  
                else
                    o_pwm <= '1';  
                end if;
            end if;

            
            if count = to_unsigned(255, 8) then
                count <= (others => '0'); 
            else
                count <= count + 1;
            end if;
        end if;
    end process;

end Behavioral;
