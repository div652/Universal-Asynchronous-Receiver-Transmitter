library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
				
entity design is
--  generic(
--    max_elements : natural := 32 --Change this
--  );
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
end design;

architecture Behavioral of design is

--type states is (idle, receiving_write, done_write, receiving_read, done_read);
--signal state : states := idle;

component BRAM
    generic(
        ADDRESS_WIDTH: integer := 8;
        DATA_WIDTH: integer := 16
    );
    port(
        clk: in std_logic;
        w_enable: in std_logic;
        write_address: in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
        read_address: in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
        datain: in std_logic_vector(DATA_WIDTH-1 downto 0);
        dataout: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end component BRAM;

--type ram_type is array (max_elements - 1 downto 0) of std_logic_vector(15 downto 0);
--signal ram : ram_type;
type states is (idle, processing,completed);

signal head : std_logic_vector(7 downto 0):=x"00";
signal tail : std_logic_vector(7 downto 0):=x"00";
signal is_empty: std_logic;
signal is_full: std_logic;
signal element_count : std_logic_vector(7 downto 0) := x"00";
signal data : std_logic_vector(15 downto 0):= x"0000";
signal slow_clock: std_logic := '0';
signal counter : integer := 0;
signal write_en : std_logic := '0';
signal read_en : std_logic := '0';
signal done_read : std_logic := '0';
signal done_write : std_logic := '0';
signal mystate : states := idle ; 

begin
   
   
    myBRAM: entity work.BRAM(Behavioral) generic map(
        ADDRESS_WIDTH => 8,
        DATA_WIDTH =>  16
    )
    port map(
        clk => clk,
        w_enable => write,
        write_address => head,
        read_address => tail,
        datain => write_data,
        dataout => data
    );
--    read_data <= data;
    empty <= is_empty;
    full <= is_full;
--    count <= element_count;
    
    process(clk, write_en, read_en)
        begin
            if rising_edge(clk) then 
                
                if(counter = 2500000) then
                    counter <= 0;
                    slow_clock <= not(slow_clock);
                else
                    counter <= counter + 1;
                end if;
                
                if(head < tail) then element_count <= head - tail + x"FF"; 
                else element_count <= head - tail;
                end if;
                
                if(element_count = x"00") then is_empty <= '1'; else is_empty <= '0'; end if;
                if(element_count = x"FF" - 1) then is_full <= '1'; else is_full <= '0'; end if;
            end if;
    end process;    
    -- if you press two ones in the same clock period then that would be problematic, wait for a whole clock to complete before pressing the button again 
    
    process(slow_clock, write, read)
        begin
            if(rising_edge(slow_clock) and slow_clock'event) then
                if(write = '1') then 
                case (mystate) is 
                    when idle => write_en <= '1';mystate<=processing; 
                    when processing => write_en<='0'; mystate<=completed;
                    when others => write_en<='0';mystate<=completed;
                end case;
            else  -- in each case you go state idle if '0' is encountered on write. 
            -- the only problem to this apprach is that for simultaneous writes/reads you will have to wait
            -- at least one whole slow-clock cycle before pressing the button again else it would not be registered
                write_en <= '0'; mystate <= idle ; 
-- if processing state and write='1' then change state to completed and turn off we 
-- if you are in completed stage ie. we has been ON for one slow cycle now you'll wait for a 0 to go into idle state. 
            end if;
            
            if(read = '1') then 
                case (mystate) is 
                    when idle => read_en <= '1'; mystate<=processing;
                    when processing => read_en<='0' ; mystate<=completed;
                    when others =>read_en<='0' ; mystate<=completed;
                end case;
            else read_en <= '0'; mystate<=idle; 
            end if;
                
                if(write_en = '1' and is_full = '0') then 
--                    ram(head) <= write_data;
                    head <= (head + "00000001");
                            
                end if;
                
                if(read_en = '1' and is_empty = '0') then
--                    data <= ram(tail);
                    tail <= (tail + "00000001");
                end if;
            end if;
    end process;

--    BRAM : entity work.BRAM(Behavioral) port map (clk, write, );
    
    Multi_Display : entity work.lightDisplay(structure) port map (data, clk, LED, anode);

end Behavioral;
