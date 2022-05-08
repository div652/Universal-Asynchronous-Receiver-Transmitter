


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all; 


entity singleDisplay is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           C : in STD_LOGIC;
           D : in STD_LOGIC;
           
           light_num : in integer; -- light_num goes from 0 to 3 , 0 lights up left most light , while 3 lights up right most light , 

           
           LED : out std_logic_vector(6 downto 0);
           anode : out STD_LOGIC_Vector(3 downto 0));
end singleDisplay;

architecture Design_arch of singleDisplay is
 signal nA , nB , nC , nD : std_logic;
    
		begin 
		    
        	nA<=not(A);
            nB<=not(B);
        	nC<=not(C);
        	nD<=not(D);
            
            process(light_num) is 
            	
                begin 
                	case light_num is 
                    	when 0 => anode<="0111";
                        when 1 => anode<="1011";
                        when 2 => anode<="1101";
                        when others => anode<="1110";
                    end case; 
            end process; 
               		
        

            
        	LED(0) <= not((A and nD) or (A and nB and nC) or (nA and B and D) or (nA and C) or (B and C) or (nB and nD));
            
            LED(1) <= not((nA and nB) or (nB and nD) or (nA and nC and nD) or (nA and C and D) or (A and nC and D)) ;
            
            LED(2) <=  not((nA and nC) or (nA and D) or (nC and D) or (nA and B) or (A and nB)) ; 
            LED(3) <= not((A and nC) or (nA and nB and nD) or (nB and C and D) or (B and nC and D) or (B and C and nD)); 
            LED(4) <= not((nB and nD) or (C and nD) or (A and C) or (A and B)) ; 
            LED(5) <= not((nA and B and nC) or (B and nD) or (A and nB) or (A and C) or (nC and nD)) ; 
            LED(6) <= not((nB and C) or (C and nD) or (A and nB) or (A and D) or (nA and B and nC)); 
	
    end Design_arch;