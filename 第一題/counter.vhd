library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity counter is
    port(
        i_clk         : in  std_logic;
        i_ret         : in  std_logic;
        i_counter1_ud : in  std_logic;
        i_counter1_max: in  std_logic_vector(3 downto 0);
        i_counter1_min: in  std_logic_vector(3 downto 0);
        o_counter1_out: out std_logic_vector(3 downto 0);
        i_counter2_ud : in  std_logic;
        i_counter2_max: in  std_logic_vector(3 downto 0);
        i_counter2_min: in  std_logic_vector(3 downto 0);
        o_counter2_out: out std_logic_vector(3 downto 0)
    );
end counter;

architecture Behavioral of counter is
    signal counter1 : unsigned(3 downto 0) := (others => '0');
    signal counter2 : unsigned(3 downto 0) := (others => '0');
begin
    process(i_clk, i_ret)
    begin
        if(i_ret = '1') then
            counter1 <= to_unsigned(to_integer(unsigned(i_counter1_min)), 4); 
        else
            if(rising_edge(i_clk)) then
                if(i_counter1_ud = '1') then
                    if( counter1 < unsigned(i_counter1_max)) then
                        counter1 <= counter1 + 1;
                    else
                        counter1 <= unsigned(i_counter1_min);
                    end if;
                else
                    if( counter1 > unsigned(i_counter1_min)) then
                        counter1 <= counter1 - 1;
                    else
                        counter1 <= unsigned(i_counter1_max);
                    end if;
                end if;
            end if;
        end if;
    end process;

    process(i_clk, i_ret)
    begin
        if(i_ret = '1') then
            counter2 <= to_unsigned(to_integer(unsigned(i_counter2_min)), 4);  
        else
            if(rising_edge(i_clk)) then
                if(i_counter2_ud = '1') then
                    if(counter2  <  unsigned(i_counter2_max)) then
                        counter2 <= counter2 + 1;
                    else
                        counter2 <= unsigned(i_counter2_min);
                    end if;
                else
                    if(counter2  >  unsigned(i_counter2_min)) then
                        counter2 <= counter2 - 1;
                    else
                        counter2 <= unsigned(i_counter2_max);
                    end if;
                end if;
            end if;
        end if;
    end process;

    o_counter1_out <= std_logic_vector(counter1);
    o_counter2_out <= std_logic_vector(counter2);

end Behavioral;
