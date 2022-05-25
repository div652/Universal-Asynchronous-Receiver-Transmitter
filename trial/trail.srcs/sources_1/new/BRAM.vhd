----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2022 01:16:13
-- Design Name: 
-- Module Name: BRAM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


use ieee.numeric_std.all;
entity BRAM is
generic(
ADDRESS_WIDTH: integer := 12;
DATA_WIDTH: integer := 8
);
port(
clk: in std_logic;
w_enable: in std_logic;
address: in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
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
                 if (w_enable = '1') then ram(to_integer(unsigned(address))) <= datain; end if;
            address_reg <= address;
            end if;
            end process;
            dataout <= ram(to_integer(unsigned(address_reg)));
        end Behavioral;
