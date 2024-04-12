library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce is
    generic(fw : integer := 50000000;
            stable: integer := 10);
    Port (clk : in std_logic;
          rst: in std_logic;
          button: in std_logic;
          result: out std_logic);
end debounce;

architecture Behavioral of debounce is
    signal debounce_output: std_logic;
    signal max_delay: integer := fw * stable / 1024;
    signal count : integer := 0;
    
begin
    process (clk, rst)
    begin
        -- If reset is falling edge, reset debounce
        if rising_edge(rst) then
            count <= 0;
            debounce_output <= '0';
        elsif rising_edge(clk) then
            if button = '1' then
                if count = max_delay then
                    debounce_output <= '1';
                end if;
                count <= count + 1;
            else
                debounce_output <= '0';
                count <= 0;
            end if;
        end if;
    end process;
    
    result <= debounce_output;
end Behavioral;
