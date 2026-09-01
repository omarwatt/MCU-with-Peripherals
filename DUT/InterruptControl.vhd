library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity InterruptControl is
    generic (
        BUS_WIDTH : INTEGER := 32
    );
    port (
        clk_i       : in std_logic;
        rst_i       : in std_logic;
        rst_btn_i   : in std_logic;
        Address_i   : in std_logic_vector(5 downto 0); --A13,A5,A3-A0
        INTA_i      : in std_logic;
        MemRead_i   : in std_logic;
        MemWrite_i  : in std_logic;
        IS_i        : in std_logic_vector(6 downto 0); --interrupt source
        IOpin_io    : inout std_logic_vector(BUS_WIDTH-1 downto 0);
        GIE_i       : in std_logic;
        
        INTR_o      : out std_logic
    );
end entity;

architecture rtl of InterruptControl is
signal Dout_w,Din_w : std_logic_vector(BUS_WIDTH-1 downto 0);
signal en_w         : std_logic;
signal CS_w         : std_logic_vector(2 downto 0);
signal clr_rst_w    : std_logic;
signal clr_irq_w    : std_logic_vector(6 downto 0);
signal IE_q         : std_logic_vector(6 downto 0);
signal Type_in_w    : std_logic_vector(7 downto 0);
signal Type_out_q   : std_logic_vector(7 downto 0);
signal IR_q         : std_logic_vector(6 downto 0);
signal rst_in_q,rst_out_q    : std_logic;
signal IFG_in_w,IFG_out_q    : std_logic_vector(6 downto 0);
signal IFG_or_w              : std_logic;
begin
DataBus: BidirPin generic map(width => BUS_WIDTH) port map(Dout => Dout_w, en => en_w,Din => Din_w,IOpin => IOpin_io);

with Address_i select
    CS_w <= "001" when "111100",
            "010" when "111101",
            "100" when "111110",
            (others => '0') when others;

Dout_w  <=  x"000000"&'0'&IE_q      when CS_w = "001" and MemRead_i = '1' else
            x"000000"&'0'&IFG_out_q when CS_w = "010" and MemRead_i = '1' else
            x"000000"&Type_out_q    when (CS_w = "100" and MemRead_i = '1') or INTA_i = '0' else
            (others => '0');

en_w    <= '1' when (INTA_i = '0' or (MemRead_i = '1' and ((CS_w(0) = '1') or (CS_w(1) = '1') or (CS_w(2) = '1'))))
                    else '0';
                        
Type_in_w(7 downto 5)  <=   "000";
Type_in_w(4 downto 2)  <=   "000" WHEN rst_out_q = '1' ELSE -- Reset
                            "001" WHEN IFG_out_q(6) = '1' ELSE --UART status error
                            "010" WHEN IFG_out_q(0) = '1' ELSE -- RX
                            "011" WHEN IFG_out_q(1) = '1' ELSE -- TX
                            "100" WHEN IFG_out_q(2) = '1' ELSE -- BT 
                            "101" WHEN IFG_out_q(3) = '1' ELSE -- KEY1
                            "110" WHEN IFG_out_q(4) = '1' ELSE -- KEY2
                            "111" WHEN IFG_out_q(5) = '1' ELSE -- KEY3
						    "000"; --Key0
Type_in_w(1 downto 0)  <=   "00";

clr_rst_w	       <= '1' WHEN (Type_out_q(4 DOWNTO 2) = "000" AND INTA_i = '0') ELSE '0';  --RST
clr_irq_w(6)	   <= '1' WHEN (Type_out_q(4 DOWNTO 2) = "001" AND INTA_i = '0') ELSE '0';  --UART status error
clr_irq_w(0)	   <= '1' WHEN (Type_out_q(4 DOWNTO 2) = "010" AND INTA_i = '0') ELSE '0';  --UART RX
clr_irq_w(1)	   <= '1' WHEN (Type_out_q(4 DOWNTO 2) = "011" AND INTA_i = '0') ELSE '0';  --UART TX 
clr_irq_w(2)	   <= '1' WHEN (Type_out_q(4 DOWNTO 2) = "100" AND INTA_i = '0') ELSE '0';  --Basic Timer
clr_irq_w(3)	   <= '1' WHEN (Type_out_q(4 DOWNTO 2) = "101" AND INTA_i = '0') ELSE '0';  --Pushbutton 1
clr_irq_w(4)	   <= '1' WHEN (Type_out_q(4 DOWNTO 2) = "110" AND INTA_i = '0') ELSE '0';  --Pushbutton 2
clr_irq_w(5)	   <= '1' WHEN (Type_out_q(4 DOWNTO 2) = "111" AND INTA_i = '0') ELSE '0';  --Pushbutton 3

------------------------------------------------
--                   Reset                    --
------------------------------------------------
process (clr_rst_w,rst_i,rst_btn_i)
begin
    if rst_i = '1' then
        rst_in_q <= '0';
    elsif clr_rst_w = '1' then
        rst_in_q <= '0';
    elsif rising_edge(rst_btn_i) then
        rst_in_q <= '1';
    end if;
end process;
------------------------------------------------
--                  IE_REG                    --
------------------------------------------------
IRQ_LATCHES: for i in 0 to 6 generate
    process (clr_irq_w(i),rst_i,IS_i(i))
    begin
        if rst_i = '1' then
            IR_q(i) <= '0';
        elsif clr_irq_w(i) = '1' then
            IR_q(i) <= '0';
        elsif rising_edge(IS_i(i)) then
            IR_q(i) <= '1';
        end if;
    end process;
end generate;
------------------------------------------------
--                  IE_REG                    --
------------------------------------------------
IE_REG: process(clk_i,rst_i)
begin
    if rst_i = '1' then
        IE_q <= (others => '0');
    elsif rising_edge(clk_i) then
        if (CS_w(0) = '1' and MemWrite_i = '1') then
            IE_q <= Din_w(6 downto 0);
        end if;
    end if; 
end process;
------------------------------------------------
--                  IFG_REG                   --
------------------------------------------------
IFG_in_w <= IE_q and IR_q;

IFG_REG: process(clk_i,rst_i)
begin
    if rst_i = '1' then
        IFG_out_q <= (others => '0');
        rst_out_q <= '0';
    elsif rising_edge(clk_i) then
        rst_out_q <= rst_in_q;
        if (CS_w(1) = '1' and MemWrite_i = '1') then
            IFG_out_q <= Din_w(6 downto 0);
        else
            IFG_out_q <= IFG_in_w;
        end if;
    end if; 
end process;

------------------------------------------------
--                  Type_reg                  --
------------------------------------------------
Type_reg: process(clk_i,rst_i)
begin
    if rst_i = '1' then
        Type_out_q <= (others => '0');
    elsif rising_edge(clk_i) then
        Type_out_q <= Type_in_w;
    end if; 
end process;
IFG_or_w <= IFG_out_q(0) or IFG_out_q(1) or IFG_out_q(2) or IFG_out_q(3) or IFG_out_q(4) or IFG_out_q(5) or IFG_out_q(6);

INTR_o <= (GIE_i and IFG_or_w) or rst_out_q;
end architecture;