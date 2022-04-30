----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.04.2022 19:12:00
-- Design Name: 
-- Module Name: DesignFile - behaviour
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DesignFile is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           C : in STD_LOGIC;
           D : in STD_LOGIC;
       
--           LEDa : out STD_LOGIC;
--           LEDb : out STD_LOGIC;
--           LEDc : out STD_LOGIC;
--           LEDd : out STD_LOGIC;
--           LEDe : out STD_LOGIC;
--           LEDf : out STD_LOGIC;
--           LEDg : out STD_LOGIC;
           
           LED : out std_logic_vector(6 downto 0);
           anode : out STD_LOGIC_Vector(3 downto 0));
end DesignFile;

architecture Design_arch of DesignFile is
 signal nA , nB , nC , nD : std_logic;
    
		begin 
		    anode <= "1110";
        	nA<=not(A);
            nB<=not(B);
        	nC<=not(C);
        	nD<=not(D);
        
            
--            Zero
            
        	LED(0) <= not((A and nD) or (A and nB and nC) or (nA and B and D) or (nA and C) or (B and C) or (nB and nD));
            
            LED(1) <= not((nA and nB) or (nB and nD) or (nA and nC and nD) or (nA and C and D) or (A and nC and D)) ;
            
            LED(2) <=  not((nA and nC) or (nA and D) or (nC and D) or (nA and B) or (A and nB)) ; 
            LED(3) <= not((A and nC) or (nA and nB and nD) or (nB and C and D) or (B and nC and D) or (B and C and nD)); 
            LED(4) <= not((nB and nD) or (C and nD) or (A and C) or (A and B)) ; 
            LED(5) <= not((nA and B and nC) or (B and nD) or (A and nB) or (A and C) or (nC and nD)) ; 
            LED(6) <= not((nB and C) or (C and nD) or (A and nB) or (A and D) or (nA and B and nC)); 
	
    end Design_arch;