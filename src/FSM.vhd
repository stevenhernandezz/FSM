library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FSM is
    generic(flash_speed: integer := 23);
    Port (
        clk : in STD_LOGIC;
        nwse : in STD_LOGIC_VECTOR(3 downto 0);
        led : out STD_LOGIC_VECTOR(3 downto 0);
        rgb : out STD_LOGIC_VECTOR(2 downto 0)
    ); 
end FSM;
  
architecture Behavioral of FSM is
    type states is (reset, lock, s1, s2, s3, w1, w2, w3, unlock, alarm, a1, r1, r2, r3);
    signal current_state: states;
    signal led_reg : STD_LOGIC_VECTOR(3 downto 0);
    signal rgb_reg : STD_LOGIC_VECTOR(2 downto 0);
    signal count_flash, count_flash2 : INTEGER := 0;
    

  
begin

    process(clk)
    begin
        if rising_edge(clk) then
            case current_state is
            when lock =>
                if nwse(1) = '1' then
                    current_state <= s1;
                elsif (nwse = "0100" or nwse = "1000") then
                    current_state <= w1;
                elsif nwse(0) = '1' then
                    current_state <= r1;
                else
                    current_state <= lock;
                end if;

            when s1 =>
                if nwse(2) = '1' then
                    current_state <= s2;
                elsif (nwse = "0010" or nwse = "1000") then
                    current_state <= w2;
                elsif nwse(0) = '1' then
                    current_state <= r2;
                else
                    current_state <= s1;
                end if;
                
                when s2 =>--e
                    if nwse(0) = '1' then
                        current_state <= s3;
                    elsif (nwse = "0010" or nwse = "1000" or nwse = "0100") then
                        current_state <= w3;
                    else
                        current_state <= s2;
                    end if;

                when s3 => --w
                    if nwse(2) = '1' then
                        current_state <= unlock;
                    elsif (nwse = "0010" or nwse = "1000" or nwse = "0100") then
                        current_state <= alarm;
                    elsif nwse(0) = '1' then
                        current_state <= reset;
                     else
                        current_state <= s3;
                    end if;
                
                when r1 =>
                    if nwse(0) = '1' then
                        current_state <= reset;
                    elsif (nwse = "0010" or nwse = "0100" or nwse = "1000") then
                        current_state <= w2;
                    else 
                        current_state <= r1;
                    end if;

                when r2 =>
                    if nwse(0) = '1' then
                        current_state <= reset;
                    elsif (nwse = "0010" or nwse = "0100" or nwse = "1000") then
                        current_state <= w3;
                    else
                        current_state <= r2;
                    end if;

                when r3 =>
                    if nwse(0) = '1' then
                        current_state <= reset;
                    elsif (nwse = "0010" or nwse = "0100" or nwse = "1000") then
                        current_state <= alarm;
                    else
                        current_state <= r2;
                    end if;

                when reset =>
                    current_state <= lock;
                    
                when unlock =>
                    if (nwse = "0010" or nwse = "0100" or nwse = "1000" or nwse = "0001" ) then
                        current_state <= lock;
                    end if;

                when w1 =>
                    if nwse(0) = '1' then
                        current_state <= r2;
                    elsif (nwse = "1000" or nwse = "0100" or nwse = "0010") then
                        current_state <= w2;
                    end if;

                when w2 =>
                    if nwse(0) = '1' then
                        current_state <= r3;
                    elsif (nwse = "1000" or nwse = "0100" or nwse = "0010") then
                        current_state <= w3;
                    end if;

                when w3 =>
                    if (nwse = "1000" or nwse = "0100" or nwse = "0010" or nwse = "0001") then
                        current_state <= alarm;
                    end if;
 
                when alarm =>
                    if (nwse = "0100") then
                        current_state <= a1;
                    else
                        current_state <= alarm;
                    end if;

                when a1 =>
                    if (nwse = "0001") then
                        current_state <= reset;
                    elsif (nwse = "0010" or nwse = "0100" or nwse = "1000") then
                        current_state <= alarm;
                    else
                        current_state <= a1;
                    end if;

                when others =>
                    current_state <= lock;

            end case;
        end if;
    end process;
 
 --rgb setup
    process (current_state)
    begin
        case current_state is
            when reset =>
                rgb <= "000";
                led <= "0000";

            when lock =>
                rgb <= "001";
                led <= "0000";

            when s1 | w1 | r1 =>
                rgb <= "010";
                led <= "0001";

            when s2 | w2 | r2 =>
                rgb <= "100";
                led <= "0011";

            when s3 | w3 | r3 =>
                rgb <= "011";
                led <= "0111";

            when unlock =>
                rgb <= "111";
                led <= led_reg;

            when alarm | a1 =>
                rgb <= rgb_reg;
                led <= "1111";

            when others =>
                rgb <= "000";
                led <= "XXXX";  
        end case;
    end process;

--flashing led setup
    process (clk)
    begin
        if rising_edge(clk) then
            if current_state = unlock then
                count_flash <= count_flash + 1;
                if count_flash = 0 then
                    led_reg <= not led_reg;
                end if;
            end if;

            if current_state = alarm then
                count_flash <= count_flash + 1;
                if count_flash = 0 then
                    led_reg(2) <= not led_reg(2);
                end if;
            end if;

            if current_state = a1 then
                count_flash2 <= count_flash2 + 1;
                if count_flash2 = 0 then
                    rgb_reg(2) <= not rgb_reg(2);
                end if;
            end if;

            if current_state /= unlock and current_state /= alarm and current_state /= a1 then
                led_reg <= "0000";
                rgb_reg <= "000";
                count_flash <= 0;
                count_flash2 <= 0;
            end if;
        end if;
    end process;

end Behavioral; 