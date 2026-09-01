library ieee;
use ieee.std_logic_1164.all;

entity InterruptControl_tb is
end InterruptControl_tb;

architecture sim of InterruptControl_tb IS

    signal clk          : std_logic := '0';
    signal rst          : std_logic := '1';
    signal rst_btn      : std_logic := '0';
    signal Address      : std_logic_vector(5 downto 0) := (others => '0');
    signal INTA         : std_logic := '1';
    signal MemRead      : std_logic := '0';
    signal MemWrite     : std_logic := '0';
    signal IS_i         : std_logic_vector(6 downto 0) := (others => '0');
    signal GIE          : std_logic := '1';
    signal INTR         : std_logic;

    signal DataBus      : std_logic_vector(31 downto 0);
    signal TB_Data      : std_logic_vector(31 downto 0) := (others => '0');
    signal TB_BusEnable : std_logic := '0';

begin

    clk <= not clk after 5 ns;

    DataBus <= TB_Data when TB_BusEnable = '1'
               else (others => 'Z');

    DUT : entity work.InterruptControl
        port map (
            clk_i      => clk,
            rst_i      => rst,
            rst_btn_i  => rst_btn,
            Address_i  => Address,
            INTA_i     => INTA,
            MemRead_i  => MemRead,
            MemWrite_i => MemWrite,
            IS_i       => IS_i,
            IOpin_io   => DataBus,
            GIE_i      => GIE,
            INTR_o     => INTR
        );

    process
    begin
        -- Reset
        rst <= '1';
        wait for 100 ns;
        rst <= '0';

        -- Enable all seven interrupts: IE = 7F
        Address      <= "111100";
        TB_Data      <= x"0000007F";
        TB_BusEnable <= '1';
        MemWrite     <= '1';

        wait until rising_edge(clk);

        MemWrite     <= '0';
        TB_BusEnable <= '0';

        wait for 100 ns;

        --------------------------------------------------
        -- Test 1: UART RX, expected type = 08
        --------------------------------------------------
        IS_i(0) <= '1';
        wait for 20 ns;
        IS_i(0) <= '0';
        wait for 40 ns;
        INTA <= '0';
        wait for 20 ns;
        INTA <= '1';
        wait for 100 ns;

        --------------------------------------------------
        -- Test 2: UART TX, expected type = 0C
        --------------------------------------------------
        IS_i(1) <= '1';
        wait for 20 ns;
        IS_i(1) <= '0';
        wait for 40 ns;
        INTA <= '0';
        wait for 20 ns;
        INTA <= '1';
        wait for 100 ns;

        --------------------------------------------------
        -- Test 3: Basic Timer, expected type = 10
        --------------------------------------------------
        IS_i(2) <= '1';
        wait for 20 ns;
        IS_i(2) <= '0';
        wait for 40 ns;
        INTA <= '0';
        wait for 20 ns;
        INTA <= '1';
        wait for 100 ns;

        --------------------------------------------------
        -- Test 4: KEY1, expected type = 14
        --------------------------------------------------
        IS_i(3) <= '1';
        wait for 20 ns;
        IS_i(3) <= '0';
        wait for 40 ns;
        INTA <= '0';
        wait for 20 ns;
        INTA <= '1';
        wait for 100 ns;

        --------------------------------------------------
        -- Test 5: KEY2, expected type = 18
        --------------------------------------------------
        IS_i(4) <= '1';
        wait for 20 ns;
        IS_i(4) <= '0';
        wait for 40 ns;
        INTA <= '0';
        wait for 20 ns;
        INTA <= '1';
        wait for 100 ns;

        --------------------------------------------------
        -- Test 6: KEY3, expected type = 1C
        --------------------------------------------------
        IS_i(5) <= '1';
        wait for 20 ns;
        IS_i(5) <= '0';
        wait for 40 ns;
        INTA <= '0';
        wait for 20 ns;
        INTA <= '1';
        wait for 100 ns;

        --------------------------------------------------
        -- Test 7: UART error, expected type = 04
        --------------------------------------------------
        IS_i(6) <= '1';
        wait for 20 ns;
        IS_i(6) <= '0';
        wait for 40 ns;
        INTA <= '0';
        wait for 20 ns;
        INTA <= '1';
        wait for 100 ns;

        --------------------------------------------------
        -- Test 8: UART RX again
        --------------------------------------------------
        IS_i(0) <= '1';
        wait for 20 ns;
        IS_i(0) <= '0';
        wait for 40 ns;
        INTA <= '0';
        wait for 20 ns;
        INTA <= '1';
        wait for 100 ns;

        --------------------------------------------------
        -- Test 9: Basic Timer again
        --------------------------------------------------
        IS_i(2) <= '1';
        wait for 20 ns;
        IS_i(2) <= '0';
        wait for 40 ns;
        INTA <= '0';
        wait for 20 ns;
        INTA <= '1';
        wait for 100 ns;

        --------------------------------------------------
        -- Test 10: KEY3 again
        --------------------------------------------------
        IS_i(5) <= '1';
        wait for 20 ns;
        IS_i(5) <= '0';
        wait for 40 ns;
        INTA <= '0';
        wait for 20 ns;
        INTA <= '1';
        wait for 100 ns;

        wait;
    end process;

end sim;