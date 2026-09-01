library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
USE work.aux_package.all;

entity GPIO is
    generic (
        BUS_WIDTH : positive := 32
    );
    port (
        clk_i       : in  std_logic;
        rst_i       : in  std_logic;
        IOpin_io    : inout std_logic_vector(BUS_WIDTH-1 downto 0);

        MemWrite_i  : in  std_logic;
        MemRead_i   : in  std_logic;
        Address_i   : in  std_logic_vector(5 downto 0); -- A13, A5--A2, A0
        SW_i        : in  std_logic_vector(7 downto 0);
        
        PORT_LEDR_o      : out std_logic_vector(7 downto 0);
        PORT_HEX0_o      : out std_logic_vector(6 downto 0);
        PORT_HEX1_o      : out std_logic_vector(6 downto 0);
        PORT_HEX2_o      : out std_logic_vector(6 downto 0);
        PORT_HEX3_o      : out std_logic_vector(6 downto 0);
        PORT_HEX4_o      : out std_logic_vector(6 downto 0);
        PORT_HEX5_o      : out std_logic_vector(6 downto 0)  
    );
end GPIO;

architecture rtl of GPIO is
    alias  A0 : std_logic is Address_i(0);
    signal Din,Dout : std_logic_vector(BUS_WIDTH-1 downto 0);
    signal en : std_logic;
    signal CS_w : std_logic_vector(4 downto 0);
    signal EN1_w, EN2_w, EN3_w, EN4_w, EN5_w, EN6_w, EN7_w : std_logic;

    signal PORT_LEDR_q : std_logic_vector(7 downto 0);
    signal PORT_HEX0_q,PORT_HEX1_q,PORT_HEX2_q : std_logic_vector(7 downto 0);
    signal PORT_HEX3_q,PORT_HEX4_q,PORT_HEX5_q : std_logic_vector(7 downto 0);
begin
    with Address_i(5 downto 1) select
        CS_w <= "00001" when "10000",
                "00010" when "10001",
                "00100" when "10010",
                "01000" when "10011",
                "10000" when "10100",
                (others => '0') when others; 

    DataBus: BidirPin generic map(width => BUS_WIDTH) port map(Dout => Dout, en => en, Din => Din, IOpin => IOpin_io);
    en      <= '1' when (CS_w(4) = '1' and MemRead_i = '1') else '0';
    Dout(31 downto 8)   <= (others => '0');
    Dout(7 downto 0)    <= SW_i;

    EN1_w   <= '1' when CS_w(0) = '1' and MemWrite_i ='1' else '0';
    EN2_w   <= '1' when CS_w(1) = '1' and MemWrite_i ='1' and A0 = '0' else '0';
    EN3_w   <= '1' when CS_w(1) = '1' and MemWrite_i ='1' and A0 = '1' else '0';
    EN4_w   <= '1' when CS_w(2) = '1' and MemWrite_i ='1' and A0 = '0' else '0';
    EN5_w   <= '1' when CS_w(2) = '1' and MemWrite_i ='1' and A0 = '1' else '0';
    EN6_w   <= '1' when CS_w(3) = '1' and MemWrite_i ='1' and A0 = '0' else '0';
    EN7_w   <= '1' when CS_w(3) = '1' and MemWrite_i ='1' and A0 = '1' else '0';
    process (clk_i,rst_i)
    begin
        if rst_i = '1' then
            PORT_LEDR_q <= (others => '0'); 
            PORT_HEX0_q <= (others => '0'); 
            PORT_HEX1_q <= (others => '0'); 
            PORT_HEX2_q <= (others => '0'); 
            PORT_HEX3_q <= (others => '0'); 
            PORT_HEX4_q <= (others => '0'); 
            PORT_HEX5_q <= (others => '0');
        elsif falling_edge(clk_i) then
            if      EN1_w = '1' then
                PORT_LEDR_q <= Din(7 downto 0);
            elsif   EN2_w = '1' then
                PORT_HEX0_q <= Din(7 downto 0);
            elsif   EN3_w = '1' then
                PORT_HEX1_q <= Din(7 downto 0);
            elsif   EN4_w = '1' then
                PORT_HEX2_q <= Din(7 downto 0);
            elsif   EN5_w = '1' then
                PORT_HEX3_q <= Din(7 downto 0);
            elsif   EN6_w = '1' then
                PORT_HEX4_q <= Din(7 downto 0);
            elsif   EN7_w = '1' then
                PORT_HEX5_q <= Din(7 downto 0);
            end if;
        end if;
    end process;

    PORT_LEDR_o <= PORT_LEDR_q;
    HEX0: SSD port map (ABCD_i => PORT_HEX0_q(3 downto 0), Hex_o => PORT_HEX0_o);
    HEX1: SSD port map (ABCD_i => PORT_HEX1_q(3 downto 0), Hex_o => PORT_HEX1_o);
    HEX2: SSD port map (ABCD_i => PORT_HEX2_q(3 downto 0), Hex_o => PORT_HEX2_o);
    HEX3: SSD port map (ABCD_i => PORT_HEX3_q(3 downto 0), Hex_o => PORT_HEX3_o);
    HEX4: SSD port map (ABCD_i => PORT_HEX4_q(3 downto 0), Hex_o => PORT_HEX4_o);
    HEX5: SSD port map (ABCD_i => PORT_HEX5_q(3 downto 0), Hex_o => PORT_HEX5_o);
    
end architecture;
