library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VGA is
    generic(
                H_RES     : INTEGER  := 800;
                H_FP      : INTEGER  := 56;
                H_SYNC    : INTEGER  := 120;
                H_BP      : INTEGER  := 64;
                H_POL     : STD_LOGIC := '1';
	
                V_RES     : INTEGER  := 600;
                V_FP      : INTEGER  := 37;
                V_SYNC    : INTEGER  := 6;
                V_BP      : INTEGER  := 23;
                V_POL     : STD_LOGIC := '1'
    );
  port (
                i_clk      : IN STD_LOGIC;              -- 100MHz������J
		        i_rst      : IN STD_LOGIC;              -- ���m�H��
                o_red      : OUT STD_LOGIC_VECTOR(3 downto 0);  -- ����H����X
                o_green    : OUT STD_LOGIC_VECTOR(3 downto 0);  -- ���H����X
                o_blue     : OUT STD_LOGIC_VECTOR(3 downto 0);  -- �Ŧ�H����X
                o_h_sync   : OUT STD_LOGIC;             -- �����P�B�H����X
                o_v_sync   : OUT STD_LOGIC;              -- �����P�B�H����X
                bar_l_x    : IN INTEGER;
                bar_l_y    : IN INTEGER;
                bar_r_x    : IN INTEGER;
                bar_r_y    : IN INTEGER;
                circle_center_x : IN INTEGER;
                circle_center_y : IN INTEGER
                
	);
end VGA;

architecture Behavior of VGA is
    constant H_TOTAL : INTEGER := H_RES + H_FP  + H_SYNC + H_BP ;
    constant V_TOTAL : INTEGER := V_RES + V_FP + V_SYNC + V_BP ;
    signal   h_count : INTEGER range 0 to H_TOTAL - 1 := 0;
    signal   v_count : INTEGER range 0 to V_TOTAL - 1 := 0;
    signal   pixel_clk : STD_LOGIC := '0';     -- 50MHz ��������
    signal   clk_div   : STD_LOGIC := '0';      -- �{�ɫH���A�Ω�������W
    CONSTANT x1 : INTEGER := 400;  CONSTANT y1 : INTEGER := 100;
    CONSTANT x2 : INTEGER := 227;  CONSTANT y2 : INTEGER := 400;
    CONSTANT x3 : INTEGER := 573;  CONSTANT y3 : INTEGER := 400;
    
    function area(xa, ya, xb, yb, xc, yc : INTEGER) return INTEGER is
	begin
		return abs(xa * (yb - yc) + xb * (yc - ya) + xc * (ya - yb));
	end function;
begin

    -- �������W���G�N100MHz�������W��50MHz
    process (i_clk, i_rst)
    begin
        if i_rst = '1' then
            clk_div <= '0';
            pixel_clk <= '0';
        elsif rising_edge(i_clk) then
            clk_div <= not clk_div;       -- ����clk_div�H��
            pixel_clk <= clk_div;     -- �Npixel_clk�]��clk_div����X
        end if;
    end process;

    -- �����p�ƾ� (h_count)
    process (pixel_clk, i_rst)
    begin
        if i_rst = '1' then
            h_count <= 0;
        elsif rising_edge(pixel_clk) then
            if h_count < H_TOTAL - 1 then
                h_count <= h_count + 1;
            else
                h_count <= 0;
            end if;
        end if;
    end process;

    -- �����p�ƾ� (v_count)
    process (pixel_clk, i_rst)
    begin
        if i_rst = '1' then
            v_count <= 0;
        elsif rising_edge(pixel_clk) then
            if h_count = H_TOTAL - 1 then  -- ������p�ƾ��^��0�ɡA�����p�ƾ��W�[
                if v_count < V_TOTAL - 1 then
                    v_count <= v_count + 1;
                else
                    v_count <= 0;
                end if;
            end if;
        end if;
    end process;

    -- �����P�B�H���ͦ�
    process (h_count)
    begin
        if i_rst = '1' then
            o_h_sync <= NOT H_POL;
        elsif h_count < H_RES + H_FP or h_count >= H_RES + H_FP + H_SYNC then
            o_h_sync <= NOT H_POL ;
        else
            o_h_sync <= H_POL ;
        end if;
    end process;

    -- �����P�B�H���ͦ�
    process (v_count)
    begin
        if i_rst = '1' then
            o_v_sync <= NOT V_POL;
        elsif v_count < V_RES + V_FP or v_count >= V_RES + V_FP + V_SYNC then
            o_v_sync <= NOT V_POL;
        else
            o_v_sync <= V_POL;
        end if;
    end process;

    -- RGB�C���X�]�m
    process (h_count, v_count)
    begin
        if i_rst = '1' then
            o_red   <= "0000";
            o_green <= "0000";
            o_blue  <= "0000";
        elsif (h_count < H_RES and v_count < V_RES) then
        if ((((h_count-circle_center_x)*(h_count-circle_center_x))+((v_count-circle_center_y)*(v_count-circle_center_y))) <100) then
            o_red   <= "1111";
            o_green <= "1111";
            o_blue  <= "0000";
		elsif((h_count>(bar_r_x))and (h_count<(bar_r_x+15)))and((v_count>(bar_r_y))and (v_count<(bar_r_y+140))) then
			o_red   <=  "0000";
			o_green <=  "0000";
			o_blue  <=  "0000";
		elsif((h_count>(bar_l_x))and (h_count<(bar_l_x+15)))and((v_count>(bar_l_y))and (v_count<(bar_l_y+140))) then
			o_red   <= "1111";
			o_green <= "0000";
			o_blue  <= "0000";
		else
			o_red   <= "1111";
			o_green <= "1111";
			o_blue  <= "1111";
	    end if;
      else
        o_red   <= (others => '0');
        o_green <= (others => '0');
        o_blue  <= (others => '0');
      end if;
    end process;


end Behavior;