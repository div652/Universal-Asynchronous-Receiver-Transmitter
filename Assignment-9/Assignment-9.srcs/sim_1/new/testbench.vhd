-- simulate for 25 us 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_Std.all;
-- import MyTypes::*;
entity testbench is 
end entity testbench ;


architecture mytest of testbench is 
 signal test_clk:  std_logic:='0';
    
   signal test_write:  std_logic:='0';
   signal test_write_data:  std_logic_vector(15 downto 0);
    
     signal test_read: std_logic;
--    read_data: out std_logic_vector(15 downto 0);
    
     signal test_empty:  std_logic:='1';
     signal test_full:  std_logic:='0';
    
     signal test_LED:  std_logic_vector(6 downto 0):="1000000";
     signal test_anode:  std_logic_vector(3 downto 0);
    
component design is 
	Port ( 
    clk: in std_logic;
    
    write: in std_logic;
    write_data: in std_logic_vector(15 downto 0);
    
    read: in std_logic;
--    read_data: out std_logic_vector(15 downto 0);
    
    empty: out std_logic;
    full: out std_logic;
    
    LED: out std_logic_vector(6 downto 0);
    anode: out std_logic_vector(3 downto 0)

--      data_out : out std_logic_vector(15 downto 0)
    
--    count: out integer range 0 to max_elements
  );
    
end component design;
          
begin
DUT : 
design port map(test_clk, test_write ,test_write_data, test_read,test_empty ,test_full , test_LED , test_anode);


process 
 begin 
 	for i in 0 to 8400 loop 
    	test_clk <= not(test_clk);
        wait for 5 ns ; -- this will simulate for 42 us . 
    end loop ;  
        wait ;
    end process; 
    -- 1.04166 us 
----------------------------------------
    -------------------
    
process 
begin 
test_write <='0' ;  
wait for 2300 ns ; -- 2.3 us

-- at 2.3
test_write <= '1'; 
wait for 1 us ; -- this is two clock cycles . 

-- at 3.3
test_write <='0'; 
wait for 5 us ;

-- at 8.3

test_write <='1'; wait for 10 ns ; 
test_write <='0'; wait for 50 ns;
test_write <='1'; wait for 20 ns ; 
test_write <='0'; wait for 40 ns;
test_write <='1'; wait for 1 us;

--at 9.4
test_write <='0' ;
wait for 12 us; 

-- at 21.4
test_write <='1';
wait for 0.6 us;

-- at 22
test_write <='0' ; 
wait for 12 us; 

-- at 34 
test_write <='1'; 
wait for 2 us;

-- at 36 
test_write<='0';
wait;

end process;

process
begin
test_read<='0'; wait for 12.2 us;

--at 12.2 us

test_read<='1'; wait for 14 ns;
test_read<='0'; wait for 50 ns;
test_read<='1'; wait for 20 ns;
test_read<='0'; wait for 100 ns;
test_read<='1'; wait for 13 ns;
test_read<='0'; wait for 203 ns;

--at 12.6
test_read<='1'; wait for 3 us;

-- at 15.6 
test_Read<='0'; wait for 8 us;

-- at 23.6
test_read<='1'; wait for 70 ns;
test_read<='0';wait for 330 ns;
test_read<='1'; wait for 2 us;

-- at 26 
test_read<='0'; wait for 3 us ;

-- at 29 
test_read<='1'; wait for 2 us;

-- at 31 
test_read<='0';  wait for 7 us;

-- at 38
test_read<='1'; wait for 2 us;

-- at 40
test_read<='0'; wait;


end process;

process 
begin 
test_write_Data <=x"0000"; wait for 2 us;

--at 2 us; 
test_write_Data <=x"1234"; wait for 2 us;

-- at 4 us;
test_write_Data<=x"0000" ; wait for 4 us;

--at 8 us;
test_write_data<=x"FADA"; wait for 12 us;

--at 20 us 
test_write_data<=x"D11E"; wait for 3 us;

-- at 23 us 
test_write_data<=x"0000"; wait for 10 us;

-- at 33 us
test_write_data<=x"1357"; wait for 3 us;

-- at 36 us
test_write_data<=x"0000"; wait ;
end process;




end mytest;
