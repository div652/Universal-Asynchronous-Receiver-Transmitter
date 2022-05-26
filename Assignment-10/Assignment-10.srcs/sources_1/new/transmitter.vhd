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
    reset: in std_logic;
    inbyte: in std_logic_vector(7 downto 0);
    serial_output: out std_logic;
    tx_empty: out std_logic;
    LED: out std_logic_vector(6 downto 0);
    anode: out std_logic_vector(3 downto 0)
   );
end transmitter;

architecture Behavioral of transmitter is

    component multiDisplay
	   Port ( 
    		Number : in std_logic_vector(15 downto 0);  -- this is the 16bit input taken from the user , groups of four are interpreted as single hex number
    		Clk : in std_logic;  -- this is the device clock
            LED : out std_logic_vector(6 downto 0); -- led output , mapped to the cathodes
           anode : out STD_LOGIC_Vector(3 downto 0)); -- anode output
     end component multiDisplay;


signal state: states := idle;
signal clk_count: integer range 0 to clks_per_bit := 0;
signal bit_index: integer range 0 to 7 := 0;
signal data: std_logic_vector(7 downto 0);
signal byteToDisplay: std_logic_vector(15 downto 0);
begin
    byteToDisplay <= x"00" & data;
    process(clk)
        begin
            if(rising_edge(clk)) then
            
                if(reset = '1') then
                    state <= reset_check;
                    clk_count <= 0;
--                    data <= '1';
--                    byteToDisplay <= x"0000";
                end if;
            
                case (state) is
                
                when reset_check =>
                    tx_empty <= '0';
                    if clk_count < clks_per_bit - 1 then
                        clk_count <= clk_count + 1;
                    else
                        serial_output <= '1';
                        state <= idle;
                   end if;
                
                when idle =>
                    tx_empty <= '1';
                    clk_count <= 0;
                    bit_index <= 0;
                    serial_output <= '1';
                    if(start = '1') then
                        data <= inbyte;
                        state <= start_bit;                       
                    end if;
                    
                when start_bit =>
                    tx_empty <= '0';
                    serial_output <= '0';
                    
                    if(clk_count < clks_per_bit - 1) then
                        clk_count <= clk_count + 1;
                        state <= start_bit;
                    else 
                        clk_count <= 0;
                        state <= data_bits;
                    end if;
                    
               when data_bits =>
                    tx_empty <= '0';
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
                    tx_empty <= '0';
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

Multi_display: 
    entity work.lightDisplay(structure) port map(byteToDisplay, clk, LED, anode);

end Behavioral;