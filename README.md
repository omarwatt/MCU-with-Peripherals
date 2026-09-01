# RISC-V MCU with Memory-Mapped Peripherals

## Project Overview

An FPGA microcontroller project integrating a 32-bit RISC-V-style processor with GPIO, a timer, UART, and interrupt handling. The work covers processor–peripheral integration, memory-mapped control, interrupt-driven firmware, and simulation of individual blocks and the complete MCU.

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

VHDL, RISC-V assembly/C benchmarks, Intel Quartus Prime, ModelSim/Questa, Intel `altsyncram` memories, and a Cyclone V FPGA.

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

![GPIO simulation](docs/images/gpio-waveform.png)
*MemWrite transactions update LEDR and HEX0–HEX5; MemRead returns switch patterns 0x55 and 0xAA on DataBus.*

![Basic Timer simulation](docs/images/timer-waveform.png)
*BTCNT_q counts to BTCMPR0 = 4 and reloads, while EQU0_w marks the compare event in this archived unit test.*

![Interrupt simulation](docs/images/interrupt-waveform.png)
*IFG, TYPE, INTR, and active-low INTA show interrupt requests, vector selection, and acknowledgement.*

![Processor simulation](https://github.com/omarwatt/MCU-with-Peripherals/blob/main/DOCS/images/cpu-waveform.png?raw=true)
*The archived waveform shows instruction execution through the program counter, register-write control, and ALU result.*

## Repository Structure

- `DUT/`: processor, peripherals, packages, memories, and board wrapper.
- `TB/`: block and MCU testbenches.
- `SIM/`: waveform configuration scripts.
- `Benchmark apps/`: example firmware and memory images.
- `QUARTUS/`: constraints and archived FPGA outputs.
- `DOC/`: project report.
- `docs/images/`: five selected design and results figures.

## How to Run

1. Configure a VHDL-2008 simulator with Intel's `altera_mf` simulation library.
2. Set `G_MODELSIM := 1` in `DUT/cond_compilation_package.vhd`.
3. Replace the absolute memory-image paths in `IFETCH.VHD` and `DMEMORY.VHD` with a matching instruction/data image pair.
4. Compile the packages, dependent DUT blocks, processor, MCU, and selected testbench in dependency order. Elaborate `tb_MCU` for system simulation.
5. Load the relevant waveform script under `SIM/` and run the testbench.

The waveform scripts do not compile the design. Match the MCU testbench's timer expectations to the selected firmware; its referenced fast-timer image is absent. Align the UART clock-frequency setting with the testbench clock before testing integrated serial communication.

## Attribution

Course project by **Omar Wattad**, using the supplied course framework. The UART derives from **Jakub Cabal's uart-for-fpga**; retain its original copyright and MIT license notices alongside the course-code attribution.
