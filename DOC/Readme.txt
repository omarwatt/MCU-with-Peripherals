=====================================================================================================
FINAL PROJECT - RISCV-based MCU (Single-Cycle RV32IM Core + Memory-Mapped Peripherals + Interrupts)
Advanced CPU Architecture & Hardware Accelerators (361-1-4693) - Instructor: Hanan Ribo
Submitted by: Omar Wattad (207510819) , Fidaa Abo Aissa (324960996)
Target device: Intel Cyclone V  5CSXFC6D6F31C6  (DE10-Standard / DE-SoC board)
Tools: Quartus Prime 25.1std.0 | ModelSim | Signal-Tap | In-System Memory Content Editor (ISMCE) | RARS
=====================================================================================================

OVERVIEW
This project implements a complete RV32IM-based micro-controller (MCU) on an FPGA. The CPU is the
scalar single-cycle RV32IM core developed in LAB5, extended into a micro-controller by adding a
memory-mapped peripheral subsystem, an interrupt mechanism, a UART serial interface and a multicycle
unsigned division accelerator running in its own fast clock domain.

The design keeps the Harvard organisation of the core - separate ITCM (instruction) and DTCM (data)
tightly-coupled memories of 8 kB each. All peripherals are mapped into the Data Address Space above
the physical data memory (byte address 0x2000 and up) and share one bidirectional 32-bit Data BUS, so
the CPU accesses them with ordinary lw / sw instructions. The top level and the RV32IM core are both
structural. Push-button KEY0 is the system RESET (brings the PC to the first program instruction).

-----------------------------------------------------------------------------------------------------
CLOCKING
-----------------------------------------------------------------------------------------------------
baseclk 50 MHz -> Clock Tree / PLLs:
  MCLK    - core clock. Clocks the CPU, the bus, all peripherals and the MCLK counter.
  DIVCLK  - fast clock. Clocks the division accelerator only (32 DIVCLK cycles per 32-bit division).
  SMCLK   - peripheral clock source feeding the Basic Timer pre-scaler and the UART baud generator.
The MCLK and DIVCLK domains meet only through the Sync (CDC) block, so no combinational signal crosses
a clock boundary unregistered.

-----------------------------------------------------------------------------------------------------
CPU CORE SUB-MODULES  (RV32IM_CORE, structural)
-----------------------------------------------------------------------------------------------------

IFETCH (Ifetch:IFE)
Instruction-fetch stage. Holds the PC register and the PC+4 adder, contains the ITCM (8 kB, FPGA
embedded altsyncram), and selects the next PC through a mux choosing between PC+4, a branch/jump
target and - during an interrupt - the vector address supplied by the ISR sequence. Outputs the
fetched instruction and the current PC.

IDECODE (Idecode:ID)
Decode stage. Contains the RISC-V register file (32 x 32-bit, two read ports, one write port) and the
sign-extension / immediate-generation logic for I/S/B/U/J formats. Supplies read_data1 and read_data2
to EXECUTE and routes the write-back value into the destination register rd.

CONTROL (control:CTL)
Main control unit. Decodes opcode and funct fields into the datapath control signals: ALUOp, ALUSrc,
MULOp, DIVOp, Branch, Jal, Jalr, MemRead, MemWrite, MemtoReg, RegDst, RegWrite, UpperIm and WBSrc.
It also contains the multicycle ISR FSM (see "Interrupt service protocol" below) and handles PChold /
DIVbusy stalling while the division accelerator is busy.

EXECUTE (Execute:EXE)
Execute stage. Contains the ALU (add/sub, logic, shift, signed and unsigned comparison for branch
resolution), the 16-bit multiplier, branch-target / effective-address generation, and the result mux
that selects the value forwarded to memory / write-back (ALU result, multiplier result, divider
quotient/residue, memory data, PC+4 or the upper immediate).

16-BIT MULTIPLIER (mul)
Implements the mul instruction of the M-extension. mul rd, rs1, rs2 multiplies the lower 16-bit
half-words of rs1 and rs2 into a 32-bit product, built from four embedded 8-bit multipliers (DSP):
   P0 = A_low x B_low , P1 = A_low x B_high , P2 = A_high x B_low , P3 = A_high x B_high
   M  = P1 + P2 ,   RESULT = P0 + (M << 8) + (P3 << 16)
Purely combinational in the single-cycle core.

DMEMORY (dmemory:MEM)
Data-memory stage. Contains the DTCM (8 kB, FPGA embedded altsyncram) with the load/store interface,
clocked on not(clk) so a load can be fetched, decoded, address-computed and read in the same period.
It also hosts the bus interface logic: the address decoder that separates DTCM accesses from I/O
accesses, and the merge of the peripheral read data back onto the Data BUS.

MCLK COUNTER
A free-running cycle counter clocked by MCLK, cleared on reset; drives mclk_cnt_o.

-----------------------------------------------------------------------------------------------------
PERIPHERAL SUB-MODULES
-----------------------------------------------------------------------------------------------------

GPIO (GPIO_UNIT)
Eight memory-mapped GPIO peripherals: an optimized address decoder generates the chip-selects CS1..CSn
from Address<A4..A0>, MemWrite latches the Data BUS into the addressed port register, and MemRead with
the matching CS enables a tri-state driver (BidirPinDataBus) that returns the register onto the bus.
Each HEX port register passes through a 7-segment encoder (SSD.vhd) before leaving the block.
   PORT_LEDR 0x2000 (LEDR7-LEDR0, GPO)      PORT_HEX3 0x2009 (GPO)
   PORT_HEX0 0x2004 (GPO)                   PORT_HEX4 0x200C (GPO)
   PORT_HEX1 0x2005 (GPO)                   PORT_HEX5 0x200D (GPO)
   PORT_HEX2 0x2008 (GPO)                   PORT_SW   0x2010 (SW7-SW0, GPI)

PUSHBUTTONS (Pushbuttons / uart_debouncer)
PORT_PB (0x2014) exposes the three debounced pushbuttons KEY3-KEY1 as an input device. Each key is
debounced and edge-detected; the resulting pulse is an interrupt source (KEY1IFG / KEY2IFG / KEY3IFG)
towards the interrupt controller. KEY0 is NOT a peripheral - it is the system reset.

BASIC TIMER (BasicTimer)
32-bit up-mode timer with compare, PWM output and input capture.
   BTCTL1  0x201C  BTOUTMD | BTOUTEN | BTHOLD | BTSSEL | BTCLR | BTINT
   BTCTL2  0x201D  CAPMD | CAPISEL
   BTCMPR0 0x2020  compare/PWM value 0   (latched into BTCL0)
   BTCMPR1 0x2024  compare/PWM value 1   (latched into BTCL1)
   BTCAPR  0x2028  capture register
BTSSEL selects the counter clock from {SMCLK, SMCLK/2, SMCLK/4, SMCLK/8}. BTCNT counts up and is
cleared when it equals BTCL0, producing the periodic BTIFG interrupt (source selected by BTINT).
The Output Unit generates PWM_out in Output Mode0 (Set/Reset) or Mode1 (Reset/Set) from the BTCL0 /
BTCL1 comparisons. The capture path selects CAPIN1, CAPIN2, VCC or GND (CAPISEL), detects a rising or
falling edge (CAPMD) and latches BTCNT into BTCAPR on the event.

DIVISION ACCELERATOR (DIV + Sync)
Unsigned binary multicycle restoring divider, 32-bit. The dividend is held in a left-shift register,
the divisor in a register; each DIVCLK cycle the subtractor computes Y-X and a non-negative result
shifts a '1' into the quotient shift-register. Results (QUOTIENT, RESIDUE) are ready N=32 DIVCLK
cycles after the second operand is loaded; DIVBUSY stalls the CPU (PChold) meanwhile. Operands cross
from MCLK into DIVCLK through Sync.vhd - two cascaded DFF stages per operand (Ain, Bin) clocked by
DIVCLK, as required for a slow-to-fast clock-domain crossing, so no metastable value reaches the
divider datapath.

UART (uart, uart_tx, uart_rx, uart_parity, uart_debouncer)
USART peripheral in UART mode: 1 start bit, 8 data bits LSB-first, optional parity, 1 stop bit, with
independent transmit and receive shift registers and separate buffer registers.
   UCTL  0x2018  BUSY | OE | PE | FE | BAUDRATE | PEV | PENA | SWRST
   RXBF  0x2019  receive buffer  (reading it clears the receive error bits and RXIFG)
   TXBF  0x201A  transmit buffer (writing it clears TXIFG)
The baud-rate generator divides SMCLK to 9600 or 115200 (BAUDRATE bit). Status flags FE (framing),
PE (parity) and OE (overrun) are set by the receive control logic. RX and TX are independent
interrupt sources (RXIFG, TXIFG).

INTERRUPT CONTROLLER (InterruptControl)
   IE   0x202C  0 | 0 | KEY3IE  | KEY2IE  | KEY1IE  | BTIE  | TXIE  | RXIE
   IFG  0x202D  0 | 0 | KEY3IFG | KEY2IFG | KEY1IFG | BTIFG | TXIFG | RXIFG
   TYPE 0x202E  interrupt vector of the served source (read-only)
Each source drives a set-only flag flip-flop (clr_irq clears it). The flag is ANDed with its enable
bit, all masked requests are OR-ed together and gated by GIE to produce INTR towards the CPU. On INTA
the controller resolves the highest-priority pending source and drives its vector onto TYPE:
   00h RESET (NMI, highest) | 04h UART status error | 08h UART RX | 0Ch UART TX
   10h Basic Timer | 14h KEY1 | 18h KEY2 | 1Ch KEY3 (lowest)
BTIFG, RXIFG and TXIFG are cleared automatically when serviced (RXIFG also on RXBF read, TXIFG also on
TXBF write); the KEYiIFG flags are cleared by software.

SSD (SSD.vhd)
Combinational 4-bit-to-7-segment encoder instantiated once per HEX port inside the GPIO block.

-----------------------------------------------------------------------------------------------------
INTERRUPT SERVICE PROTOCOL (multicycle FSM inside CONTROL)
-----------------------------------------------------------------------------------------------------
The FSM is triggered by the falling edge of INTA, the cycle after the controller sets INTR = '1'. The
next PC at that moment is the interrupt return address.
Servicing (2-cycle latency):
  Cycle 1 : clear GIE (gp[0] = 0) in HW ; set INTA = '1' ; drive the TYPE content onto the Data BUS
            and capture it into a dedicated register (TYPE cannot go on the Address BUS - the CPU is
            the only bus master).
  Cycle 2 : if the pending source is synchronous, clear its flag (e.g. BTIFG) ; emulate load of the
            TYPE content followed by jalr to Mem[TYPE], with R[tp] = interrupt return address.
Return (1-cycle latency):
  As part of executing "jalr zero, 0(tp)" (reti), GIE is set again in HW.

-----------------------------------------------------------------------------------------------------
SYSTEM TOP ENTITY  (MCU_top.vhd, structural)
-----------------------------------------------------------------------------------------------------
Inputs : clk_i (50 MHz -> PLLs), KEY0 (system reset), KEY3-KEY1 (pushbutton peripheral / interrupts),
         SW9-SW0, CAPIN1, CAPIN2, UART_RXD
Outputs: LEDR9-LEDR0, HEX5-HEX0, PWM_o, UART_TXD
Submodules: RV32IM_CORE (CPU) , GPIO_UNIT , TIMER_UNIT , IC_UNIT , UART_UNIT , DIV + Sync ,
            PLL \G0:MCLK , PLL \G0:DIVCLK , MCLK counter.
Observation ports (Signal-Tap, removed from the final build through the generate parameter):
PC_o, Instruction_o, INTA_o, GIE_o, INTR_o, MemRead_ctrl_o, MemWrite_ctrl_o, RegWrite_ctrl_o,
alu_res_o, dtcm_addr_o, dtcm_data_wr_o, dtcm_data_rd_o, mclk_cnt_o.

-----------------------------------------------------------------------------------------------------
FPGA I/O INTERFACE  (Cyclone V 5CSXFC6D6F31C6, DE10-Standard)
-----------------------------------------------------------------------------------------------------
  CLK 50 MHz - board oscillator, feeds the PLLs that generate MCLK / DIVCLK / SMCLK.
  KEY0       - system RESET (brings the PC to the first program instruction).
  KEY3-KEY1  - debounced pushbutton peripheral PORT_PB and interrupt sources.
  SW9-SW0    - PORT_SW input peripheral (SW7-SW0 readable by the CPU).
  LEDR9-LEDR0- PORT_LEDR output peripheral.
  HEX5-HEX0  - six 7-segment displays driven by PORT_HEX5..PORT_HEX0 through the SSD encoders.
  PWM_o      - Basic Timer PWM output.
  UART_TXD / UART_RXD - RS-232 link to the PC through the USB-to-serial (FTDI) bridge.
Only the MCU I/O devices are assigned in the Pin Planner; the Signal-Tap observation pins are removed
in the final compilation.

Data flow summary
  switches / keys / UART_RXD -> peripheral registers -> Data BUS -> RV32IM core (fetch -> decode ->
  execute / multiply / divide -> data memory -> write-back) -> Data BUS -> peripheral registers ->
  LEDR / HEX / PWM / UART_TXD , with INTR / INTA closing the interrupt loop between IC_UNIT and CPU.

-----------------------------------------------------------------------------------------------------
VERIFICATION FLOW
-----------------------------------------------------------------------------------------------------
1. Unit level - each peripheral is driven by its own test bench over the memory-mapped interface:
   gpio_tb , basictimer_tb , interruptcontrol_tb , uart_tb , div_tb.
2. System level - tb_mcu runs the benchmark applications test1..test4 out of the ITCM while the CPU
   and every peripheral instance are observed simultaneously.
3. Golden model - at the end of each run the ModelSim DTCM.mem output is compared against the RARS
   DTCM.hex golden file; on the board the ISMCE DTCM.hex read-back is compared against the same file.
4. On-board - Signal-Tap captures the observation ports live; ISMCE inspects ITCM and DTCM contents.

-----------------------------------------------------------------------------------------------------
PPA SUMMARY (Quartus Prime 25.1std.0, Cyclone V 5CSXFC6D6F31C6, Slow 1100 mV 85 C)
-----------------------------------------------------------------------------------------------------
  MCU with GPIO                    : 1,886 ALMs , 1,701 registers , 4 DSP , 2 PLLs , 131,072 mem bits
                                     Fmax(MCLK) = 28.72 MHz , total power 453.88 mW
  MCU with GPIO + Interrupt (+UART, +DIV)
                                   : 2,025 ALMs , 1,741 registers , 4 DSP , 3 PLLs , 131,072 mem bits
                                     Fmax(MCLK) = 28.46 MHz , DIVCLK = 144.97 MHz , total 455.06 mW
  f_MCLK = f_sysclk <= Fmax in every configuration. Full tables and report screenshots are in
  DOC/Final_report.pdf.

-----------------------------------------------------------------------------------------------------
SUBMISSION DIRECTORY STRUCTURE
-----------------------------------------------------------------------------------------------------
DUT/RV32IMscMCU         - design VHDL files only (no test benches):
                          MCU_top.vhd, RV32IM_CORE.vhd, Ifetch.vhd, Idecode.vhd, CONTROL.vhd,
                          Execute.vhd, dmemory.vhd, GPIO.vhd, SSD.vhd, Pushbuttons.vhd,
                          BasicTimer.vhd, InterruptControl.vhd, DIV.vhd, Sync.vhd, uart.vhd,
                          uart_tx.vhd, uart_rx.vhd, uart_parity.vhd, uart_debouncer.vhd, PLL_SM.vhd
DUT/RV32IMpipelinedMCU  - (bonus) pipelined variant of the same design
TB/RV32IMscMCU          - tb_RV32IMscMCU.vhd
TB/RV32IMpipelinedMCU   - (bonus) tb_RV32IMpipelinedMCU.vhd
SIM/RV32IMscMCU         - ModelSim *.do script
SIM/RV32IMpipelinedMCU  - (bonus) ModelSim *.do script
DOC                     - this Readme.txt and Final_report.pdf
Quartus/RV32IMscMCU     - Signal-Tap file, SDC file, SOF file
Quartus/RV32IMpipelinedMCU - Signal-Tap file, SDC file, SOF file

Both the ModelSim and the Quartus projects compile without errors.
=====================================================================================================
