
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_Std.all;

entity lightDisplay is 
	Port ( 
    		Number : in std_logic_vector(15 downto 0);
    		Clk : in std_logic;
    		btnL : in std_logic;
    		btnR : in std_logic;
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
    signal  digit_A : std_logic:='1';
    signal digit_B : std_logic:='0';
    signal digit_C : std_logic:='0'; 
    signal digit_D : std_logic:='1'; 
    signal counter  : integer :=0;
    signal counter_new : integer := 0 ; 
    signal counter_2 : integer := 0 ;
    signal Sampled_number : std_logic_vector(15 downto 0) :=x"0000";
    signal Entered_Number : std_logic_vector(15 downto 0) := x"0000"; 
    signal state2 : integer := 0 ; 
   
    
    begin 
    	process(clk)  
    	
    	  variable position :integer:=0 ;
    	  variable brightness : std_logic_vector(7 downto 0);
    	  type btness is array (3 downto 0) of integer  ; 
    	  variable brightness0123 : btness := (0,0,0,0);
--    	  variable brightness0 : integer := 0 ; -- least significant number 
--    	  variable brightness1 : integer := 0 ;
--    	  variable brightness2 : integer := 0 ;
--    	  variable brightness3 : integer := 0 ; -- most significant number (leftmost)
    	 
    	  
    	  
          
        	begin 
            
            		
               if(Clk'event  and rising_Edge(clk)) then 
                    counter<= ((counter+1)) ;
                    
                    
                    
                    counter_new<= ((counter) / 524288) mod 4  ;
                    state2 <= ((counter)/524288) mod 1024 ; 
                    counter_2 <= ((counter/16384)mod 32) ;
                    end if ; 
                    
                       position := (state2/256) ; 
    
               		case (counter_new) is 
                    	when 0 => if(counter_2<brightness0123(3)) then digit_A<=Sampled_Number(15);digit_B<=Sampled_Number(14);digit_C<=Sampled_Number(13);digit_D<=Sampled_Number(12);light_num<=position mod 4 ;else light_num<=4;end if;
                        
                        when 1 =>  if(counter_2<brightness0123(2)) then digit_A<=Sampled_Number(11);digit_B<=Sampled_Number(10);digit_C<=Sampled_Number(9);digit_D<=Sampled_Number(8);light_num<=((position+ 1) mod 4) ;else light_num<=4;end if;
                        when 2 =>  if(counter_2<brightness0123(1)) then digit_A<=Sampled_Number(7);digit_B<=Sampled_Number(6);digit_C<=Sampled_Number(5);digit_D<=Sampled_Number(4);light_num<=((position + 2) mod 4 ) ; else light_num<=4;end if;
                        when others =>   if(counter_2<brightness0123(0)) then digit_A<=Sampled_Number(3);digit_B<=Sampled_Number(2);digit_C<=Sampled_Number(1);digit_D<=Sampled_Number(0);light_num<=((position + 3) mod 4) ;else light_num<=4;end if;
                        end case;
                    
                    if(BtnL='1') then Entered_Number <= Number  ; end if ; 
                    if(state2 = 0) then Sampled_Number <= Entered_Number ; end if ; 
                    
                    if(BtnR='1') then brightness:=Number(7 downto 0) ; end if; 
                    
                    
                    
                    case brightness(7 downto 6) is 
                      
                       when "00" => brightness0123(3) := 2 ; 
                       when  "01" => brightness0123(3) := 5 ; 
                       when  "10" => brightness0123(3) := 10 ; 
                       when  "11" => brightness0123(3) := 31 ; 
                      end case;
                      
                     
                    case brightness(5 downto 4) is 
                      
                       when "00" => brightness0123(2) := 2 ; 
                       when  "01" => brightness0123(2) := 5 ; 
                       when  "10" => brightness0123(2) := 10 ; 
                       when  "11" => brightness0123(2) := 31 ; 
                      end case;
                      
                     case brightness(3 downto 2) is 
                      
                       when "00" => brightness0123(1) := 2 ; 
                       when  "01" => brightness0123(1) := 5 ; 
                       when  "10" => brightness0123(1) := 10 ; 
                       when  "11" => brightness0123(1) := 31 ; 
                      end case;
                      
                     case brightness(1 downto 0) is 
                      
                       when "00" => brightness0123(0) := 2 ; 
                       when  "01" => brightness0123(0) := 5 ; 
                       when  "10" => brightness0123(0) := 10 ; 
                       when  "11" => brightness0123(0) := 31 ; 
                      end case;
                      
                    
                    
--                        for i in 0 to 3 loop 
--                            case brightness(2*i+1 to 2*i) is 
--                                when "00" => brightness0123(i) := 2 ; 
--                                when "01" => brightness0123(i) := 5 ; 
--                                when "10" => brightness0123(i) := 10 ; 
--                                when others => brightness0123(i) := 31 ; 
--                                end case ; 
--                                end loop ; 
            end process;
            
            
            
--            process(clk) is begin 
--                if(BtnL='1') then Entered_Number <= Number  ; end if ; 
--                end process;
--            process(clk) is begin 
--               if(state2 = 0) then Sampled_Number <= Entered_Number ; end if ;
--               end process;
               
	Single_display: entity work.singleDisplay(Design_arch) port map(digit_A , digit_B, digit_C , digit_D ,light_num , LED ,anode);
        
    
    end structure;


---------------------------------------------------------------


--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.numeric_Std.all;

--entity lightDisplay is 
--	Port ( 
--    		Number : in std_logic_vector(15 downto 0);
--    		Clk : in std_logic;
--            LED : out std_logic_vector(6 downto 0);
--           anode : out STD_LOGIC_Vector(3 downto 0));
--end lightDisplay;

--architecture structure of lightDisplay is 
--	component singleDisplay 
--    		 Port ( A : in STD_LOGIC;
--           B : in STD_LOGIC;
--           C : in STD_LOGIC;
--           D : in STD_LOGIC;

--           light_num : in integer;
--           LED : out std_logic_vector(6 downto 0);
--           anode : out STD_LOGIC_Vector(3 downto 0));
--end component singleDisplay;
	
--    signal 	light_num : integer; 
--    signal  digit_A : std_logic;
--    signal digit_B : std_logic;
--    signal digit_C : std_logic; 
--    signal digit_D : std_logic; 
--    signal counter  : integer :=0;
--    signal counter_new : integer := 0 ; 
--    signal counter_2 : integer := 0 ;
--    signal Sampled_number : std_logic_vector(15 downto 0);
--    signal state : integer :=0 ; 
   
    
--    begin 
--    	process(clk)  
--    	  variable useless :std_logic:='0' ;
          
--        	begin 
            
            		
--               if(Clk'event  and rising_Edge(clk)) then 
--                    counter<= ((counter+1)) ;
                    
--                    counter_new<= ((counter) / 524288) mod 4  ;
--                    state <= ((counter)/524288) mod 1024 ; 
--                    counter_2 <= ((counter/16384)mod 32) ;
--                    end if ; 
                    
           
    
--               		case (counter_new) is 
--                    	when 0 => digit_A<=Sampled_Number(15);digit_B<=Sampled_Number(14);digit_C<=Sampled_Number(13);digit_D<=Sampled_Number(12);light_num<=((state/256) mod 4) ;
                        
--                        when 1 =>  if(counter_2<10) then digit_A<=Sampled_Number(11);digit_B<=Sampled_Number(10);digit_C<=Sampled_Number(9);digit_D<=Sampled_Number(8);light_num<=(((state/256) + 1) mod 4) ;else light_num<=4;end if;
--                        when 2 =>  if(counter_2<5) then digit_A<=Sampled_Number(7);digit_B<=Sampled_Number(6);digit_C<=Sampled_Number(5);digit_D<=Sampled_Number(4);light_num<=(((state/256) + 2) mod 4 ) ; else light_num<=4;end if;
--                        when others =>   if(counter_2<2) then digit_A<=Sampled_Number(3);digit_B<=Sampled_Number(2);digit_C<=Sampled_Number(1);digit_D<=Sampled_Number(0);light_num<=(((state/256) + 3) mod 4) ;else light_num<=4;end if;
--                        end case;
                    
--            end process;
            
--            process(state) 
--            begin if(state = 0) then Sampled_number<=Number ; end if; 
--            end process;
            
         
--	Single_display: entity work.singleDisplay(Design_arch) port map(digit_A , digit_B, digit_C , digit_D ,light_num , LED ,anode);
        
    
--    end structure;

---------------------------------


--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.numeric_Std.all;

--entity lightDisplay is 
--	Port ( 
--    		Number : in std_logic_vector(15 downto 0);
--    		Clk : in std_logic;
--            LED : out std_logic_vector(6 downto 0);
--           anode : out STD_LOGIC_Vector(3 downto 0));
--end lightDisplay;

--architecture structure of lightDisplay is 
--	component singleDisplay 
--    		 Port ( A : in STD_LOGIC;
--           B : in STD_LOGIC;
--           C : in STD_LOGIC;
--           D : in STD_LOGIC;

--           light_num : in integer;
--           LED : out std_logic_vector(6 downto 0);
--           anode : out STD_LOGIC_Vector(3 downto 0));
--end component singleDisplay;
	
--    signal 	light_num : integer; 
--    signal  digit_A : std_logic:='1';
--    signal digit_B : std_logic:='0';
--    signal digit_C : std_logic:='0'; 
--    signal digit_D : std_logic:='1'; 
--    signal counter  : integer :=0;
--    signal counter_new : integer := 0 ; 
--    signal counter_2 : integer := 0 ;
--    signal Sampled_number : std_logic_vector(15 downto 0) :="1010101010101010";
--    signal Entered_Number : std_logic_vector(15 downto 0) := "0101010101010101"; 
--    signal BtnA : std_logic := '0' ;
--    signal BtnB : std_logic := '0' ;
--    signal state2 : integer := 0 ; 
   
    
--    begin 
--    	process(clk)  
    	
--    	  variable position :integer:=0 ;
--    	  variable brightness : std_logic_vector(7 downto 0) ;
--    	  type btness is array (3 downto 0) of integer  ; 
--    	  variable brightness0123 : btness := (0,0,0,0);
----    	  variable brightness0 : integer := 0 ; -- least significant number 
----    	  variable brightness1 : integer := 0 ;
----    	  variable brightness2 : integer := 0 ;
----    	  variable brightness3 : integer := 0 ; -- most significant number (leftmost)
    	 
    	  
    	  
          
--        	begin 
            
            		
--               if(Clk'event  and rising_Edge(clk)) then 
--                    counter<= ((counter+1)) ;
                    
                    
                    
--                    counter_new<= ((counter) / 524288) mod 4  ;
--                    state2 <= ((counter)/524288) mod 1024 ; 
--                    counter_2 <= ((counter/16384)mod 32) ;
--                    end if ; 
                    
--                       position := (state2/256) ; 
    
--               		case (counter_new) is 
--                    	when 0 => digit_A<=Sampled_Number(15);digit_B<=Sampled_Number(14);digit_C<=Sampled_Number(13);digit_D<=Sampled_Number(12);light_num<=position mod 4 ;
                        
--                        when 1 =>   digit_A<=Sampled_Number(11);digit_B<=Sampled_Number(10);digit_C<=Sampled_Number(9);digit_D<=Sampled_Number(8);light_num<=((position+ 1) mod 4) ;
--                        when 2 =>   digit_A<=Sampled_Number(7);digit_B<=Sampled_Number(6);digit_C<=Sampled_Number(5);digit_D<=Sampled_Number(4);light_num<=((position + 2) mod 4 ) ; 
--                        when others =>  digit_A<=Sampled_Number(3);digit_B<=Sampled_Number(2);digit_C<=Sampled_Number(1);digit_D<=Sampled_Number(0);light_num<=((position + 3) mod 4) ;
--                        end case;
                    
--                    if(BtnA = '1') then Sampled_Number <= Number  ; end if ;  
                    
                    
--            end process;
            
            
            
         
--	Single_display: entity work.singleDisplay(Design_arch) port map(digit_A , digit_B, digit_C , digit_D ,light_num , LED ,anode);
        
    
--    end structure;
