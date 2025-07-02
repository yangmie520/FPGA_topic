library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bandsuball is
    port (
        i_clk    : in std_logic;          
        i_rst    : in std_logic;         
        i_da1     : in std_logic;  
        i_da2     : in std_logic;  
        o_led    : out std_logic_vector(7 downto 0)  
    );
end bandsuball;

architecture Behavioral of bandsuball is
    -- �w�q�i�վ㪺�������W�����
    
    signal clk_div    : unsigned(27 downto 0) := (others => '0');  -- �������W��
    signal FSM1_state : std_logic_vector(2 downto 0);  -- ���A�����A
    signal LP         : unsigned(3 downto 0) := (others => '0');  
    signal RP         : unsigned(3 downto 0) := (others => '0');  
    signal shift_reg  : std_logic_vector(7 downto 0) := "00000001";
    signal RP_flag    : std_logic := '0';  
    signal LP_flag    : std_logic := '0';  
    signal lfsr_reg   : std_logic_vector(4 downto 0) := "11001";  
    signal ran  : std_logic_vector(1 downto 0);
    signal ra1  : std_logic;
    signal clk_ball  : std_logic;
begin
	
    -- LFSR �]�w�P��s
    process(ra1, i_rst)
    begin
        if i_rst = '1' then
            lfsr_reg <= "11001";  -- ���m LFSR
        elsif rising_edge(ra1) then  -- �ϥα`�� LFSR_TAP
            lfsr_reg <= lfsr_reg(3 downto 0) & (lfsr_reg(4) xor lfsr_reg(0));
        end if;
    end process;
	ran <= lfsr_reg(1 downto 0);
	ra1 <= clk_div(1);
	clk_ball <= clk_div(to_integer(unsigned(ran)) +1);

    -- �������W������s
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            clk_div <= (others => '0');
        elsif rising_edge(i_clk) then
            clk_div <= clk_div + 1;
        end if;
    end process;

    -- FSM ���A�����޿�
    process(i_rst, i_clk)
    begin 
        if i_rst = '1' then
            FSM1_state <= "000";
        elsif rising_edge(i_clk) then 
            case FSM1_state is 
                when "000" =>
                    if i_da2 = '1' then
                        FSM1_state <= "001";
                    end if;
                    o_led <= shift_reg;

                when "001" =>
                    if ((i_da1 = '1') and (shift_reg = "10000000")) then
                        FSM1_state <= "010";
                    elsif ((i_da1 = '1') and (shift_reg /= "10000000")) then
                        FSM1_state <= "100";
                    elsif ((i_da1 = '0') and (shift_reg = "00000000")) then
                        FSM1_state <= "100";
                    end if;
                    o_led <= shift_reg;

                when "010" =>
                    if ((i_da2 = '1') and (shift_reg = "00000001")) then
                        FSM1_state <= "001";
                    elsif ((i_da2 = '1') and (shift_reg /= "00000001")) then
                        FSM1_state <= "011";
                    elsif ((i_da2 = '0') and (shift_reg = "00000000")) then
                        FSM1_state <= "011";
                    end if;
                    o_led <= shift_reg;

                when "011" =>
                    if LP >= "1011" then
                        FSM1_state <= "000";
                    elsif i_da1 = '1' then
                        FSM1_state <= "010";
                    end if;
                    o_led <= std_logic_vector(LP) & std_logic_vector(RP);

                when "100" =>
                    if RP >= "1011" then
                        FSM1_state <= "000";
                    elsif i_da2 = '1' then
                        FSM1_state <= "001";
                    end if;
                    o_led <= std_logic_vector(LP) & std_logic_vector(RP);

                when others =>
                    FSM1_state <= "000";
            end case;
        end if;
    end process;

    -- ����H�s������s
    process(i_rst, clk_ball, i_da1, i_da2)
    begin
        if i_rst = '1' then
            shift_reg <= "00000001";  
                elsif rising_edge(clk_ball) then 
				case FSM1_state is
					when "000" =>
						shift_reg <= "00000001";
					when "001" =>
						shift_reg <= shift_reg(6 downto 0) & '0';
					when "010" =>
						shift_reg <= '0' & shift_reg(7 downto 1);
					when "100" =>
						shift_reg <= "00000001";
					when "011" =>
						shift_reg <= "10000000";
					when others =>
						null;
				end case;
			end if;
    
    end process;

    -- ��s RP
    process(i_rst, i_da2)
    begin
        if i_rst = '1' then
            RP <= "0000";
            RP_flag <= '0';
        elsif rising_edge(i_clk) then
            if (FSM1_state = "100") and (RP_flag = '0') then
                RP <= RP + 1;
                RP_flag <= '1';
            elsif FSM1_state = "000" then
                    RP <= "0000";
            elsif FSM1_state /= "100" then
                RP_flag <= '0'; 
            end if;
        end if;
    end process;

    -- ��s LP
    process(i_rst, i_da1)
    begin
        if i_rst = '1' then
            LP <= "0000";
            LP_flag <= '0';
        elsif rising_edge(i_clk) then
            if (FSM1_state = "011") and (LP_flag = '0') then
                LP <= LP + 1;
                LP_flag <= '1';  
             elsif FSM1_state = "000" then
                    LP <= "0000";    
            elsif FSM1_state /= "011" then
                LP_flag <= '0'; 
            end if;
        end if;
    end process;

end Behavioral;