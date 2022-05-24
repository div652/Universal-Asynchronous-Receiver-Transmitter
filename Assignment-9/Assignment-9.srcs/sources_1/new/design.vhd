library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
				
entity design is
  generic(
    max_elements : natural := 32 --Change this
  );
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
    
--    count: out integer range 0 to max_elements
  );
end design;

architecture Behavioral of design is

type states is (idle, receiving_write, done_write, receiving_read, done_read);
signal state : states := idle;

type ram_type is array (0 to max_elements - 1) of std_logic_vector(15 downto 0);
signal ram : ram_type;

signal head : integer range 0 to max_elements := 0;
signal tail : integer range 0 to max_elements := 0;
signal is_empty: std_logic;
signal is_full: std_logic;
signal element_count : integer range 0 to max_elements := 0;
signal data : std_logic_vector(15 downto 0):= x"0000";

begin
   
    data <= ram(tail);
--    read_data <= data;
    empty <= is_empty;
    full <= is_full;
--    count <= element_count;
    
    process(clk)
        begin
            if rising_edge(clk) then 
            
                case (state) is
                    when idle =>
                        if(write = '1' and is_full = '0') then
                            state <= receiving_write;
                        elsif (read = '1' and is_empty = '0') then
                            state <= receiving_read;
                        else
                            state <= idle;
                        end if;
                        
                    when receiving_write =>
                        ram(head) <= write_data;
                        head <= (head + 1) mod max_elements;
                        state <= done_write;
                        
                    when receiving_read =>
                        tail <= (tail + 1) mod max_elements;
                        state <= done_read;
                        
                    when done_write =>
                        if(write = '0') then
                            state <= idle;
                        else
                            state <= done_write;
                        end if;
                        
                    when done_read =>
                        if(read = '0') then
                            state <= idle;
                        else
                            state <= done_read;
                        end if;
                     
                    when others =>
                        state <= idle;
                        
                        
                end case;
                            
                 
--                if(write = '1' and is_full = '0') then 
                        
--                            ram(head) <= write_data;
--                            head <= (head + 1) mod max_elements;
                            
--                end if;
                
--                if(read = '1' and is_empty = '0') then
--                    tail <= (tail + 1) mod max_elements;
--                end if;
                
                if(element_count = 0) then empty <= '1'; else empty <= '0'; end if;
                if(element_count = max_elements - 1) then is_full <= '1'; else is_full <= '0'; end if;
                
                if(head < tail) then element_count <= head - tail + max_elements; 
                else element_count <= head - tail;
                end if;
                
            end if;
    end process;    

    Multi_Display : entity work.lightDisplay(structure) port map (data, clk, LED, anode);

end Behavioral;
