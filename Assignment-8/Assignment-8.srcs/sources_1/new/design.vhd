library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity design is
  Port ( 
    clk: in std_logic;
    inbit: in std_logic;
    reset: in std_logic;
    LED: out std_logic_vector(6 downto 0);
    anode: out std_logic_vector(3 downto 0);
    serial_output : out std_logic
  );
end design;

architecture Behavioral of design is
signal done : std_logic;
signal serial_data : std_logic_vector(7 downto 0);
signal inbyte: std_logic_vector(7 downto 0);

begin
  
  process(clk) is
  begin
      if(done = '1') then
        inbyte <= serial_data;
      end if;
  end process;
  
  Receiver:  entity work.receiver(behavioral) port map (clk, inbit, reset, done, LED, anode, serial_data);
  Transmitter: entity work.transmitter(behavioral) port map (clk, done, reset, inbyte, serial_output);

end Behavioral;
