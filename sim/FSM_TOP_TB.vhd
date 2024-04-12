library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_TOP_tb is
--  Port ( );
end FSM_TOP_tb;

architecture Behavioral of FSM_TOP_tb is
    constant clk_freq_tb: integer := 1024;
    constant stable_time_tb: integer := 5;
    constant flash_speed_tb: integer := 1;
    
    component FSM_TOP is 
        generic (
            flash_speed : integer := 23
        );
        Port (
            clk : in STD_LOGIC;
--            nwse : in STD_LOGIC_VECTOR(3 downto 0);
            led : in STD_LOGIC_VECTOR(3 downto 0);
            rgb : out STD_LOGIC_VECTOR(2 downto 0);
            btn : in STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
  
    signal clk_tb: std_logic;
    signal btn_tb, led_tb: std_logic_vector(3 downto 0);
    signal rgb_tb: std_logic_vector(2 downto 0);
    signal n : std_logic_vector(3 downto 0):= "1000";
    signal w : std_logic_vector(3 downto 0):= "0100";
    signal s : std_logic_vector(3 downto 0):= "0010";
    signal e : std_logic_vector(3 downto 0):= "0001";
    
    constant duty_cycle: time := 1ns;
    constant clock_cycle: time := 2 * duty_cycle;
    constant button_pressed: time := clock_cycle;
    constant wait_time: time := 3 * clock_cycle;

begin
    uut: FSM_TOP
        generic map (
            flash_speed => flash_speed_tb
        )
        port map (
            clk => clk_tb,
            btn => btn_tb,
            led => led_tb,
            rgb => rgb_tb
--            nwse => (others => '0') -- Initialize nwse with zeros
        );
   
 process
begin
    clk_tb <= '0';
    wait for 1 ns;  
    loop
        wait for clock_cycle / 2;
        clk_tb <= not clk_tb;
    end loop;
end process;
    
    process
    begin
        btn_tb <= (others => '0');
        clk_tb <= '0';
        wait for button_pressed;

        -- s
        wait for button_pressed;
        btn_tb <= "0010";  
        wait for button_pressed;

        -- w
        btn_tb  <= "0100";  
        wait for button_pressed;

        -- e
        btn_tb <= "0001"; 
        wait for button_pressed;

        -- to w  UNLOCK
        btn_tb <= "0100";  
        wait for button_pressed;
         
        -- w  LOCK
        btn_tb <= "0100";  
        wait for button_pressed;
        
        -- n W1
        wait for button_pressed;
        btn_tb <= "1000";  
        wait for button_pressed;

        -- w W2
        btn_tb <= "0100";  
        wait for button_pressed;

        -- s W3
        btn_tb <= "0010";  
        wait for button_pressed;

        -- to w  ALARM
        btn_tb <= "0100";  
        wait for button_pressed;
         
        -- w  A1
        btn_tb <= "0100";  
        wait for button_pressed;
        
        -- e  RESET -> lock
        wait for button_pressed;
        btn_tb <= "0001";  
        wait for button_pressed;
        
        -- e  R1 from init
        wait for button_pressed;
        btn_tb <= "0001";  
        wait for button_pressed;
        
        -- e  RESET -> lock
        btn_tb <= "0001";  
        wait for button_pressed;
        
        -- s to s1
        wait for button_pressed;
        btn_tb <= "0010";  
        wait for button_pressed;
        
        -- e  R2
        btn_tb <= "0001";  
        wait for button_pressed;
        
        -- e  Reset
        btn_tb <= "0001";  
        wait for button_pressed;

        wait;
    end process ;
end Behavioral;