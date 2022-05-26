library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity timing_circuit is
  Port ( 
  
    clk: in std_logic;
    tx_start: in std_logic;
    rx_full: in std_logic;
    tx_empty: in std_logic;
 
    ld_tx: out std_logic;
    rd_addr: out std_logic_vector(15 downto 0);
    wr_addr: out std_logic_vector(15 downto 0);
    write_en: out std_logic;
    
    done: in std_logic
  );
end timing_circuit;

architecture Behavioral of timing_circuit is

signal head: std_logic_vector(15 downto 0) := x"0000";
signal tail: std_logic_vector(15 downto 0) := x"0000";


begin
    rd_addr <= tail;
    wr_addr <= head;
    process(clk)
        begin
            if(rising_edge(clk) and clk'event) then
                if(tx_empty = '1' and tx_start = '1') then 
                    ld_tx <= '1'; 
                    tail <= tail + "0000000000000001";
                else 
                    ld_tx <= '0'; 
                end if;
                
                if (done = '1') then
                    write_en <= '1';
                    head <= head + "0000000000000001";
                else
                    write_en <= '0';    
                end if;
            end if;
        
    end process;


end Behavioral;
