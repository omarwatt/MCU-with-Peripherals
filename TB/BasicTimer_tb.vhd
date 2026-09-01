library ieee;
use ieee.std_logic_1164.all;

entity BasicTimer_tb is
end BasicTimer_tb;

architecture sim of BasicTimer_tb is

    signal SMCLK        : std_logic := '0';
    signal rst          : std_logic := '1';
    signal Address      : std_logic_vector(5 downto 0) := (others => '0');
    signal MemRead      : std_logic := '0';
    signal MemWrite     : std_logic := '0';
    signal CAPIN1       : std_logic := '0';
    signal CAPIN2       : std_logic := '0';

    signal DataBus      : std_logic_vector(31 downto 0);
    signal TB_Data      : std_logic_vector(31 downto 0) := (others => '0');
    signal TB_BusEnable : std_logic := '0';

    signal PWM          : std_logic;
    signal BTIFG        : std_logic;
    signal BTCAPR       : std_logic_vector(31 downto 0);

begin

    SMCLK <= not SMCLK after 5 ns;

    DataBus <= TB_Data when TB_BusEnable = '1'
               else (others => 'Z');

    DUT : entity work.BasicTimer
        port map (
            SMCLK_i    => SMCLK,
            rst_i      => rst,
            Address_i  => Address,
            DataBus_io => DataBus,
            MemRead_i  => MemRead,
            MemWrite_i => MemWrite,
            CAPIN1_i   => CAPIN1,
            CAPIN2_i   => CAPIN2,
            PWM_o      => PWM,
            BTIFG_o    => BTIFG,
            BTCAPR_o   => BTCAPR
        );

    process
    begin
        --------------------------------------------------
        -- Test 1: BTCMPR0 = 2
        --------------------------------------------------
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        Address      <= "110000";
        TB_Data      <= x"00000002";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        Address      <= "101110";
        TB_Data      <= x"00000000";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        wait for 220 ns;

        --------------------------------------------------
        -- Test 2: BTCMPR0 = 4
        --------------------------------------------------
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        Address      <= "110000";
        TB_Data      <= x"00000004";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        Address      <= "101110";
        TB_Data      <= x"00000000";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        wait for 220 ns;

        --------------------------------------------------
        -- Test 3: BTCMPR0 = 6
        --------------------------------------------------
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        Address      <= "110000";
        TB_Data      <= x"00000006";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        Address      <= "101110";
        TB_Data      <= x"00000000";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        wait for 220 ns;

        --------------------------------------------------
        -- Test 4: BTCMPR0 = 8
        --------------------------------------------------
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        Address      <= "110000";
        TB_Data      <= x"00000008";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        Address      <= "101110";
        TB_Data      <= x"00000000";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        wait for 220 ns;

        --------------------------------------------------
        -- Test 5: BTCMPR0 = 10
        --------------------------------------------------
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        Address      <= "110000";
        TB_Data      <= x"0000000A";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        Address      <= "101110";
        TB_Data      <= x"00000000";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        wait for 220 ns;

        --------------------------------------------------
        -- Test 6: BTCMPR0 = 12
        --------------------------------------------------
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        Address      <= "110000";
        TB_Data      <= x"0000000C";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        Address      <= "101110";
        TB_Data      <= x"00000000";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        wait for 220 ns;

        --------------------------------------------------
        -- Test 7: BTCMPR0 = 14
        --------------------------------------------------
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        Address      <= "110000";
        TB_Data      <= x"0000000E";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        Address      <= "101110";
        TB_Data      <= x"00000000";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        wait for 220 ns;

        --------------------------------------------------
        -- Test 8: BTCMPR0 = 16
        --------------------------------------------------
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        Address      <= "110000";
        TB_Data      <= x"00000010";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        Address      <= "101110";
        TB_Data      <= x"00000000";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        wait for 220 ns;

        --------------------------------------------------
        -- Test 9: BTCMPR0 = 18
        --------------------------------------------------
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        Address      <= "110000";
        TB_Data      <= x"00000012";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        Address      <= "101110";
        TB_Data      <= x"00000000";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        wait for 220 ns;

        --------------------------------------------------
        -- Test 10: BTCMPR0 = 20
        --------------------------------------------------
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        Address      <= "110000";
        TB_Data      <= x"00000014";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        Address      <= "101110";
        TB_Data      <= x"00000000";
        TB_BusEnable <= '1';
        MemWrite     <= '1';
        wait until falling_edge(SMCLK);
        MemWrite     <= '0';
        TB_BusEnable <= '0';

        wait for 220 ns;

        wait;
    end process;

end sim;