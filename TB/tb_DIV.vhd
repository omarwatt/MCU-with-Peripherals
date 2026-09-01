LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_DIV IS
END tb_DIV;

ARCHITECTURE sim OF tb_DIV IS

  CONSTANT W       : INTEGER := 32;
  CONSTANT CLK_T   : TIME    := 10 ns;
  CONSTANT TRACE_N : INTEGER := 8;      -- how many cycles to trace per case

  SIGNAL clk_i      : STD_LOGIC := '0';
  SIGNAL rst_i      : STD_LOGIC := '0';
  SIGNAL DIVENA_i   : STD_LOGIC := '0';
  SIGNAL DIVBUSY_o  : STD_LOGIC;
  SIGNAL Dividend_i : STD_LOGIC_VECTOR(W-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL Divisor_i  : STD_LOGIC_VECTOR(W-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL Residue_o  : STD_LOGIC_VECTOR(W-1 DOWNTO 0);
  SIGNAL Quotient_o : STD_LOGIC_VECTOR(W-1 DOWNTO 0);

  -- probes onto the DUT internals
  SIGNAL shift_probe : STD_LOGIC_VECTOR(2*W-1 DOWNTO 0);
  SIGNAL res_probe   : STD_LOGIC_VECTOR(W-1 DOWNTO 0);
  SIGNAL y_probe     : STD_LOGIC_VECTOR(W-1 DOWNTO 0);

  SIGNAL sim_done : BOOLEAN := FALSE;
  SIGNAL errors   : NATURAL := 0;
  SIGNAL checks   : NATURAL := 0;

  ---------------------------------------------------------------------------
  -- helpers
  ---------------------------------------------------------------------------
  FUNCTION hx(v : STD_LOGIC_VECTOR) RETURN STRING IS
    CONSTANT d : STRING(1 TO 16) := "0123456789ABCDEF";
    VARIABLE n : INTEGER := v'length/4;
    VARIABLE s : STRING(1 TO v'length/4);
    VARIABLE u : UNSIGNED(v'length-1 DOWNTO 0) := UNSIGNED(v);
  BEGIN
    IF is_x(v) THEN
      RETURN (1 TO v'length/4 => 'U');
    END IF;
    FOR i IN 0 TO n-1 LOOP
      s(n-i) := d(TO_INTEGER(u(4*i+3 DOWNTO 4*i)) + 1);
    END LOOP;
    RETURN s;
  END FUNCTION;

  -- -1 stands for "unknown", so a 'U' prints as data instead of aborting
  FUNCTION iv(v : STD_LOGIC_VECTOR) RETURN INTEGER IS
  BEGIN
    IF is_x(v) THEN RETURN -1; END IF;
    IF v'length > 31 THEN
      IF UNSIGNED(v) > 2147483647 THEN RETURN -2; END IF;   -- too big for INTEGER
    END IF;
    RETURN TO_INTEGER(UNSIGNED(v));
  END FUNCTION;

BEGIN

  dut : ENTITY work.DIV
    GENERIC MAP ( BUS_WIDTH => W )
    PORT MAP (
      clk_i      => clk_i,
      rst_i      => rst_i,
      DIVENA_i   => DIVENA_i,
      DIVBUSY_o  => DIVBUSY_o,
      Dividend_i => Dividend_i,
      Divisor_i  => Divisor_i,
      Residue_o  => Residue_o,
      Quotient_o => Quotient_o
    );

  -- External names, as concurrent assignments AFTER the instantiation.
  shift_probe <= << signal dut.shift_q : STD_LOGIC_VECTOR(2*W-1 DOWNTO 0) >>;
  res_probe   <= << signal dut.res_w   : STD_LOGIC_VECTOR(W-1 DOWNTO 0) >>;
  y_probe     <= << signal dut.y_w     : STD_LOGIC_VECTOR(W-1 DOWNTO 0) >>;

  clk_i <= NOT clk_i AFTER CLK_T/2 WHEN NOT sim_done ELSE '0';

  ---------------------------------------------------------------------------
  main : PROCESS

    PROCEDURE chk(cond : BOOLEAN; nm : STRING) IS
    BEGIN
      checks <= checks + 1;
      IF cond THEN
        REPORT "  pass : " & nm;
      ELSE
        errors <= errors + 1;
        REPORT "  FAIL : " & nm SEVERITY ERROR;
      END IF;
    END PROCEDURE;

    PROCEDURE run_div(dividend, divisor : STD_LOGIC_VECTOR(W-1 DOWNTO 0);
                      trace : BOOLEAN) IS
      VARIABLE busy_cycles : NATURAL := 0;
    BEGIN
      -- reset between cases so each starts from a known state
      rst_i <= '1';
      WAIT UNTIL rising_edge(clk_i);
      WAIT UNTIL rising_edge(clk_i);
      rst_i <= '0';

      Dividend_i <= dividend;
      Divisor_i  <= divisor;
      WAIT UNTIL rising_edge(clk_i);
      WAIT FOR 1 ns;
      
      DIVENA_i <= '1';

      FOR i IN 1 TO W LOOP
        WAIT UNTIL rising_edge(clk_i);
        WAIT FOR 1 ns;
        IF DIVBUSY_o = '1' THEN busy_cycles := busy_cycles + 1; END IF;
        IF trace AND i <= TRACE_N THEN
          REPORT "    " & INTEGER'IMAGE(i) &
                 "   | " & hx(shift_probe(2*W-1 DOWNTO W)) &
                 "         | " & hx(shift_probe(W-1 DOWNTO 0)) &
                 "         | " & hx(res_probe) &
                 "   | " & STD_LOGIC'IMAGE(DIVBUSY_o)(2);
        END IF;
      END LOOP;

      DIVENA_i <= '0';
      WAIT UNTIL rising_edge(clk_i);
      WAIT FOR 1 ns;

      REPORT "    DIVBUSY was high for " & INTEGER'IMAGE(busy_cycles) & " of "
           & INTEGER'IMAGE(W) & " cycles";
    END PROCEDURE;

    -----------------------------------------------------------------------
    PROCEDURE case_div(dividend, divisor, eq, er : STD_LOGIC_VECTOR(W-1 DOWNTO 0);
                       nm : STRING; trace : BOOLEAN := FALSE) IS
    BEGIN
      REPORT "--- " & nm & " :  " & hx(dividend) & " / " & hx(divisor)
           & "   expect Q=" & hx(eq) & " R=" & hx(er);
      run_div(dividend, divisor, trace);
      REPORT "    got   Q=" & hx(Quotient_o) & "  R=" & hx(Residue_o);
      REPORT "    internal shift_q upper (should equal the residue) = "
           & hx(shift_probe(2*W-1 DOWNTO W));
      chk(NOT is_x(Quotient_o), nm & " : Quotient_o is driven");
      chk(NOT is_x(Residue_o),  nm & " : Residue_o is driven");
      chk(Quotient_o = eq,      nm & " : quotient correct");
      chk(Residue_o  = er,      nm & " : residue correct");
    END PROCEDURE;

  BEGIN
    REPORT "############### DIV accelerator testbench ###############";
    REPORT "";

    -------------------------------------------------------------------
    REPORT "=== output-driven check before anything runs ===";
    -------------------------------------------------------------------
    rst_i <= '1';
    WAIT FOR 45 ns;
    rst_i <= '0';
    WAIT FOR 20 ns;
    chk(NOT is_x(DIVBUSY_o),  "DIVBUSY_o is driven after reset");
    chk(NOT is_x(Quotient_o), "Quotient_o is driven after reset");
    chk(NOT is_x(Residue_o),  "Residue_o is driven after reset");
    REPORT "";

    -------------------------------------------------------------------
    REPORT "=== traced run : the PDF example, 100 / 7 ===";
    REPORT "    Expected hand trace: quotient 14 (0x0E), residue 2.";
    REPORT "    Each cycle the register should shift left one place, the upper";
    REPORT "    half is Y, and Y-X is written back only when it is non-negative.";
    -------------------------------------------------------------------
    case_div(x"00000064", x"00000007", x"0000000E", x"00000002",
             "PDF example 100/7", TRACE => TRUE);
    REPORT "";

    -------------------------------------------------------------------
    REPORT "=== vector cases ===";
    -------------------------------------------------------------------
    case_div(x"00000001", x"00000001", x"00000001", x"00000000", "1 / 1");
    case_div(x"00000000", x"00000005", x"00000000", x"00000000", "0 / 5");
    case_div(x"00000007", x"00000064", x"00000000", x"00000007", "7 / 100  divisor > dividend");
    case_div(x"0000000D", x"00000003", x"00000004", x"00000001", "13 / 3");
    case_div(x"FFFFFFFF", x"00000001", x"FFFFFFFF", x"00000000", "max / 1");
    case_div(x"FFFFFFFF", x"0000FFFF", x"00010001", x"00000000", "max / 65535");
    case_div(x"075BCD15", x"000003E8", x"0001E240", x"00000315", "123456789 / 1000");
    case_div(x"80000000", x"00000002", x"40000000", x"00000000", "MSB set, proves unsigned");
    -- RISC-V unprivileged spec: DIVU by zero returns all ones, REMU returns the
    -- dividend. A restoring divider produces exactly that with no special case.
    case_div(x"00000064", x"00000000", x"FFFFFFFF", x"00000064", "100 / 0  divide by zero");
    REPORT "";

    -------------------------------------------------------------------
    REPORT "############### summary ###############";
    REPORT "  checks run : " & INTEGER'IMAGE(checks);
    REPORT "  failures   : " & INTEGER'IMAGE(errors);
    IF errors = 0 THEN
      REPORT "  ALL TESTS PASSED";
    ELSE
      REPORT "  SOME TESTS FAILED" SEVERITY WARNING;
    END IF;

    sim_done <= TRUE;
    WAIT;
  END PROCESS;

END sim;