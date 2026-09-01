--------------------------------------------------------------------------------
-- PROJECT: SIMPLE UART FOR FPGA
--------------------------------------------------------------------------------
-- MODULE:  UART PARITY BIT GENERATOR
-- AUTHORS: Jakub Cabal <jakubcabal@gmail.com>
-- LICENSE: The MIT License (MIT), please read LICENSE file
-- WEBSITE: https://github.com/jakubcabal/uart-for-fpga
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.aux_package.all;

entity UART_PARITY is
    Generic (
        DATA_WIDTH  : integer := 8
    );
    Port (
        DATA_IN     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        PEV_i       : in  std_logic;
        PARITY_OUT  : out std_logic
    );
end UART_PARITY;

architecture FULL of UART_PARITY is

begin

    -- -------------------------------------------------------------------------
    -- PARITY BIT GENERATOR
    -- -------------------------------------------------------------------------

    parity_g :
        process (all)
        	variable parity_temp : std_logic;
        begin
            parity_temp := '0';
            for i in DATA_IN'range loop
                parity_temp := parity_temp XOR DATA_IN(i);
            end loop;
            if PEV_i = '1' then
                PARITY_OUT <= parity_temp;
            else
                PARITY_OUT <= not parity_temp;
            end if;
        end process;


end FULL;
