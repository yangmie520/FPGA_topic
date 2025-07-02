library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Pingpong_gpio is
    port (
        i_clk   : in std_logic;
        i_rst   : in std_logic;
        i_btn   : in std_logic;
        io_gpio : inout std_logic;
        o_led   : out std_logic_vector(7 downto 0)
    );
end entity;

architecture Behavioral of Pingpong_gpio is
    type fsm_type is ( RECEIVE, SEND, MOVE_R, MOVE_L);
    signal fsm          : fsm_type := RECEIVE;  
    signal move         : std_logic_vector(9 downto 0) := "0000000001";
    signal clk_div      : std_logic_vector(28 downto 0) := (others => '0');
    signal slow_clk     : std_logic;
    signal flag             : std_logic := '1';
    signal gpio_out     : std_logic := 'Z';
    signal gpio_in      : std_logic;
    signal gpio_prev    : std_logic := '0';
    signal recv_edge    : std_logic := '0';

    signal send_pulse   : std_logic := '0';
    signal pulse_counter: integer range 0 to 199 := 0;

begin
	o_led <= move(8 downto 1);
    io_gpio <= gpio_out;
    gpio_in <= io_gpio;
    slow_clk <= clk_div(1);

    -- 除頻器
    process (i_clk, i_rst)
    begin
        if i_rst = '1' then
            clk_div <= (others => '0');
        elsif rising_edge(i_clk) then
            clk_div <= std_logic_vector(unsigned(clk_div) + 1); 
        end if;
    end process;

    -- 上升緣偵測
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if  gpio_in = '1' and gpio_prev = '0' then
                recv_edge <= '1';
            else
                recv_edge <= '0';
            end if;
            gpio_prev <= gpio_in;
        end if;
    end process;

    -- FSM
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            fsm <= RECEIVE;
            gpio_out <= 'Z';
        elsif rising_edge(i_clk) then
            case fsm is               
                when RECEIVE =>
                    if recv_edge = '1' then
                        fsm <= MOVE_L;
                    elsif ((i_btn = '1') and (move = "0000000001")) then
                        fsm <= MOVE_R;
                    end if;
                when MOVE_R =>
                    if move = "1000000000" then
                        fsm <= SEND;
                    end if;
                when SEND =>
                    if pulse_counter = 30 then
                        fsm <= RECEIVE;
                    end if;
                when MOVE_L =>
                    if move = "0000000001"  then
                        if flag = '0' then
                            fsm <= RECEIVE;  
                        end if;
                    elsif (i_btn = '1')then
						if ( move = "0000000010") then
							fsm <= MOVE_R;
						else
						fsm <= RECEIVE; 
                         end if;
                     end if;
                when others =>
                    fsm <= RECEIVE;
            end case;
        end if;
    end process;
    
   
   
    -- LED 控制
    

    -- 球移動邏輯
    process(slow_clk, i_rst)
    begin
        if i_rst = '1' then
            move <= "0000000001";
            flag <= '1';
        elsif rising_edge(slow_clk) then
            if fsm = RECEIVE then
                if ( move = "0000000001") or ( move = "1000000000") then 
                else
                     move <= "0000000001";
                end if;
            elsif fsm = MOVE_R then
                move <=move(8 downto 0) & move(9) ;
            elsif fsm = MOVE_L then
                if flag = '1' then
                    move <= "1000000000";
                    flag <= '0';
                end if;
                move <=move(0) & move(9 downto 1) ;
            end if;
        end if;
    end process;
	


    -- 傳送控制
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            pulse_counter <= 0;
            send_pulse <= '0';
        elsif rising_edge(i_clk) then
            if fsm = SEND then
                if pulse_counter < 30 then
                    pulse_counter <= pulse_counter + 1;
                    send_pulse <= '1';
                else
                    pulse_counter <= 0;
                    send_pulse <= '0';
                end if;
            else
                pulse_counter <= 0;
                send_pulse <= '0';
            end if;
        end if;
    end process;

    -- GPIO 控制輸出
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if fsm = SEND then
                gpio_out <= send_pulse;
            else
                gpio_out <= 'Z';
            end if;
        end if;
    end process;

end Behavioral;
