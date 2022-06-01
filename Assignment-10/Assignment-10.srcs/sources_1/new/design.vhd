library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity design is
  Port ( 
    clk: in std_logic;
    inbit: in std_logic;
    reset: in std_logic; --button --change to debounced buttons
    tx_start: in std_logic; --button
    tx_all: in std_logic; --button
    LED: out std_logic_vector(6 downto 0);
    anode: out std_logic_vector(3 downto 0);    
    serial_output: out std_logic
  );
end design;

architecture Behavioral of design is

signal tx_start_debounced : std_logic :='0';
signal reset_debounced : std_logic :='0';
signal done : std_logic;
signal serial_data : std_logic_vector(7 downto 0);
signal inbyte: std_logic_vector(7 downto 0);
signal tx_empty: std_logic;

signal ld_tx: std_logic;
signal rx_full: std_logic;
signal rd_addr: std_logic_vector(15 downto 0);
signal wr_addr: std_logic_vector(15 downto 0);
signal write_en: std_logic;

signal LED_tx: std_logic_vector(6 downto 0);
signal anode_tx: std_logic_vector(3 downto 0);

signal LED_rx: std_logic_vector(6 downto 0);
signal anode_rx: std_logic_vector(3 downto 0);
signal byteToDisplay: std_logic_vector(15 downto 0):= x"0000";
signal counter : integer :=0;
signal slow_clock:std_logic:='0';
type state is (idle, processing,completed);
signal tx_state : state := idle ;
signal reset_state : state :=idle ; 
signal reset_state_final : state :=idle ; 
signal reset_final : std_logic := '0'; 
signal tx_start_final: std_logic := '0';
signal tx_start_state: state := idle;

begin

    process(clk) is
        begin
            if(rising_edge(clk)) then 
                
                if(counter = 2500000) then -- clock period will nwo be 2500000*2*10 = 50000000 ns=50ms. 
                    counter <= 0;
                    slow_clock <= not(slow_clock);
                else
                    counter <= counter + 1;
                end if;
--            if(done = '1') then
--                inbyte <= serial_data;
--            end if;

            case(tx_start_state) is
                when idle =>
                    tx_start_final <= '0';
                    if(tx_start_debounced = '1') then
                        tx_start_state <= processing;
                    else
                        tx_start_state <= idle;
                    end if;
                    
               when processing =>
                    tx_start_final <= '1';
                    tx_start_state <= completed;
                
               when others =>
                    tx_start_final <= '0';
                    if(tx_start_debounced = '0') then
                        tx_start_state <= idle;
                    else
                        tx_start_state <= completed;
                        
                    end if;
               end case;  
               
            case(reset_state_final) is
                when idle =>
                    reset_final <= '0';
                    if(reset_debounced = '1') then
                        reset_state_final <= processing;
                    else
                        reset_state_final <= idle;
                    end if;
                    
               when processing =>
                    reset_final <= '1';
                    reset_state_final <= completed;
                
               when others =>
                    reset_final <= '0';
                    if(reset_debounced = '0') then
                        reset_state_final <= idle;
                    else
                        reset_state_final <= completed;
                        
                    end if;
               end case;  

            if(tx_start_debounced = '1') then
--                LED <= LED_tx;
--                anode <= anode_tx;
                byteToDisplay <= x"00" & inbyte;
            elsif (done = '1') then
--                LED <= LED_rx;
--                anode <= anode_rx;
                byteToDisplay <= x"00" & serial_data;
            elsif (reset = '1') then
                byteToDisplay <= x"0000";
            end if;
          end if;
    end process;

process(slow_clock)
begin
            if(rising_edge(slow_clock) and slow_clock'event) then
                if(tx_start = '1') then 
               		 case (tx_state) is 
                    	when idle => tx_start_debounced <= '1';tx_state<=processing; 
                    	when processing => tx_start_debounced<='0'; tx_state<=completed;
                    	when others => tx_start_debounced<='0';tx_state<=completed;
                	  end case;
           	 	else  
            
                	tx_start_debounced <= '0'; tx_state <= idle ; 


           			 end if;
            
            if(reset = '1') then 
                case (reset_state) is 
                    when idle => reset_debounced <= '1'; reset_state<=processing;
                    when processing => reset_debounced<='0' ; reset_state<=completed;
                    when others =>reset_debounced<='0' ; reset_state<=completed;
                end case;
            else reset_debounced <= '0'; reset_state<=idle; 
            end if;
                
      end if;
            
    end process;
  Receiver:  entity work.receiver(behavioral) port map (clk => clk, inbit => inbit, reset => reset_final, done => done, serial_data => serial_data, rx_full => rx_full);
  Transmitter: entity work.transmitter(behavioral) port map (clk => clk, start => ld_tx, reset => reset_final, inbyte => inbyte, serial_output => serial_output, tx_empty => tx_empty);
  TimingCircuit: entity work.timing_circuit(behavioral) port map (clk, tx_start_final, rx_full, tx_empty, tx_all, ld_tx, rd_addr, wr_addr, write_en, done, reset_final);
  myBRAM: entity work.BRAM(behavioral) port map(clk, write_en, wr_addr, rd_addr, serial_data, inbyte);
  Multi_display: 
    entity work.lightDisplay(structure) port map(byteToDisplay, clk, LED, anode);

end Behavioral;
