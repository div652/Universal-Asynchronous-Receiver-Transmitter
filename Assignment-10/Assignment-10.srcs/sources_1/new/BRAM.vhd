library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use ieee.numeric_std.all;
entity BRAM is
generic(
ADDRESS_WIDTH: integer := 16;
DATA_LENGTH: integer := 8
);
port(
clock: in std_logic;
write_enable: in std_logic;
write_address: in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
read_address: in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
datain: in std_logic_vector(DATA_LENGTH-1 downto 0);
dataout: out std_logic_vector(DATA_LENGTH-1 downto 0)
);
end BRAM;

architecture Behavioral of BRAM is
type RAM_Datatype is array (2**ADDRESS_WIDTH-1 downto 0) of std_logic_vector (DATA_LENGTH-1 downto 0);
        signal memory: RAM_Datatype;
        signal address_register: std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    begin
        process (clock)
            begin
            if ( clock'event and clock = '0') then
                 if (write_enable = '1') then memory(to_integer(unsigned(write_address))) <= datain; end if;
            address_register <= read_address;
            end if;
            end process;
            dataout <= memory(to_integer(unsigned(address_register)));
        end Behavioral;