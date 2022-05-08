
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_Std.all;

entity lightDisplay is 
	Port ( 
    		Number : in std_logic_vector(15 downto 0);
    		Clk : in std_logic;
            LED : out std_logic_vector(6 downto 0);
           anode : out STD_LOGIC_Vector(3 downto 0));
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
	
    signal 	light_num : integer; 
    signal  digit_A : std_logic;
    signal digit_B : std_logic;
    signal digit_C : std_logic; 
    signal digit_D : std_logic; 
    signal counter  : integer :=0;
    signal counter_new : integer := 0 ; 
    signal counter_2 : integer := 0 ;
    signal Sampled_number : std_logic_vector(15 downto 0);
   
    
    begin 
    	process(clk)  
    	  variable position : integer:= 0 ;
    	  variable state2 : integer := 0;
        	begin 
            
            		
               if(Clk'event  and rising_Edge(clk)) then 
                    counter<= ((counter+1)) ;
                    
                    counter_new<= ((counter) / 400000) mod 4  ;
                    state2 := ((counter)/400000) mod 1024 ; 
                    counter_2 <= ((counter/10000)mod 32) ;
                    end if ;     
               if(state2 = 0) then Sampled_number<=Number ; end if;
               
               position := (state2/256) mod 4 ; 
               
               		case (counter_new  ) is  -- this loop tells which digit to display
                    	when 0 => digit_A<=Sampled_Number(15);digit_B<=Sampled_Number(14);digit_C<=Sampled_Number(13);digit_D<=Sampled_Number(12);
                        
                        when 1 =>  digit_A<=Sampled_Number(11);digit_B<=Sampled_Number(10);digit_C<=Sampled_Number(9);digit_D<=Sampled_Number(8);
                        when 2 => digit_A<=Sampled_Number(7);digit_B<=Sampled_Number(6);digit_C<=Sampled_Number(5);digit_D<=Sampled_Number(4);
                        when others =>  digit_A<=Sampled_Number(3);digit_B<=Sampled_Number(2);digit_C<=Sampled_Number(1);digit_D<=Sampled_Number(0);
                        end case;
                    
                    case(position) is   -- this loop tells where to display and for how much time
                        when 0 =>  -- display starting fron 1st light (ie. leftmost digit in display is the 1st digit)
                            case (counter_new) is 
                             when 0 => light_num<= 0 ;  -- display for maxtime 
                             when 1 => if(counter_2<10) then light_num <=1 ; else light_num<=4 ; end if ;
                             when 2 => if(counter_2<5) then light_num <=2 ; else light_num<=4 ; end if ;
                             when others => if(counter_2<2) then light_num <=3 ; else light_num<=4 ; end if ; -- for mintime 
                             
                            end case;
                             
                        when 1 =>  -- display starting from 2nd light  (ie. leftmost digit in display is the last digit)
                            case (counter_new) is  
                             
                             when 0 => if(counter_2<2) then light_num <=3 ; else light_num<=4 ; end if ;
                             when 1 => light_num<= 0 ;
                             when 2 =>  if(counter_2<10) then light_num <=1 ; else light_num<=4 ; end if ; -- mintime is with 3rd digit of number
                             when others => if(counter_2<5) then light_num <=2 ; else light_num<=4 ; end if ; -- max time now is with the 4th digit in the number as it will be at first place
                             
                            end case;
                        when 2 =>  -- display starting from 3rd light ( ie. leftmost digit in display is 3rd digit)
                            case (counter_new) is 
                             
                            
                             when 0 => if(counter_2<5) then light_num <=2 ; else light_num<=4 ; end if ;
                             when 1 => if(counter_2<2) then light_num <=3 ; else light_num<=4 ; end if ;
                             when 2 => light_num<= 0 ; -- max time is with the 3rd digit 
                             when others => if(counter_2<10) then light_num <=1 ; else light_num<=4 ; end if ;
                             
                            end case;
                            
                        when others => -- display starting from 4th light (ie. leftmost digit in display is 2nd digit)
                            case (counter_new) is 
                             
                            
                            
                             when 0 => if(counter_2<10) then light_num <=1 ; else light_num<=4 ; end if ;-- min time is with first digit
                             when 1 =>  if(counter_2<5) then light_num <=2 ; else light_num<=4 ; end if ; -- max time is with second digit
                             when 2 => if(counter_2<2) then light_num <=3 ; else light_num<=4 ; end if ;
                             when others => light_num<= 0 ; 
                            end case;
                        end case;
              
                        
            end process;
            

 
            
         
	Single_display: entity work.singleDisplay(Design_arch) port map(digit_A , digit_B, digit_C , digit_D ,light_num , LED ,anode);
        
    
    end structure;