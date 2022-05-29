----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.04.2022 19:15:46
-- Design Name: 
-- Module Name: testbench - Behavioral
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



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.std_logic_1164.all;

use ieee.numeric_std.all;


-- import MyTypes::*;
entity testbench is 
end entity testbench ;

architecture mytest of testbench is 
	signal 		A_test :  std_logic;
    signal 		B_test :  std_logic;
    signal         C_test :  std_logic;
    signal         D_test :  std_logic;
    		
--    signal 		LEDa_test :  std_logic; 
--    signal         LEDb_test :  std_logic ; 
--    signal         LEDc_test :  std_logic;
--    signal         LEDd_test :  std_logic;
--    signal         LEDe_test :  std_logic;
--    signal         LEDf_test :  std_logic;
--    signal         LEDg_test :  std_logic;

    signal         LED : std_logic_vector(6 downto 0);
    signal         Anode_test : std_logic_vecto(3 downto 0);

component DesignFile is 
	port (	A : in std_logic;
    		B : in std_logic;
            C : in std_logic;
            D : in std_logic;
    		
--    		LEDa : out std_logic; 
--            LEDb : out std_logic ; 
--            LEDc : out std_logic;
--            LEDd : out std_logic;
--            LEDe : out std_logic;
--            LEDf : out std_logic;
--            LEDg : out std_logic;

            LED : out std_logic_vector(6 downto 0);
            anode: out std_logic_vector(3 downto 0)
    		);
          end component DesignFile;
          
begin
CUT : 
DesignFile port map(A_test,B_test,C_test,D_test , LED ,Anode_test);

--clkwork:
--process 
--begin 
--A_test<='0';
--wait for 8ns;
--A_test<='1';
--wait;
--end process;


--process
--begin 
--B_test<='0';
--wait for 4 ns;

--B_test<='1';
--wait for 4 ns; 

--B_test<='0';
--wait for 4 ns;

--B_test<='1';
--wait for 4 ns;

--wait;

--end process;

--process 
--	begin 
--    	C_test <='0'; 
--        wait for 2 ns;
--        C_test <= '1';
--        wait for 2 ns;
        
--        C_test <='0'; 
--        wait for 2 ns;
--        C_test <= '1';
--        wait for 2 ns;
        
--        C_test <='0'; 
--        wait for 2 ns;
--        C_test <= '1';
--        wait for 2 ns;
        
--        C_test <='0'; 
--        wait for 2 ns;
--        C_test <= '1';
--        wait for 2 ns;
        
        
--    wait;
--    end process;

--process 
--	begin 
--    	D_test <='0'; 
--        wait for 1 ns;
--        D_test <= '1';
--        wait for 1 ns;
        
--        D_test <='0'; 
--        wait for 1 ns;
--        D_test <= '1';
--        wait for 1 ns;
        
--        D_test <='0'; 
--        wait for 1 ns;
--        D_test <= '1';
--        wait for 1 ns;
        
--        D_test <='0'; 
--        wait for 1 ns;
--        D_test <= '1';
--        wait for 1 ns;
        
--        D_test <='0'; 
--        wait for 1 ns;
--        D_test <= '1';
--        wait for 1 ns;
        
--        D_test <='0'; 
--        wait for 1 ns;
--        D_test <= '1';
--        wait for 1 ns;
        
--        D_test <='0'; 
--        wait for 1 ns;
--        D_test <= '1';
--        wait for 1 ns;
        
--        D_test <='0'; 
--        wait for 1 ns;
--        D_test <= '1';
--        wait for 1 ns;
        
--        D_test<='0' ; 
--        wait for 1 ns;
        
--    wait;
--    end process;

end mytest;

