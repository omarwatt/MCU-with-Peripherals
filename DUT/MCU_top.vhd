library ieee;
use ieee.std_logic_1164.all;
USE work.cond_compilation_package.all;
USE work.aux_package.all;

entity MCU_top is
    port (
        clk_i               : in  std_logic;
        SW_i                : in  std_logic_vector(9 downto 0);
        KEY0_i              : in  std_logic;
        KEY1_i              : in  std_logic;
        KEY2_i              : in  std_logic;
        KEY3_i              : in  std_logic;
        UART_RXD_i          : in  std_logic := '1';

        LEDR_o              : out std_logic_vector(9 downto 0);
        HEX0_o              : out std_logic_vector(6 downto 0);
        HEX1_o              : out std_logic_vector(6 downto 0);
        HEX2_o              : out std_logic_vector(6 downto 0);
        HEX3_o              : out std_logic_vector(6 downto 0);
        HEX4_o              : out std_logic_vector(6 downto 0);
        HEX5_o              : out std_logic_vector(6 downto 0);
        PWM_o               : out std_logic;
        UART_TXD_o          : out std_logic := '1'
    );
end entity;
architecture rtl of MCU_top is
    signal rst_w        : std_logic := '0';
    signal rst_ifg_w    : std_logic := '0';
begin


    MCU_Module : MCU port map(
        rst_i       => rst_w,
        clk_i       => clk_i,
        smclk_i     => clk_i,
        divclk_i    => clk_i,
        KEY0_i      => KEY0_i,
        KEY1_i      => KEY1_i,
        KEY2_i      => KEY2_i,
        KEY3_i      => KEY3_i,
        SW_i        => SW_i,
        UART_RXD_i  => UART_RXD_i,
        
        LEDR_o      => LEDR_o,
        HEX0_o      => HEX0_o,
        HEX1_o      => HEX1_o,
        HEX2_o      => HEX2_o,
        HEX3_o      => HEX3_o,
        HEX4_o      => HEX4_o,
        HEX5_o      => HEX5_o,
        PWM_o       => PWM_o,
        UART_TXD_o  => UART_TXD_o
    );

    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_ifg_w = '0' then
                rst_ifg_w <= '1';
                rst_w     <= '1';
            else
                rst_w <= '0';
            end if;
        end if;
    end process;

end architecture;