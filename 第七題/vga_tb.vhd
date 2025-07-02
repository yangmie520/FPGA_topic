library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vga_controller is
end tb_vga_controller;

architecture behavior of tb_vga_controller is

  -- �w�q�H���ӳs����Q���ժ��椸�]VGA����^
  signal i_clk    : std_logic := '0';
  signal i_rst    : std_logic := '0';
  signal o_hsync  : std_logic;
  signal o_vsync  : std_logic;
  signal o_red    : std_logic_vector(3 downto 0);
  signal o_green  : std_logic_vector(3 downto 0);
  signal o_blue   : std_logic_vector(3 downto 0);

  -- �]�w 100MHz ����
  constant clk_period : time := 10 ns; -- 100MHz �����g��

begin

  -- ��Ҥ� VGA ���
  uut: entity work.vga_controller
    port map (
      i_clk    => i_clk,
      i_rst    => i_rst,
      o_hsync  => o_hsync,
      o_vsync  => o_vsync,
      o_red    => o_red,
      o_green  => o_green,
      o_blue   => o_blue
    );

  -- �����ͦ�
  clk_process : process
  begin
    i_clk <= '0';
    wait for clk_period / 2;
    i_clk <= '1';
    wait for clk_period / 2;
  end process;

  -- ���չL�{
  stim_proc: process
  begin
    -- ��l���A�A�i�歫�m
    i_rst <= '0';
    wait for 20 ns;
    
    i_rst <= '1';
    wait for 1000 ns;  -- ���ݤ@�q�ɶ��� VGA ����ͦ��H��

    -- ��������
    wait;
  end process;

end behavior;
