library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.MyTypes.all;

entity transmitter is
  generic(
    clks_per_bit: integer := 10416
    );
  Port (
    clk: in std_logic;
    start: in std_logic;
    inbyte: in std_logic_vector(7 downto 0);
    serial_output: out std_logic
   );
end transmitter;

architecture Behavioral of transmitter is

signal state: states := idle;
signal clk_count: integer range 0 to clks_per_bit := 0;
signal bit_index: integer range 0 to 7 := 0;
signal data: std_logic_vector(7 downto 0);

begin
    process(clk)
        begin
            if(rising_edge(clk)) then
            
                case (state) is
                
                when idle =>
                    clk_count <= 0;
                    bit_index <= 0;
                    serial_output <= '1';
                    if(start = '1') then
                        data <= inbyte;
                        state <= start_bit;
                        
                    else
                        state <= idle;
                        
                    end if;
                    
                when start_bit =>
                    serial_output <= '0';
                    
                    if(clk_count < clks_per_bit - 1) then
                        clk_count <= clk_count + 1;
                        state <= start_bit;
                    else 
                        clk_count <= 0;
                        state <= data_bits;
                    end if;
                    
               when data_bits =>
               
                    serial_output <= data(bit_index);
                    
                    if(clk_count < clks_per_bit - 1) then
                        clk_count <= clk_count + 1;
                        state <= data_bits;
                    else
                        clk_count <= 0;
                        if(bit_index < 7) then
                            bit_index <= bit_index + 1;
                            state <= data_bits;
                            
                        else
                            bit_index <= 0;
                            state <= stop_bit;
                        end if;
                    end if;
                    
                    
               when stop_bit =>
                    serial_output <= '1';
                    
                    if(clk_count < clks_per_bit - 1) then
                        clk_count <= clk_count + 1;
                        state <= stop_bit;
                    else
                        clk_count <= 0;
                        state <= idle;
                    end if;
                    
                
                when others =>
                    state <= idle;
                
                end case;
            
            end if;
        
    end process;


end Behavioral;
