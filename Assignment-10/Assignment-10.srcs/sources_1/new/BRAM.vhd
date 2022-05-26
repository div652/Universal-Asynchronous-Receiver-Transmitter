library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use ieee.numeric_std.all;
entity BRAM is
generic(
ADDRESS_WIDTH: integer := 16;
DATA_WIDTH: integer := 8
);
port(
clk: in std_logic;
w_enable: in std_logic;
write_address: in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
read_address: in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
datain: in std_logic_vector(DATA_WIDTH-1 downto 0);
dataout: out std_logic_vector(DATA_WIDTH-1 downto 0)
);
end BRAM;

architecture Behavioral of BRAM is
type RAM_Datatype is array (2**ADDRESS_WIDTH-1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
        signal ram: RAM_Datatype;
        signal address_reg: std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    begin
        process (clk)
            begin
            if ( clk'event and clk = '0') then
                 if (w_enable = '1') then ram(to_integer(unsigned(write_address))) <= datain; end if;
            address_reg <= read_address;
            end if;
            end process;
            dataout <= ram(to_integer(unsigned(address_reg)));
        end Behavioral;