library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pulse_detector_tb is
end pulse_detector_tb;

architecture Behavioral of pulse_detector_tb is
  signal clk          : std_logic := '0';
  signal rst          : std_logic := '0';
  signal pulse        : std_logic;
  signal input_signal : std_logic := '0';
  signal detect_type  : STD_LOGIC_VECTOR(1 downto 0) := "00";

  component pulse_detector
    Port (
      clk           : in std_logic;
      rst           : in std_logic;
      pulse         : out std_logic;
      input_signal  : in std_logic;
      detect_type   : in STD_LOGIC_VECTOR(1 downto 0)
    );
  end component;

begin
  -- Instantiate the pulse_detector entity
  UUT: pulse_detector
    port map (
      clk           => clk,
      rst           => rst,
      pulse         => pulse,
      input_signal  => input_signal,
      detect_type   => detect_type
    );

  -- Clock generation 
process
  begin
      clk <= not clk;
      wait for 10ns / 2;
  end process;

  
process
  begin
    rst <= '1';  -- Initial reset
    wait for 10 ns;
    rst <= '0';  -- Release reset
    wait for 10 ns;

    input_signal <= '0'; detect_type <= "00";  -- Test case for "00"
    wait for 10 ns;

    input_signal <= '1'; detect_type <= "01";  -- Test case for "01"
    wait for 10 ns;

    input_signal <= '0'; detect_type <= "10";  -- Test case for "10"
    wait for 10 ns;

    input_signal <= '1'; detect_type <= "11";  -- Test case for "others"
    wait for 10 ns;

    input_signal <= '0'; detect_type <= "00";  -- Another test case for "00" with rising edge
    wait for 5 ns;
    input_signal <= '1';
    wait for 5 ns;

    wait;
  end process;

end Behavioral;