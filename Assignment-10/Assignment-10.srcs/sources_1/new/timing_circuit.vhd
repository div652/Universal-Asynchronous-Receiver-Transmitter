library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity timing_circuit is
  Port ( 
  
    clk: in std_logic;
--    slow_clock: in std_logic;
    tx_start: in std_logic;
    rx_full: in std_logic;
    tx_empty: in std_logic;
    tx_all: in std_logic;
    ld_tx: out std_logic;
    rd_addr: out std_logic_vector(15 downto 0);
    wr_addr: out std_logic_vector(15 downto 0);
    write_en: out std_logic;
    
    done: in std_logic;
    reset: in std_logic
  );
end timing_circuit;

architecture Behavioral of timing_circuit is

signal head: std_logic_vector(15 downto 0) := x"0000";
signal tail: std_logic_vector(15 downto 0) := x"0000";
signal element_count : std_logic_vector(15 downto 0) := x"0000";
signal is_empty: std_logic := '1';
signal is_full: std_logic := '0';
signal transmit_all : std_logic := '0';
signal counter: integer := 0;
begin
    rd_addr <= tail;
    wr_addr <= head;
    process(clk)
        begin
            if(rising_edge(clk) and clk'event) then
            
                if(reset = '1') then
                    head<=head+1;
                    tail <=head+1;
                end if;
            
                if(counter = 500000) then --10ms
                    counter <= 0;
                    if(transmit_all = '1') then
                        if(is_empty = '1') then transmit_all <= '0'; ld_tx <= '0';
                        else
                                tail <= tail + "0000000000000001";
                                if(tail = x"FFFF") then tail <= x"0000"; end if;
                                ld_tx <= '1';
                            
                        end if;
                    end if; 
                else
                    counter <= counter + 1;
                    if(transmit_all = '1') then ld_tx <= '0'; end if;
                end if;
                if(transmit_all = '0') then 
                    if(tx_empty = '1' and tx_start = '1' and is_empty = '0') then 
                        ld_tx <= '1'; 
                        tail <= tail + "0000000000000001";
                        if(tail = x"FFFF") then tail <= x"0000"; end if;
                    else 
                        ld_tx <= '0'; 
                    end if;
                end if;
                
--                if(tx_empty = '1' and transmit_all='1' ) then
--                    ld_tx <= '0';
--                end if;
                if (done = '1' and is_full = '0') then
                    write_en <= '1';
                    head <= head + "0000000000000001";
                    if(head = x"FFFF") then head <= x"0000"; end if;
                else
                    write_en <= '0';    
                end if;
                
                if (tx_all = '1') then
                    transmit_all <= '1';
                end if;
                 
                    
                
                if(head < tail) then element_count <= (head - tail + x"FFFF"); 
                else element_count <= head - tail;
                end if;
                
                if(element_count = x"0000") then is_empty <= '1'; else is_empty <= '0'; end if;
                if(element_count = x"FFFF" - 1) then is_full <= '1'; else is_full <= '0'; end if;
                
            end if;
        
    end process;

end Behavioral;
