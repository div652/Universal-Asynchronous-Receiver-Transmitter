library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity design is
    Port(
    clk: in std_logic;
    reset: in std_logic;
    inbit: in std_logic;
    
    LED: out std_logic_vector(6 downto 0);
    anode : out std_logic_vector (3 downto 0)
    
    );
end design;

architecture Behavioral of design is
    -- currently we will show "00xx" on LED display, we can also consider removing the two zeroes
    
    component multiDisplay
	   Port ( 
    		Number : in std_logic_vector(15 downto 0);  -- this is the 16bit input taken from the user , groups of four are interpreted as single hex number
    		Clk : in std_logic;  -- this is the device clock
            LED : out std_logic_vector(6 downto 0); -- led output , mapped to the cathodes
           anode : out STD_LOGIC_Vector(3 downto 0)); -- anode output
     end component multiDisplay;


signal counter : integer := 0;
signal present_state : std_logic;
signal next_state : std_logic;
signal bit_counter : integer := 0;
signal sample_counter : integer := 0;

signal shift_reg : std_logic_vector(9 downto 0);

signal baud_rate : integer := 9600;
signal clk_freq : integer := 100000000;
signal div_counter : integer := clk_freq/(baud_rate*16);

signal clear_bitcounter, clear_sample_counter, inc_bitcounter : std_logic;

signal number : std_logic_vector(15 downto 0);
begin

    process(clk) 
    
        begin
            
            if(reset = '1') then 
                present_state <= '0';
                bit_counter <= 0;
                sample_counter <= 0;
                counter <= 0;
            else
                counter <= counter + 1;
                if(counter >= div_counter - 1) then
                   counter <= 0;
--                   present_state <= next_state;
                end if;
                
                
            case (present_state) is
                when '0' =>
                    if (inbit = '1') then
                        present_state <= '0';
                        
                    else                   
                        present_state <= '1';
                        bit_counter <= 0;
                        sample_counter <= 0;
                    end if;
  
                when others =>
                    present_state <= '1';
                    if(sample_counter = 7) then
                        shift_reg <= inbit & shift_reg(9 downto 1);
                    end if;
                    
                    if(sample_counter = 15) then
                        if(bit_counter = 9) then
                            present_state <= '0';
                        end if;
                        bit_counter <= bit_counter + 1;
                        sample_counter <= 0;
                    else
                        sample_counter <= sample_counter + 1;
                    end if;
                
            end case;            
            end if;       
        
            number <= "00000000" & shift_reg(8 downto 1);
    end process;
    

Multi_display: entity work.lightDisplay(structure) port map(number, clk, LED, anode);
--Single_display: entity work.singleDisplay(Design_arch) port map(digit_A , digit_B, digit_C , digit_D ,light_num , LED ,anode);

end Behavioral;
