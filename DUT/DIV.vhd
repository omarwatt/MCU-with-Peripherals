library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DIV is
    generic (
        BUS_WIDTH : INTEGER := 32
    );
    port (
        clk_i       : in  STD_LOGIC;
        rst_i       : in  STD_LOGIC;
        DIVENA_i    : in  STD_LOGIC;

        Dividend_i  : in  STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);
        Divisor_i   : in  STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);
        
        DIVBUSY_o   : out STD_LOGIC;
        Residue_o   : out STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);
        Quotient_o  : out STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of DIV is
    signal iter_q   : integer range 0 to BUS_WIDTH-1;
        
    signal quot_q   : STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);

    signal shift_q  : STD_LOGIC_VECTOR(2*BUS_WIDTH-1 downto 0);
    signal shift_w  : STD_LOGIC_VECTOR(2*BUS_WIDTH-1 downto 0);

    signal x_w      : STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);
    signal y_w      : STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);
    signal res_w    : STD_LOGIC_VECTOR(BUS_WIDTH-1 downto 0);

    signal DivBusy_q : std_logic;
begin
    shift_w <= shift_q(2*BUS_WIDTH-2 downto 0) & '0';
    y_w     <= shift_w(2*BUS_WIDTH-1 downto BUS_WIDTH);
    x_w     <= Divisor_i;
    res_w  <= STD_LOGIC_VECTOR(UNSIGNED(y_w) - UNSIGNED(x_w));
process (clk_i,rst_i)
begin
    if rst_i = '1' then
        shift_q     <=  x"00000000" & Dividend_i;
        quot_q      <= (others => '0'); 
        DivBusy_q   <= '0';
        iter_q      <= 0;
    elsif rising_edge(clk_i) then
        if DivBusy_q = '0' then
            if DIVENA_i = '1' then
                shift_q     <=  x"00000000" & Dividend_i;
                DivBusy_q   <= '1';
                quot_q      <= (others => '0'); 
            end if;
        else
            if UNSIGNED(y_w) >= UNSIGNED(x_w) then
                shift_q <= res_w & shift_w(BUS_WIDTH-1 downto 0);
                quot_q  <= quot_q(BUS_WIDTH-2 downto 0) & '1';
            else 
                shift_q <= shift_w;
                quot_q  <= quot_q(BUS_WIDTH-2 downto 0) & '0';
            end if; 

            if iter_q = BUS_WIDTH-1 then
                DivBusy_q <= '0';
                iter_q <= 0;
            else
                iter_q <= iter_q + 1;
            end if;
        end if;
    end if;
end process;

DIVBUSY_o   <= DivBusy_q;
Quotient_o  <= quot_q;    
Residue_o   <= shift_q(2*BUS_WIDTH-1 downto BUS_WIDTH);

end architecture;