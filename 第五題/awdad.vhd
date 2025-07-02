library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pingpang_tb is
end pingpang_tb;

architecture Behavioral of pingpang_tb is
    -- ����ŧi
    component pingpang is
        port (
            i_clk    : in std_logic;
            i_rst    : in std_logic;
            i_bl     : in std_logic;
            i_br     : in std_logic;
            o_led    : out std_logic_vector(7 downto 0)
        );
    end component;

    -- ���իH��
    signal i_clk    : std_logic := '0';
    signal i_rst    : std_logic := '0';
    signal i_bl     : std_logic := '0';
    signal i_br     : std_logic := '0';
    signal o_led    : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 20 ns; -- �����g��
begin
    -- �������;�
    clk_gen : process
    begin
        while true loop
            i_clk <= '0';
            wait for CLK_PERIOD / 2;
            i_clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- ��ҤƳQ���椸
    uut : pingpang
        port map (
            i_clk => i_clk,
            i_rst => i_rst,
            i_bl  => i_bl,
            i_br  => i_br,
            o_led => o_led
        );

    -- ���չL�{
    stim_proc : process
    begin
        -- ��l��
        i_rst <= '1';
        wait for 50 ns;
        i_rst <= '0';
        wait for 50 ns;

        -- �����k��������U
        i_br <= '1';
        wait for 100 ns;
        i_br <= '0';
        wait for 180 ns;

        -- ��������������U
        i_bl <= '1';
        wait for 100 ns;
        i_bl <= '0';
        wait for 2160 ns;

        -- �h�����U�k��֥[����
        for i in 0 to 5 loop
            i_br <= '1';
            wait for 100 ns;
            i_br <= '0';
            wait for 200 ns;
        end loop;

        -- �h�����U����֥[����
        for i in 0 to 5 loop
            i_bl <= '1';
            wait for 100 ns;
            i_bl <= '0';
            wait for 200 ns;
        end loop;

        -- ��������
        wait for 1 us;
        wait;
    end process;

end Behavioral;
