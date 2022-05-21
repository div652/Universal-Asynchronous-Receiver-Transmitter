library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity design2 is
    generic(
    clks_per_bit: integer := 10416 -- instead  of 1042 
    );
    Port(
    clk: in std_logic;
    reset: in std_logic;
    inbit: in std_logic;
    
    LED: out std_logic_vector(6 downto 0);
    anode : out std_logic_vector (3 downto 0)
    
    );
end design2;

architecture Behavioral of design2 is
    
    component multiDisplay
	   Port ( 
    		Number : in std_logic_vector(15 downto 0);  -- this is the 16bit input taken from the user , groups of four are interpreted as single hex number
    		Clk : in std_logic;  -- this is the device clock
            LED : out std_logic_vector(6 downto 0); -- led output , mapped to the cathodes
           anode : out STD_LOGIC_Vector(3 downto 0)); -- anode output
     end component multiDisplay;

type states is (idle, start_bit, stop_bit, data_bits, reset_check);
signal state : states := idle;
signal registered_data : std_logic := '1';
signal data : std_logic := '1';
signal byteToDisplay : std_logic_vector(15 downto 0) := x"0000";

signal clk_count : integer range 0 to 10416 := 0;
signal bit_index : integer range 0 to 7 := 0;

begin

    process(clk) is
        begin
            if(rising_edge(clk)) then
                registered_data <= inbit;
                data <= registered_data;
            end if;
    end process;
    
    process(clk) is
        begin
            if(rising_edge(clk)) then
            
                if(reset = '1') then
                    state <= reset_check;
                    clk_count <= 0;
--                    data <= '1';
--                    byteToDisplay <= x"0000";
                end if;
                
                case state is
                
                    when reset_check =>
                        if clk_count < clks_per_bit - 1 then
                            clk_count <= clk_count + 1;
                        else
                            byteToDisplay <= x"0000";
                            state <= idle;
                        end if;
                
                    when idle =>
                        clk_count <= 0;
                        bit_index <= 0;
                        
                        if(data = '0') then
                            state <= start_bit;
                        end if;
                        
                    when start_bit =>
                        if(clk_count = ((clks_per_bit -1) / 2)) then
                            if data = '0' then
                                clk_count <= 0;
                                state <= data_bits;
                            else
                                state <= idle;
                            end if;
                            
                       else
                            clk_count <= clk_count + 1;
                            state <= start_bit;
                       end if;
                       
                    when data_bits =>
                        if(clk_count < clks_per_bit - 1) then
                            clk_count <= clk_count + 1;
                            state <= data_bits;
                        else
                            clk_count <= 0;
                            byteToDisplay(bit_index) <= data;
                            if bit_index < 7 then
                                bit_index <= bit_index + 1;
                                state <= data_bits;
                            else
                                bit_index <= 0;
                                state <= stop_bit;
                            end if;
                        end if;
                        
                    
                   when stop_bit => 
                        if clk_count < clks_per_bit then
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