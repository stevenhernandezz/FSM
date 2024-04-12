library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity timing is
  Port (clock_in : in std_logic;
        clock_out : out std_logic;
        reset_in : in std_logic;
        reset_out : out std_logic;
        locked : out std_logic  );
end timing;

architecture Behavioral of timing is
component clk_wiz_0
    port
      (                                 
        
        clk_out1 : out std_logic;
       
        reset    : in  std_logic;
        locked   : out std_logic;
        clk_in1  : in  std_logic
        );
  end component;
  
    rst_1 : in std_logic;
    locked_s : in std_logic;
    
process(clk_in1)
variable count: integer:=0;
 begin
if reset_in='1' then
    rst_1<='1';
 
elsif (rising_edge(clk_in1)) then   
   if (locked_s = '1') and (count<32) then
        count:= count +1;
       
        rst_1<= '1';
            else 
            rst_1<='0';
     
            end if;
       else  
    
 end if;

 
end process;
reset_out<=rst_1;
locked<= locked_s;
end Behavioral;