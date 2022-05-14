----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2022 03:03:32
-- Design Name: 
-- Module Name: design - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity design is
    port(
        clk : in std_logic;
        startContinue : in std_logic;
        pause : in std_logic;
        reset : in std_logic;
        LED : out std_logic_vector (6 downto 0);
        anode : out std_logic_vector (3 downto 0)
        
    );
end design;

architecture Behavioral of design is

    component singleDisplay 
    		 Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           C : in STD_LOGIC;
           D : in STD_LOGIC;

           light_num : in integer;
           LED : out std_logic_vector(6 downto 0);
           anode : out STD_LOGIC_Vector(3 downto 0));
end component singleDisplay;

--    signal enable : std_logic := '0';
--    signal counter : integer := 0;
--    signal counter_display : integer := 0;
--    signal counter_decisecond : integer := 0;
--    signal counter_second_ones : integer := 0;
--    signal counter_second_tens : integer := 0;
--    signal counter_minutes : integer := 0;
--    signal deciseconds : integer := 0;
--    signal counter_seconds : integer := 0;
    signal digit_A : std_logic;
    signal digit_B : std_logic;
    signal digit_C : std_logic;
    signal digit_D : std_logic;
    signal light_num : integer;
--    signal second_ones : integer := 0;
--    signal second_tens : integer := 0;
--    signal minutes : integer := 0;
--    signal Time_display : std_logic_vector(15 downto 0) := "0000000000000000";
    
    
begin

    process(clk) 
    variable enable : std_logic := '0';
    variable counter : integer := 0;
    variable counter_display : integer := 0;
    variable counter_decisecond : integer := 0;
    variable counter_second_ones : integer := 0;
    variable counter_second_tens : integer := 0;
    variable counter_minutes : integer := 0;
    variable deciseconds : integer := 0;
    variable counter_seconds : integer := 0;
    variable second_ones : integer := 0;
    variable second_tens : integer := 0;
    variable minutes : integer := 0;
    variable counter2: integer :=0;
    variable Time_display : std_logic_vector(15 downto 0) := "0000000000000000";
        begin
            if(rising_edge(clk) and clk'event) then
                if(reset = '1') 
                then counter := 0; 
                Time_display := "0000000000000000";
               
                end if;
                if(startContinue = '1') then enable := '1'; elsif (pause = '1') then enable := '0'; end if;
--                counter_display := (counter2/400000) mod 4;
                counter_display := (counter2/524288) mod 4;
                counter2 := counter2+1;
                
                if(enable = '1') then 
                counter := counter + 1;
                
                counter_decisecond := counter/8388608; --  now will be changed in 0.83 decisonds
                deciseconds := counter_decisecond mod 10;
                counter_seconds := counter_decisecond/10;
                second_ones := (counter_seconds mod 60) mod 10;
                second_tens := (counter_seconds mod 60) / 10;
                minutes := ((counter_seconds/60));

                
                
                Time_display(15 downto 12) := std_logic_vector(to_unsigned(minutes,4));
                Time_display(11 downto 8) := std_logic_vector(to_unsigned(second_tens,4));
                Time_display(7 downto 4) := std_logic_vector(to_unsigned(second_ones,4));
                Time_display(3 downto 0) := std_logic_vector(to_unsigned(deciseconds,4));
                
                end if;
                
                case(counter_display) is
                    when 0 => 
                        digit_A <= Time_display(15);
                        digit_B <= Time_display(14);
                        digit_C <= Time_display(13);
                        digit_D <= Time_display(12);
                        light_num <= 0;
                        
                    when 1 => 
                        digit_A <= Time_display(11);
                        digit_B <= Time_display(10);
                        digit_C <= Time_display(9);
                        digit_D <= Time_display(8);
                        light_num <= 1;
                    
                    when 2 => 
                        digit_A <= Time_display(7);
                        digit_B <= Time_display(6);
                        digit_C <= Time_display(5);
                        digit_D <= Time_display(4);
                        light_num <= 2;
                        
                    when others => 
                        digit_A <= Time_display(3);
                        digit_B <= Time_display(2);
                        digit_C <= Time_display(1);
                        digit_D <= Time_display(0);
                        light_num <= 3;
                        
                   end case;
                end if;
            
    end process;

    Single_display: entity work.singleDisplay(Design_arch) port map(digit_A , digit_B, digit_C , digit_D ,light_num , LED ,anode);
end Behavioral;
