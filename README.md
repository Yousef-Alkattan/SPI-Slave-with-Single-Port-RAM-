# SPI Slave with Single Port RAM

This repository contains the RTL design, simulation, and implementation files for a Serial Peripheral Interface (SPI) communication system, including both master and slave modules.

---

## Introduction

This module implements a Serial Peripheral Interface (SPI) slave system with integrated RAM storage. The SPI slave receives data from an SPI master over the `MOSI` line and transmits data back over the `MISO` line. Received data is stored in a parameterized single-port RAM (`sp_RAM`) for later retrieval. The design is modular, separating the SPI protocol handling (`SPI_slave`) and memory storage (`sp_RAM`).

---

## SPI_slave Submodule Ports

| Signal Name    | Direction | Width      | Description                                |
|----------------|-----------|------------|--------------------------------------------|
| `clk`          | Input     | 1 bit      | System clock                               |
| `rst_n`        | Input     | 1 bit      | Active-low synchronous reset               |
| `SS_n`         | Input     | 1 bit      | Slave Select (active low)                  |
| `MOSI`         | Input     | 1 bit      | Master Out Slave In data line              |
| `MISO`         | Output    | 1 bit      | Master In Slave Out data line              |
| `rx_valid`     | Output    | 1 bit      | Indicates valid received data              |
| `tx_valid`     | Input     | 1 bit      | Indicates valid transmit data              |
| `rx_data`      | Output    | 10 bits    | Received data                              |
| `tx_data`      | Input     | 8 bits     | Data to transmit                           |

---

## sp_RAM Submodule Ports

| Signal Name    | Direction | Width      | Description                                |
|----------------|-----------|------------|--------------------------------------------|
| `clk`          | Input     | 1 bit      | System clock                               |
| `rst_n`        | Input     | 1 bit      | Active-low synchronous reset               |
| `din`          | Input     | 10 bits    | Data input                                 |
| `dout`         | Output    | 8 bits     | Data output                                |
| `rx_valid`     | Input     | 1 bit      | Received data valid                        |
| `tx_valid`     | Output    | 1 bit      | Transmit data valid                        |

---

## Directory Structure

- `No MOORE Bugs_team_project_report.pdf`  
  Project report documenting design, simulation results, implementation and Vivado screenshots.
  
- `SPI.v`  
  RTL code for the SPI Wrapper module.

- `SPI_slave.v`  
  RTL code for the SPI slave module.

- `sp_ram.v`  
  Single-port RAM used for data storage during SPI transactions.

- `SPI_tb.v`  
  SystemVerilog testbench for functional verification of the SPI system.

- `Constraints_basys3.xdc`  
  Constraints file for targeting the Basys3 FPGA board.

- `bitstream_project2.bit`  
  Generated FPGA bitstream for programming the hardware.

- `project_2_netlist.v`  
  Synthesized netlist of the design.

- `mem.dat`  
  Memory initialization file used in simulation.

- `run_slave.do`  
  ModelSim / QuestaSim simulation Do file for automating verification.

---

## Features

- SPI master and slave communication with configurable clock polarity and phase.
- Support for 8-bit data transfers.
- Synchronous data exchange between master and slave.
- On-chip RAM storage to buffer transmitted and received data.
- Synthesized and implemented on Basys3 FPGA.

---

## Screenshots

**Elaborated Circuit**

![Elaborated Circuit](./Elaborated%20Circuit.png)

**Synthesized Circuit**

![Synthesized Circuit](./Synthesized%20Circuit.png)

---

## Conclusion

This project implements and verifies a complete SPI communication system using Verilog and FPGA design flow. The modular approach facilitates clear separation between master, slave, and memory components. Functional simulation in QuestaSim validates correct protocol timing and data exchange, while synthesis and bitstream generation confirm the design’s readiness for deployment on hardware. This environment provides a reliable reference for SPI-based communication and can be extended for higher data widths or multiple slave configurations.
