library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce_tb is
--  Port ( );
end debounce_tb;

architecture Behavioral of debounce_tb is
        constant pulse: time := 30 ns;
        constant wait_time: integer := 10;
        signal button_tb: std_logic;
        signal result_tb: std_logic;
        signal clk_tb: std_logic := '0';
        signal rst_tb: std_logic;        
begin   
    uut: entity work.debounce  
        generic map(fw => 1024,
            stable => 5)
        Port map(clk => clk_tb,
            rst => rst_tb,
            button =>  button_tb,
            result => result_tb);
    
    -- Clock generation process
    clk_tb_gen : process
    begin
            clk_tb <= not clk_tb;
            wait for pulse / 2;
    end process;

    test : process
    begin
        rst_tb <= '1';  -- Assert reset
        wait for pulse;  -- Wait for a while
        rst_tb <= '0';  -- Release reset

        --  button presses
        button_tb <= '1';
        wait for pulse;
        button_tb <= '0';
        wait for pulse;
        
        button_tb <= '1';
        wait for pulse;
        button_tb <= '0';
        wait for pulse;
        
        button_tb <= '1';
        wait for pulse;
        button_tb <= '0';
        wait for pulse;
           
        --stable input 
        button_tb <= '1';
        wait for wait_time * pulse;
        button_tb <= '0';
        wait for wait_time * pulse;
      
        wait;
    end process;
end Behavioral;
