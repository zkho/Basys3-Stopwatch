# Programmable Stopwatch/Timer (Basys3 FPGA)

RTL implementation of a programmable stopwatch and countdown timer in Verilog targeting the **Digilent Basys3** (Artix-7 FPGA) using **Xilinx Vivado**, developed for **ECE 316: Digital Logic Design** at UT Austin[cite: 1, 2, 3].

## Overview

The design drives all four multiplexed **7-segment displays** to show `SS.ss` (`00.00` to `99.99`), where the two most-significant digits represent **seconds** and the two least-significant digits represent **10 ms ticks** (`00`–`99` per second).

### Operating Modes

| Mode Select | Mode | Behavior |
| :---: | :--- | :--- |
| `00` | **Stopwatch (Up from `00.00`)** | Initializes at `00.00`; Start/Stop toggles counting up to `99.99` (halts at saturation); Reset returns to `00.00`[cite: 3]. |
| `01` | **Timer (Down from `99.99`)** | Initializes at `99.99`; Start/Stop toggles counting down to `00.00` (halts at `00.00`); Reset returns to `99.99`[cite: 3]. |
| `10` | **Preset Stopwatch (Up from Load)** | Counts up like Mode `00`, starting/resetting from a BCD seconds value (`00`–`99`) set via 8 preset switches[cite: 3, 4]. |
| `11` | **Preset Timer (Down from Load)** | Counts down like Mode `01`, starting/resetting from a BCD seconds value (`00`–`99`) set via 8 preset switches[cite: 3, 4]. |

## Architecture

Structured using standard RTL design methodology (HLSM / datapath + controller FSM):

- **Clock Divider / 10 ms Tick Generator:** Derives a `100 Hz` (`10 ms`) enable/tick from the Basys3 `100 MHz` system clock and a fast refresh clock for 7-segment multiplexing.
- **Datapath:** BCD digit counters (centiseconds tens/ones and seconds tens/ones), comparator/saturation logic (`99.99` / `00.00`), and preset load registers.
- **Controller FSM:** Manages idle, running, paused, terminal/expired, and reset/load transitions across modes `00`–`11`.
- **7-Segment Display Driver:** Multiplexes the four active-low anodes and drives the seven cathode segments (plus decimal point as applicable).

## Basys3 Hardware Mapping

| Signal / Function | Basys3 Hardware | Notes |
| :--- | :--- | :--- |
| System Clock | `100 MHz` oscillator (`W5`) | Mapped in `.xdc` constraints |
| Start / Stop | Pushbutton (`BTN...`) | Toggles counting state; debounce/edge-detect as implemented[cite: 3, 4] |
| Reset / Load | Pushbutton (`BTN...`) | Resets to `00.00`, `99.99`, or preset seconds depending on mode[cite: 3, 4] |
| Mode Select `[1:0]` | 2 Slide Switches (`SW...`) | Selects `00`, `01`, `10`, or `11`[cite: 4] |
| Preset Seconds `[7:0]` | 8 Slide Switches (`SW...`) | Two 4-bit BCD digits (`0000`–`1001` / `0`–`9` each) for tens and ones of seconds[cite: 3, 4] |
| Time Display | 4-Digit 7-Segment Display | `[MSB:LSB]` = `[Sec Tens, Sec Ones, 10ms Tens, 10ms Ones]`[cite: 3] |

## Repository Structure

```text
.
├── src/           # Verilog RTL source files (top-level, datapath, FSM, display driver)
├── sim/           # Testbenches for functional/behavioral verification
├── constraints/   # Vivado XDC pin & timing constraint files for Basys3
└── README.md
