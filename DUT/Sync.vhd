library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Sync is
    generic (
        BUS_WIDTH : integer := 32
    );
    port (
        divclk_i    : in std_logic;
        rst_i       : in std_logic;
        Ain_i       : in std_logic_vector(BUS_WIDTH-1 downto 0);
        Bin_i       : in std_logic_vector(BUS_WIDTH-1 downto 0);

        Ain_o       : OUT std_logic_vector(BUS_WIDTH-1 downto 0);
        Bin_o       : OUT std_logic_vector(BUS_WIDTH-1 downto 0)   
    );
end Sync;

architecture rtl of Sync is
    signal Ain_q,Bin_q : std_logic_vector(BUS_WIDTH-1 downto 0);
begin
process (divclk_i,rst_i)
begin
    if rst_i = '1' then
        Ain_q <= (others => '0'); 
        Bin_q <= (others => '0');
    elsif(rising_edge(divclk_i)) then
        Ain_q <= Ain_i;
        Bin_q <= Bin_i;
    end if;
end process;
Ain_o <= Ain_q;
Bin_o <= Bin_q;
end architecture;