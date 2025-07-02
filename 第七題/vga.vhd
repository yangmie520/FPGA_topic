library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY VGA IS
  generic(
    h_pixels  : INTEGER  := 800;
    h_fp      : INTEGER  := 56;
    h_pulse   : INTEGER  := 120;
    h_bp      : INTEGER  := 64;
    h_pol     : STD_LOGIC := '1';
    v_pixels  : INTEGER  := 600;
    v_fp      : INTEGER  := 37;
    v_pulse   : INTEGER  := 6;
    v_bp      : INTEGER  := 23;
    v_pol     : STD_LOGIC := '1'
  );
  PORT (
    clk        : IN STD_LOGIC;              -- 100MHz������J
    rst        : IN STD_LOGIC;              -- ���m�H��
    red_out    : OUT STD_LOGIC_VECTOR(3 downto 0);  -- ����H����X
    green_out  : OUT STD_LOGIC_VECTOR(3 downto 0);  -- ���H����X
    blue_out   : OUT STD_LOGIC_VECTOR(3 downto 0);  -- �Ŧ�H����X
    h_sync     : OUT STD_LOGIC;             -- �����P�B�H����X
    v_sync     : OUT STD_LOGIC              -- �����P�B�H����X
  );
END VGA;

ARCHITECTURE behavior OF VGA IS
    CONSTANT h_period : INTEGER := h_pixels + h_fp + h_pulse + h_bp ;
    CONSTANT v_period : INTEGER := v_pixels + v_fp + v_pulse + v_bp ;
    signal h_count : INTEGER RANGE 0 TO h_period - 1 := 0;
    signal v_count : INTEGER RANGE 0 TO v_period - 1 := 0;
    signal pixel_clk : STD_LOGIC := '0';    -- 50MHz ��������
    signal tmp : STD_LOGIC := '0';          -- �{�ɫH���A�Ω�������W
BEGIN

  -- �������W���G�N100MHz�������W��50MHz
  process (clk, rst)
  begin
    if rst = '1' then
      tmp <= '0';
      pixel_clk <= '0';
    elsif rising_edge(clk) then
      tmp <= not tmp;       -- ����tmp�H��
      pixel_clk <= tmp;     -- �Npixel_clk�]��tmp����X
    end if;
  end process;

  -- VGA�H���ͦ��L�{
  process(pixel_clk, rst)
  begin
    if rst = '1' then
      h_count <= 0; 
      v_count <= 0;
      h_sync  <= NOT h_pol;
      v_sync  <= NOT v_pol;
      red_out <= (others => '0');
      green_out <= (others => '0');
      blue_out <= (others => '0');
    elsif rising_edge(pixel_clk) then
      -- �����p�ƾ�
      if h_count < h_period - 1 then
        h_count <= h_count + 1;
      else
        h_count <= 0;
        -- �����p�ƾ�
        if v_count < v_period - 1 then
          v_count <= v_count + 1;
        else
          v_count <= 0;
        end if;
      end if;

      -- �����P�B�H��
      if h_count < h_pixels + h_fp or h_count >= h_pixels + h_fp + h_pulse then
        h_sync <= NOT h_pol;
      else
        h_sync <= h_pol;
      end if;

      -- �����P�B�H��
      if v_count < v_pixels + v_fp or v_count >= v_pixels + v_fp + v_pulse then
        v_sync <= NOT v_pol;
      else
        v_sync <= v_pol;
      end if;

      -- �]�mRGB��X
      if h_count < h_pixels and v_count < v_pixels then
        red_out <= "1111";   -- �b���]�m�A�ݭn��RGB�C��
        green_out <= "1111";
        blue_out <= "1111";
      else
        red_out <= (others => '0');
        green_out <= (others => '0');
        blue_out <= (others => '0');
      end if;
    end if;
  end process;
END behavior;
