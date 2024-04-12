library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FSM_TOP is
  generic (
    clk_freq    : integer := 50000000;
    stable_time : integer := 10;
    flash_speed : integer := 23  -- Please provide an appropriate value for flash_speed
  );
  port (
    clk            : in  STD_LOGIC;
    LED            : out  STD_LOGIC_VECTOR(3 downto 0);
    rgb            : out STD_LOGIC_VECTOR(2 downto 0);
    btn            : in  std_logic_vector(3 downto 0)
  );
end FSM_TOP;

architecture Behavioral of FSM_TOP is

    component FSM is
    generic (
      flash_speed : integer := 23
    );
    port (
      clk  : in STD_LOGIC;
      nwse : in STD_LOGIC_VECTOR(3 downto 0);
      led  : out STD_LOGIC_VECTOR(3 downto 0);
      rgb  : out STD_LOGIC_VECTOR(2 downto 0)
    );
  end component;
   
  -- Declare the debounce module component
  component debounce
    generic (
        fw          : integer;
        stable : integer
    );
    port (
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        button : in  STD_LOGIC;
        result : out STD_LOGIC
        -- pulse  : out STD_LOGIC
    );
end component;

--   Declare the pulse_detector module component
  component pulse_detector
    port (
      clk           : in  STD_LOGIC;
      rst           : in  STD_LOGIC;
      input_signal  : in  STD_LOGIC;
      pulse  : out STD_LOGIC
    );
  end component;

  signal btn_debounce  : std_logic_vector(3 downto 0);
  signal btn_pulse     : std_logic_vector(3 downto 0);

begin
  -- Instantiate debounce modules in a generate loop
  debounce_insts: for i in 0 to 3 generate
    uut_debounce: debounce
      generic map (
         fw    => clk_freq,
        stable => stable_time
      )
      port map (
        clk          => clk,
        rst          => '0',  -- Assuming no reset for now
        button       => btn(i),
        result       => btn_debounce(i)
--        pulse => btn_pulse(i) -- No need to connect output_pulse for debounce
      );
  end generate debounce_insts;

  -- Instantiate pulse_detector modules in a generate loop
  pulse_detector_insts: for i in 0 to 3 generate
    uut_pulse_detector: pulse_detector
      port map (
        clk          => clk,
        rst          => '0',  -- Assuming no reset for now
        input_signal => btn_debounce(i),
        pulse => btn_pulse(i)
      );
  end generate pulse_detector_insts;

 UUT_FSM: FSM
    generic map (
      flash_speed => flash_speed
    )
    port map (
      clk  => clk,
      nwse => btn_pulse, -- Assuming btn_pulse is the correct signal for the nwse port
      led  => led,
      rgb  => rgb
    );
end Behavioral;