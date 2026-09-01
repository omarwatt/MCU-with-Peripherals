library ieee;
use ieee.std_logic_1164.all;
use work.aux_package.all;

entity GPIO_tb is
end entity;

architecture sim of GPIO_tb is

    signal clk          : std_logic := '0';
    signal rst          : std_logic := '1';
    signal MemWrite     : std_logic := '0';
    signal MemRead      : std_logic := '0';
    signal Address      : std_logic_vector(5 downto 0) := (others => '0');
    signal SW           : std_logic_vector(7 downto 0) := (others => '0');

    signal DataBus      : std_logic_vector(31 downto 0);
    signal TB_Data      : std_logic_vector(31 downto 0) := (others => '0');
    signal TB_BusEnable : std_logic := '0';

    signal LEDR         : std_logic_vector(7 downto 0);
    signal HEX0         : std_logic_vector(6 downto 0);
    signal HEX1         : std_logic_vector(6 downto 0);
    signal HEX2         : std_logic_vector(6 downto 0);
    signal HEX3         : std_logic_vector(6 downto 0);
    signal HEX4         : std_logic_vector(6 downto 0);
    signal HEX5         : std_logic_vector(6 downto 0);

begin

    clk <= not clk after 5 ns;

    DataBus <= TB_Data when TB_BusEnable = '1'
               else (others => 'Z');

    DUT : GPIO
        generic map (
            BUS_WIDTH => 32
        )
        port map (
            clk_i       => clk,
            rst_i       => rst,
            IOpin_io    => DataBus,
            MemWrite_i  => MemWrite,
            MemRead_i   => MemRead,
            Address_i   => Address,
            SW_i        => SW,
            PORT_LEDR_o => LEDR,
            PORT_HEX0_o => HEX0,
            PORT_HEX1_o => HEX1,
            PORT_HEX2_o => HEX2,
            PORT_HEX3_o => HEX3,
            PORT_HEX4_o => HEX4,
            PORT_HEX5_o => HEX5
        );

    process
    begin
        -- Reset
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 20 ns;

        -- Test 1: LEDR = 00
        Address      <= "100000";
        TB_Data      <= x"00000000";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(clk);
        MemWrite     <= '0';
        TB_BusEnable <= '0';
        wait for 180 ns;

        -- Test 2: LEDR = FF
        Address      <= "100000";
        TB_Data      <= x"000000FF";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(clk);
        MemWrite     <= '0';
        TB_BusEnable <= '0';
        wait for 180 ns;

        -- Test 3: LEDR = A5
        Address      <= "100000";
        TB_Data      <= x"000000A5";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(clk);
        MemWrite     <= '0';
        TB_BusEnable <= '0';
        wait for 180 ns;

        -- Test 4: HEX0 = 06
        Address      <= "100010";
        TB_Data      <= x"00000006";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(clk);
        MemWrite     <= '0';
        TB_BusEnable <= '0';
        wait for 180 ns;

        -- Test 5: HEX1 = 5B
        Address      <= "100011";
        TB_Data      <= x"0000005B";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(clk);
        MemWrite     <= '0';
        TB_BusEnable <= '0';
        wait for 180 ns;

        -- Test 6: HEX2 = 4F
        Address      <= "100100";
        TB_Data      <= x"0000004F";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(clk);
        MemWrite     <= '0';
        TB_BusEnable <= '0';
        wait for 180 ns;

        -- Test 7: HEX3 = 66
        Address      <= "100101";
        TB_Data      <= x"00000066";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(clk);
        MemWrite     <= '0';
        TB_BusEnable <= '0';
        wait for 180 ns;

        -- Test 8: HEX4 = 6D
        Address      <= "100110";
        TB_Data      <= x"0000006D";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(clk);
        MemWrite     <= '0';
        TB_BusEnable <= '0';
        wait for 180 ns;

        -- Test 9: HEX5 = 7D
        Address      <= "100111";
        TB_Data      <= x"0000007D";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(clk);
        MemWrite     <= '0';
        TB_BusEnable <= '0';
        wait for 180 ns;

        -- Test 10: LEDR = 5A
        Address      <= "100000";
        TB_Data      <= x"0000005A";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(clk);
        MemWrite     <= '0';
        TB_BusEnable <= '0';
        wait for 180 ns;

        -- Test 11: Read SW = 55
        SW      <= x"55";
        Address <= "101000";
        MemRead <= '1';
        wait for 200 ns;
        MemRead <= '0';

        -- Test 12: Read SW = AA
        SW      <= x"AA";
        Address <= "101000";
        MemRead <= '1';
        wait for 200 ns;
        MemRead <= '0';

        wait;
    end process;

end architecture;