# RISC-V MCU with Memory-Mapped Peripherals

## Project Overview

An FPGA microcontroller project integrating a 32-bit RISC-V-style processor with GPIO, a timer, UART, and interrupt handling. The work covers processor–peripheral integration, memory-mapped control, interrupt-driven firmware, simulation, and on-board verification using Signal Tap.

## Main Features

- Separate 8 KiB instruction and 8 KiB data memories.
- GPIO for eight switches, eight LEDs, and six seven-segment displays.
- Timer with selectable clock division, compare events, PWM, and edge capture.
- UART transmit/receive registers, status flags, and configurable parity and baud selection.
- Prioritized interrupts from UART, timer, and external keys.
- Hardware multiplication and a multicycle divider, with implementation restrictions described below.

## Architecture

`MCU.vhd` connects the processor, memories, address decoding, and peripherals. The processor uses a single-cycle datapath with multicycle sequences for division and interrupt entry. `MCU_top.vhd` provides the board-facing wrapper.

Interrupt handling uses custom vectors, an active-low acknowledge, `gp[0]` as a software interrupt-enable bit, and `tp` to hold the return address. This is a project-specific mechanism rather than the standard RISC-V privileged interrupt architecture.

![GPIO RTL structure](https://github.com/omarwatt/MCU-with-Peripherals/blob/main/DOCS/images/gpio-rtl.png?raw=true)
*Address decoding selects the GPIO registers and display outputs.*

## Tools and Technologies

VHDL, RISC-V assembly/C benchmarks, Intel Quartus Prime, ModelSim/Questa, Signal Tap Logic Analyzer, Intel `altsyncram` memories, and the DE10-Standard FPGA board.

## Simulation and Results

The archive contains block-level testbenches and an MCU testbench. UART and MCU tests include assertions; other tests also use directed stimulus and waveform inspection.

`DOC/pre.pdf` reports the following for the GPIO-and-interrupt configuration on Cyclone V `5CSXFC6D6F31C6`:

| Metric | Reported result |
| --- | ---: |
| ALMs | 2,017 |
| Registers | 1,743 |
| Memory bits | 131,072 |
| MCLK Fmax, slow 85°C corner | 29.09 MHz |

These are archived implementation results, not a newly reproduced build.

![GPIO simulation](https://github.com/omarwatt/MCU-with-Peripherals/blob/main/DOCS/images/gpio-waveform.png?raw=true)
*MemWrite transactions update LEDR and HEX0–HEX5; MemRead returns switch patterns 0x55 and 0xAA on DataBus.*

![Basic Timer simulation](https://github.com/omarwatt/MCU-with-Peripherals/blob/main/DOCS/images/timer-waveform.png?raw=true)
*BTCNT_q counts to BTCMPR0 = 4 and reloads, while EQU0_w marks the compare event in this archived unit test.*

![Interrupt simulation](https://github.com/omarwatt/MCU-with-Peripherals/blob/main/DOCS/images/interrupt-waveform.png?raw=true)
*IFG, TYPE, INTR, and active-low INTA show interrupt requests, vector selection, and acknowledgement.*

### On-Board Verification with Signal Tap

![On-board MCU Signal Tap capture](https://github.com/omarwatt/MCU-with-Peripherals/blob/main/DOCS/images/signal-tap-verification.png?raw=true)
*The hardware capture shows the program counter, instruction words, advancing MCLK counter, and GPIO outputs during execution on the DE10-Standard board.*

The MCU was programmed onto the DE10-Standard board, and internal processor signals and peripheral outputs were captured using Signal Tap. The archived capture appears in `DOC/pre.pdf`, Figure 21 on page 14; `QUARTUS/stp1.stp` contains the Signal Tap session and recorded data.

- **Instruction execution:** the program counter advances through addresses including `0x00AC`–`0x00CC` and returns to the program loop, with instruction words captured alongside it.
- **Clock activity:** the MCLK counter advances from `0xF54E` to `0xF55D` in the displayed window, showing continued processor-clock activity.
- **Peripheral outputs:** `HEX0 = 0x78` and `HEX1 = 0x02` retain the programmed display values; `HEX2`–`HEX5` show `0x40`, and `LEDR` is zero. `PWM_o` is low and `UART_TXD` is high during this window.

The report compares the captured instruction flow and GPIO output states with the ModelSim benchmark run. This provides on-board evidence of processor execution and peripheral integration. The displayed idle UART and PWM levels do not independently verify serial transfers or PWM timing.

## Repository Structure

- `DUT/`: processor, peripherals, packages, memories, and board wrapper.
- `TB/`: block and MCU testbenches.
- `SIM/`: waveform configuration scripts.
- `Benchmark apps/`: example firmware and memory images.
- `QUARTUS/`: constraints, archived FPGA outputs, and the `stp1.stp` Signal Tap session.
- `DOC/`: project report.
- `docs/images/`: five selected design and results figures.

## How to Run

1. Configure a VHDL-2008 simulator with Intel's `altera_mf` simulation library.
2. Set `G_MODELSIM := 1` in `DUT/cond_compilation_package.vhd`.
3. Replace the absolute memory-image paths in `IFETCH.VHD` and `DMEMORY.VHD` with a matching instruction/data image pair.
4. Compile the packages, dependent DUT blocks, processor, MCU, and selected testbench in dependency order. Elaborate `tb_MCU` for system simulation.
5. Load the relevant waveform script under `SIM/` and run the testbench.

The waveform scripts do not compile the design. Match the MCU testbench's timer expectations to the selected firmware; its referenced fast-timer image is absent. Align the UART clock-frequency setting with the testbench clock before testing integrated serial communication.

To inspect the hardware verification, open `QUARTUS/stp1.stp` in Quartus Signal Tap and select the saved acquisition. For a new capture, connect the board through JTAG and use a matching FPGA programming file and Signal Tap configuration. Update the session's original absolute `.sof` path for your environment.

## Attribution

Course project by **Omar Wattad**, using the supplied course framework. The UART derives from **Jakub Cabal's uart-for-fpga**; retain its original copyright and MIT license notices alongside the course-code attribution.
