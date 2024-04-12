library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pulse_detector is
    Port (
        clk           : in std_logic;
        rst           : in std_logic;
        pulse         : out std_logic;
        input_signal  : in std_logic;
        detect_type   : in STD_LOGIC_VECTOR(1 downto 0) := "00"
    );
end pulse_detector;

 architecture Behavioral of pulse_detector is
    signal r0_input  : std_logic;
    signal r1_input  : std_logic;
    
begin
    process (clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                r0_input <= '0';
                r1_input <= '0';
            else
                r0_input <= input_signal;
                r1_input <= r0_input;
            end if;
        end if;
    end process;

--detecting rissing and falling edges
    process (detect_type, r0_input, r1_input)
    begin
        case detect_type is
            when "00" =>
                pulse <= not r1_input and r0_input;
            when "01" =>
                pulse <= not r0_input and r1_input;
            when "10" =>
                pulse <= r0_input xor r1_input;
            when others =>
                pulse <= '0';
        end case;
    end process;

end Behavioral; 