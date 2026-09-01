library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.aux_package.all;

entity BasicTimer is
    generic(
        BUS_WIDTH: integer := 32
    );
    port (
        SMCLK_i     : in std_logic;
        rst_i       : in std_logic; 
        Address_i   : in std_logic_vector(5 downto 0); --A13,A5-A2,A0
        DataBus_io  : inout std_logic_vector(BUS_WIDTH-1 DOWNTO 0);
        MemRead_i   : in std_logic;
        MemWrite_i  : in std_logic;
        CAPIN1_i    : in std_logic;
        CAPIN2_i    : in std_logic;

        PWM_o       : out std_logic;
        BTIFG_o     : out std_logic;
        BTCAPR_o    : out std_logic_vector(BUS_WIDTH-1 DOWNTO 0)
    );
end BasicTimer;

architecture rtl of BasicTimer is
    signal Din_w       : std_logic_vector(BUS_WIDTH-1 downto 0);
    signal Dout_w      : std_logic_vector(BUS_WIDTH-1 downto 0);
    signal bus_en_w    : std_logic;
    signal CS_w        : std_logic_vector(4 downto 0);

    signal BTCTL1_q    : std_logic_vector(7 downto 0);
    signal BTCTL2_q    : std_logic_vector(7 downto 0);
    signal BTCMPR0_q   : std_logic_vector(BUS_WIDTH-1 downto 0);
    signal BTCMPR1_q   : std_logic_vector(BUS_WIDTH-1 downto 0);
    signal BTCAPR_q    : std_logic_vector(BUS_WIDTH-1 downto 0);

    signal BTCLR_pulse_q   : std_logic;
    signal divider_count_q : integer range 0 to 7;
    signal timer_tick_w    : std_logic;
    signal BTCNT_q     : std_logic_vector(BUS_WIDTH-1 downto 0);
    signal EQU0_q      : std_logic;
    signal EQU1_q      : std_logic;

    signal CAPIN1_pre_q  : std_logic;
    signal CAPIN2_pre_q  : std_logic;
    signal CAP_pre_q     : std_logic;
    signal CAP_out_w     : std_logic;
    signal CAP_Event_w   : std_logic;

    alias BTINT     : std_logic_vector(1 DOWNTO 0) is BTCTL1_q(1 DOWNTO 0);
    alias BTSSEL    : std_logic_vector(1 DOWNTO 0) is BTCTL1_q(4 DOWNTO 3);
    alias BTHOLD    : std_logic is BTCTL1_q(5);
    alias BTOUTEN   : std_logic is BTCTL1_q(6);
    alias BTOUTMD   : std_logic is BTCTL1_q(7);
    
    alias CAPISEL : std_logic_vector(1 DOWNTO 0) is BTCTL2_q(1 DOWNTO 0);
    alias CAPMD   : std_logic_vector(1 DOWNTO 0) is BTCTL2_q(3 DOWNTO 2);
    
begin

    DataBus: BidirPin generic map(width => BUS_WIDTH) port map(Dout => Dout_w,en => bus_en_w, Din => Din_w,IOpin => DataBus_io);
    with Address_i select
        CS_w <= "00001" when "101110",
                "00010" when "101111",
                "00100" when "110000",
                "01000" when "110010",
                "10000" when "110100",
                "00000" when others;

    bus_en_w    <= '1' when MemRead_i = '1' and CS_w /= "00000" else '0';

    Dout_w  <=  (BUS_WIDTH-1 downto 8 => '0') & BTCTL1_q    when CS_w(0) = '1' else
                (BUS_WIDTH-1 downto 8 => '0') & BTCTL2_q    when CS_w(1) = '1' else
                BTCMPR0_q                                   when CS_w(2) = '1' else
                BTCMPR1_q                                   when CS_w(3) = '1' else
                BTCAPR_q                                    when CS_w(4) = '1' else
                (others => '0');


    --------------------------------------------
    --                TIMER REG               --
    --------------------------------------------   
    process (SMCLK_i, rst_i)
    begin
        if rst_i = '1' then
            BTCTL1_q  <= x"20"; -- BTHOLD=1 after reset.
            BTCTL2_q  <= (others => '0');
            BTCMPR0_q <= (others => '0');
            BTCMPR1_q <= (others => '0');
            BTCLR_pulse_q <= '0';
        elsif falling_edge(SMCLK_i) then
            BTCLR_pulse_q <= '0';
            if MemWrite_i = '1' then
                if CS_w(0) = '1' then
                    BTCTL1_q <= Din_w(7 downto 3) & '0' & Din_w(1 downto 0);
                    BTCLR_pulse_q <= Din_w(2);
                elsif CS_w(1) = '1' then
                    BTCTL2_q <= Din_w(7 downto 0);
                elsif CS_w(2) = '1' then
                    BTCMPR0_q <= Din_w;
                elsif CS_w(3) = '1' then
                    BTCMPR1_q <= Din_w;
                end if;
            end if;
        end if;
    end process;

    --------------------------------------------
    --          Timer clock-enable divider    --
    --------------------------------------------
    timer_tick_w <= '1' when BTSSEL = "00" else
                    '1' when BTSSEL = "01" and divider_count_q = 1 else
                    '1' when BTSSEL = "10" and divider_count_q = 3 else
                    '1' when BTSSEL = "11" and divider_count_q = 7 else
                    '0';

    process (SMCLK_i, rst_i)
    begin
        if rst_i = '1' then
            divider_count_q <= 0;
        elsif rising_edge(SMCLK_i) then
            if BTCLR_pulse_q = '1' or BTHOLD = '1' then
                divider_count_q <= 0;
            elsif timer_tick_w = '1' then
                divider_count_q <= 0;
            else
                divider_count_q <= divider_count_q + 1;
            end if;
        end if;
    end process;

    --------------------------------------------
    --                  BTCNT                 --
    --------------------------------------------
    process (SMCLK_i, rst_i)
        variable next_count_v : unsigned(BUS_WIDTH-1 downto 0);
    begin
        if rst_i = '1' then
            BTCNT_q <= (others => '0');
            EQU0_q  <= '0';
            EQU1_q  <= '0';
        elsif rising_edge(SMCLK_i) then
            EQU0_q <= '0';
            EQU1_q <= '0';

            if BTCLR_pulse_q = '1' then
                BTCNT_q <= (others => '0');
            elsif timer_tick_w = '1' and BTHOLD = '0' then
                next_count_v := unsigned(BTCNT_q) + 1;

                if next_count_v = unsigned(BTCMPR1_q) then
                    EQU1_q <= '1';
                end if;

                if BTCMPR0_q /= x"00000000" and next_count_v >= unsigned(BTCMPR0_q) then
                    BTCNT_q <= (others => '0');
                    EQU0_q  <= '1';
                    
                    if BTCMPR1_q = x"00000000" then
                        EQU1_q <= '1';
                    end if;

                else
                    BTCNT_q <= std_logic_vector(next_count_v);
                end if;
            end if;
        end if;
    end process;

    --------------------------------------------
    --                  PWM                   --
    --------------------------------------------
    process(SMCLK_i, rst_i)
    begin
        if rst_i = '1' then
            PWM_o <= '0';
        elsif rising_edge(SMCLK_i) then
            if BTCLR_pulse_q = '1' then
                PWM_o <= '0';
            elsif BTOUTEN = '1' and BTCMPR0_q /= x"00000000" then
                if EQU1_q = '1' then
                    PWM_o <= not BTOUTMD;
                elsif EQU0_q = '1' then
                    PWM_o <= BTOUTMD;
                end if;
            end if;
        end if;
    end process;

    --------------------------------------------
    --              Capture-input             --
    --------------------------------------------
    process (SMCLK_i, rst_i)
    begin
        if rst_i = '1' then
            CAPIN1_pre_q <= '0';
            CAPIN2_pre_q <= '0';
            CAP_pre_q    <= '0';
        elsif rising_edge(SMCLK_i) then
            if BTCLR_pulse_q = '1' then
                CAPIN1_pre_q <= '0';
                CAPIN2_pre_q <= '0';
                CAP_pre_q    <= '0';
            else
                CAPIN1_pre_q <= CAPIN1_i;
                CAPIN2_pre_q <= CAPIN2_i;
                CAP_pre_q    <= CAP_out_w;
            end if;
        end if;
    end process;

    with CAPISEL select
        CAP_out_w   <=  CAPIN1_pre_q when "00",
                        CAPIN2_pre_q when "01",
                        '1'          when "10",
                        '0'          when others;

    CAP_Event_w <=  '1' when CAPMD = "01" and CAP_pre_q = '0' and CAP_out_w = '1' else
                    '1' when CAPMD = "10" and CAP_pre_q = '1' and CAP_out_w = '0' else
                    '0';

    process (SMCLK_i, rst_i)
    begin
        if rst_i = '1' then
            BTCAPR_q <= (others => '0'); 
        elsif rising_edge(SMCLK_i) then
            if BTCLR_pulse_q = '1' then
                BTCAPR_q <= (others => '0');
            elsif CAP_Event_w = '1' then
                BTCAPR_q <= BTCNT_q;
            end if;
        end if;
    end process;

    --------------------------------------------
    --       Interrupt-event selection        --
    --------------------------------------------
    with BTINT select
        BTIFG_o <=  EQU0_q      when "00",
                    EQU1_q      when "01",
                    CAP_Event_w when others;
    
    BTCAPR_o <= BTCAPR_q;
end rtl;
