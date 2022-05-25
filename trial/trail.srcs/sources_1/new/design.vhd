library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
				
entity design is
  generic(
    max_elements : natural := 32; --Change this
    address_bits : integer:= 5
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

--type states is (idle, receiving_write, done_write, receiving_read, done_read);
--signal state : states := idle;

--type ram_type is array (0 to max_elements - 1) of std_logic_vector(15 downto 0);
--signal ram : ram_type;
signal debounced_write : std_logic ; 
signal debounced_read : std_logic; 
signal head : integer range 0 to max_elements := 0;
signal tail : integer range 0 to max_elements := 0;
signal is_empty: std_logic;
signal is_full: std_logic;
signal element_count : integer range 0 to max_elements := 0;
signal data : std_logic_vector(15 downto 0):= x"0000";
signal slow_clock : std_logic:='0';
signal write_enable : std_logic:='0';
signal address_line : std_logic_vector(address_bits-1 downto 0);

component clock_enable_debouncing_button is 
    port(
 clk: in std_logic; -- input clock on FPGA 100Mhz                    -- Change counter threshold accordingly
 slow_clk_enable: out std_logic
); end component clock_enable_debouncing_button;

component  Debouncing_Button_VHDL 
port(
 button: in std_logic;
 clk: in std_logic;
 debounced_button: out std_logic
); end component;

component  BRAM  
    generic(
ADDRESS_WIDTH: integer := 12;
DATA_WIDTH: integer := 8
);
port(
clk: in std_logic;
w_enable: in std_logic;
address: in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
datain: in std_logic_vector(DATA_WIDTH-1 downto 0);
dataout: out std_logic_vector(DATA_WIDTH-1 downto 0)
);
end component BRAM ;

begin
    slowclock : entity work.clock_enable_debouncing_button(Behavioral) 
        port map (
        clk=>clk , slow_clk_enable=>slow_clock); 
        
    myBRAM : entity work.BRAM(Behavioral) generic map (
   ADDRESS_WIDTH=>address_bits,
   DATA_WIDTH =>16
    )
    port map (
    clk => slow_clock,
    w_enable=>write_Enable,
    address => address_line,
    datain =>write_data,
    dataout=>data
    );
    
    write_button : entity work.Debouncing_Button_VHDL(behavioral)  port map (
 button=>write , 
 clk=> clk , 
 debounced_button => debounced_write
);
     
     read_button : entity work.Debouncing_Button_VHDL(behavioral) port map(
     button=>read , 
    clk=> clk , 
    debounced_button => debounced_read
);
    

  -- data<= ram(tail) has now become implicit as data is the output of 
  -- the single port RAM which is always fed the address_line as input and displays corressponding value 
--    read_data <= data;
    empty <= is_empty;
    full <= is_full;
--    count <= element_count;

    process(slow_clock)
        begin
            if rising_edge(slow_clock) then      
                if(debounced_write = '1' and is_full = '0') then 
                    write_enable<='1';
                    address_line<=std_logic_vector(to_unsigned(head,address_bits));-- this will write at the head address
--                    ram(head) <= write_data;
                    head <= (head + 1) mod max_elements;
                end if;

                if(debounced_read = '1' and is_empty = '0') then
                address_line<=std_logic_vector(to_unsigned(tail,address_bits)); -- this will read from the tail address
                    tail <= (tail + 1) mod max_elements;
                end if;

                if(element_count = 0) then empty <= '1'; else empty <= '0'; end if;
                if(element_count = max_elements - 1) then is_full <= '1'; else is_full <= '0'; end if;

                if(head < tail) then element_count <= head - tail + max_elements; 
                else element_count <= head - tail;
                end if;
                
                
            -- we make the write enable 0 at the falling edge, this 
            --would happen after a delta delay while on the other hand on the falling edge 
            --write enable would be found to 1 and data would be written in the memory
            end if;
    end process;  
    
    process(clk) begin
     if(falling_edge(clk)) then write_Enable<='0';
     end if; end process;
   
--    data <= ram(tail);
----    read_data <= data;
--    empty <= is_empty;
--    full <= is_full;
----    count <= element_count;
    
--    process(clk)
--        begin
--            if rising_edge(clk) then 
            
--                case (state) is
--                    when idle =>
--                        if(write = '1' and is_full = '0') then
--                            state <= receiving_write;
--                        elsif (read = '1' and is_empty = '0') then
--                            state <= receiving_read;
--                        else
--                            state <= idle;
--                        end if;
                        
--                    when receiving_write =>
--                        ram(head) <= write_data;
--                        head <= (head + 1) mod max_elements;
--                        state <= done_write;
                        
--                    when receiving_read =>
--                        tail <= (tail + 1) mod max_elements;
--                        state <= done_read;
                        
--                    when done_write =>
--                        if(write = '0') then
--                            state <= idle;
--                        else
--                            state <= done_write;
--                        end if;
                        
--                    when done_read =>
--                        if(read = '0') then
--                            state <= idle;
--                        else
--                            state <= done_read;
--                        end if;
                     
--                    when others =>
--                        state <= idle;
                        
                        
--                end case;
                            
                 
----                if(write = '1' and is_full = '0') then 
                        
----                            ram(head) <= write_data;
----                            head <= (head + 1) mod max_elements;
                            
----                end if;
                
----                if(read = '1' and is_empty = '0') then
----                    tail <= (tail + 1) mod max_elements;
----                end if;
                
--                if(element_count = 0) then empty <= '1'; else empty <= '0'; end if;
--                if(element_count = max_elements - 1) then is_full <= '1'; else is_full <= '0'; end if;
                
--                if(head < tail) then element_count <= head - tail + max_elements; 
--                else element_count <= head - tail;
--                end if;
                
--            end if;
--    end process;    

    Multi_Display : entity work.lightDisplay(structure) port map (data, clk, LED, anode);

end Behavioral;