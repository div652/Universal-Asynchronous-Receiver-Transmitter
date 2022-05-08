
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_Std.all;

entity lightDisplay is  
	Port ( 
    		Number : in std_logic_vector(15 downto 0);  -- this is the 16bit input taken from the user , groups of four are interpreted as single hex number
    		Clk : in std_logic;  -- this is the device clock
            LED : out std_logic_vector(6 downto 0); -- led output , mapped to the cathodes
           anode : out STD_LOGIC_Vector(3 downto 0)); -- anode output
end lightDisplay;

architecture structure of lightDisplay is 
	component singleDisplay 
    		 Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           C : in STD_LOGIC;
           D : in STD_LOGIC;

           light_num : in integer;
           LED : out std_logic_vector(6 downto 0);
           anode : out STD_LOGIC_Vector(3 downto 0));
end component singleDisplay;
	
    signal 	light_num : integer;  -- parameter passed to component signle display to tell which of the four digits to display
    signal  digit_A : std_logic;
    signal digit_B : std_logic;
    signal digit_C : std_logic; 
    signal digit_D : std_logic; 
    signal counter  : integer :=0; 
    signal counter_new : integer := 0 ; 
    
    begin 
    	process(clk)  
         
        	begin 
            
            		
               if(Clk'event  and rising_Edge(clk)) then 
                    counter<= ((counter+1)) ;   -- increments by 1 after every clock cycle
                    counter_new<= ((counter) / 400000 )mod 4;   -- this is cyclic , goes 0 .. 1 .. 2 .. 3 changes after 4 ms  = 400000 * 10 ns
                    
                    
                    
               
               
               		case (counter_new) is   --  for every 4 ms period display a the digits one by one
                    	when 0 => digit_A<=Number(15);digit_B<=Number(14);digit_C<=Number(13);digit_D<=Number(12);light_num<=(0) ;  -- when 0 display first digit (for 4 ms)
                        
                        when 1 => digit_A<=Number(11);digit_B<=Number(10);digit_C<=Number(9);digit_D<=Number(8);light_num<=(1) ;-- when 0 display first digit (for 4 ms)
                        when 2 => digit_A<=Number(7);digit_B<=Number(6);digit_C<=Number(5);digit_D<=Number(4);light_num<=(2) ;-- when 0 display first digit (for 4 ms)
                        when others => digit_A<=Number(3);digit_B<=Number(2);digit_C<=Number(1);digit_D<=Number(0);light_num<=(3) ;-- when 0 display first digit (for 4 ms)
                        
                        end case;
                  
                end if;

            end process;
            
         
	Single_display: entity work.singleDisplay(Design_arch) port map(digit_A , digit_B, digit_C , digit_D ,light_num , LED ,anode); -- port mapping
        
    
    end structure;
