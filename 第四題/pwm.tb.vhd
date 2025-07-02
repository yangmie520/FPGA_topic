library IEEE;
use IEEE.std_logic_1164.all;

entity breath_led_tb is
end breath_led_tb;

architecture Behavioral of breath_led_tb is
    signal i_clk   : std_logic := '0';
    signal i_rst   : std_logic := '1';
    signal o_pwm   : std_logic;

    constant CLK_PERIOD : time := 20 ns;
begin
    -- 產生時脈信號
    clk_process : process
    begin
        while true loop
            i_clk <= '0';
            wait for CLK_PERIOD / 2;
            i_clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- 測試初始化
    stimulus_process : process
    begin
        i_rst <= '0';
        wait for 100 ns;
        i_rst <= '1';
        wait;
    end process;

    -- 連接待測元件
    uut : entity work.breath_led
        port map (
            i_clk => i_clk,
            i_rst => i_rst,
            o_pwm => o_pwm
        );
end Behavioral;
