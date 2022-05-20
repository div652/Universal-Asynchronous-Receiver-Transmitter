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
signal shift : std_logic;
signal shift_reg : std_logic_vector(9 downto 0):="1110101010";


signal baud_rate : integer := 9600;
signal clk_freq : integer := 100000000;
signal div_counter : integer := clk_freq/(baud_rate*16);

signal clear_bitcounter, clear_samplecounter, inc_bitcounter, inc_samplecounter : std_logic;

signal number : std_logic_vector(15 downto 0);
begin

    process(clk) 
    variable i :integer := 0 ; 
        
        
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
                   present_state <= next_state;
                if (shift='1') then shift_reg(i) <= inbit;i:=(i+1)mod 10; end if;
                
                if (clear_samplecounter='1') then sample_counter <=0; end if;
                if (inc_samplecounter = '1') then sample_counter <= sample_counter +1; end if;
                if (clear_bitcounter = '1') then bit_counter <=0; end if;
                if (inc_bitcounter = '1') then bit_counter <= bit_counter +1; end if;
                end if;
                end if;
                
             
    end process;
    
    process(clk) 
    
    begin
        
            shift <= '0'; 
            clear_samplecounter <= '0';
            inc_samplecounter <='0';
            clear_bitcounter <='0';
            inc_bitcounter <='0'; 
            next_state <='0'; 
            case (present_state) is
                when '0' =>
                    if (inbit = '1') then
                        next_state <= '0';
                        
                    else                   
                        next_state <= '1';
                        clear_bitcounter <= '1';
                        clear_samplecounter <= '1';
                    end if;
  
                when others =>
                    next_state <= '1';
                    if(sample_counter = 7) then
                        shift <= '1';
                        
                    end if;
                    
                    if(sample_counter = 15) then
                        if(bit_counter = 9) then
                            next_state <= '0';
--                            i:=0;
                        end if;
                        inc_bitcounter <= '1';
                        clear_samplecounter <= '1';
                    else
                        inc_samplecounter <= '1';
                    end if;
                
            end case;            
                 
        
            number <= "00000000" & shift_reg(8 downto 1);
    end process;
    
    

Multi_display: entity work.lightDisplay(structure) port map(number, clk, LED, anode);
--Single_display: entity work.singleDisplay(Design_arch) port map(digit_A , digit_B, digit_C , digit_D ,light_num , LED ,anode);

end Behavioral;
