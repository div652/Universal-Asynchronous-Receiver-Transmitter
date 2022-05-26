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
    LED: out std_logic_vector(6 downto 0);
    anode: out std_logic_vector(3 downto 0);    
    serial_output: out std_logic
  );
end design;

architecture Behavioral of design is

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

begin

    process(clk) is
        begin
--            if(done = '1') then
--                inbyte <= serial_data;
--            end if;

            if(tx_start = '1') then
                LED <= LED_tx;
                anode <= anode_tx;
                
            elsif (done = '1') then
                LED <= LED_rx;
                anode <= anode_rx;
            
            end if;
    end process;

  Receiver:  entity work.receiver(behavioral) port map (clk => clk, inbit => inbit, reset => reset, done => done, LED => LED_rx, anode => anode_rx, serial_data => serial_data, rx_full => rx_full);
  Transmitter: entity work.transmitter(behavioral) port map (clk => clk, start => ld_tx, reset => reset, inbyte => inbyte, serial_output => serial_output, tx_empty => tx_empty, LED => LED_tx, anode => anode_tx);
  TimingCircuit: entity work.timing_circuit(behavioral) port map (clk, tx_start, rx_full, tx_empty, ld_tx, rd_addr, wr_addr, write_en, done);
  myBRAM: entity work.BRAM(behavioral) port map(clk, write_en, wr_addr, rd_addr, serial_data, inbyte);
end Behavioral;
