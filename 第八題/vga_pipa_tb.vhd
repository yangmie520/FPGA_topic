library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VGA_pipa_tb is
end VGA_pipa_tb;

architecture Behavioral of VGA_pipa_tb is

    -- Component Declaration
    component VGA_pipa
        port (
            i_clk      : in  std_logic;
            i_rst      : in  std_logic;
            i_sw_l     : in  std_logic;
            i_sw_r     : in  std_logic;
            btn        : in  std_logic;
            o_red      : out std_logic_vector(3 downto 0);
            o_green    : out std_logic_vector(3 downto 0);
            o_blue     : out std_logic_vector(3 downto 0);
            h_sync     : out std_logic;
            v_sync     : out std_logic
        );
    end component;

    -- Testbench Signals
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '1';
    signal sw_l     : std_logic := '0';
    signal sw_r     : std_logic := '0';
    signal btn      : std_logic := '0';
    signal red      : std_logic_vector(3 downto 0);
    signal green    : std_logic_vector(3 downto 0);
    signal blue     : std_logic_vector(3 downto 0);
    signal hsync    : std_logic;
    signal vsync    : std_logic;

    -- Clock period constant
    constant clk_period : time := 10 ns;  -- 100MHz

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: VGA_pipa
        port map (
            i_clk    => clk,
            i_rst    => rst,
            i_sw_l   => sw_l,
            i_sw_r   => sw_r,
            btn      => btn,
            o_red    => red,
            o_green  => green,
            o_blue   => blue,
            h_sync   => hsync,
            v_sync   => vsync
        );

    -- Clock process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initial Reset
        wait for 50 ns;
        rst <= '0';

        -- 模擬右邊球拍向上移動
        sw_r <= '0';
        wait for 2000 ns;
        sw_r <= '1';  -- 向下移動
        wait for 2000 ns;
        sw_r <= '0';

        -- 模擬左邊球拍向上移動
        sw_l <= '0';
        wait for 2000 ns;
        sw_l <= '1';  -- 向下移動
        wait for 2000 ns;
        sw_l <= '0';

        -- 模擬發球按鈕
        btn <= '1';
        wait for 200 ns;
        btn <= '0';

        wait;  -- 停在這裡讓模擬持續
    end process;

end Behavioral;
