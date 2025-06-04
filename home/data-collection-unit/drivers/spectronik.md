---
title: Spectronik
---






# Spectronik Driver

This document outlines the C++ driver for the Spectronik Protium-1000/2500 fuel cell system, facilitating communication via UART. It adheres to the Protium UART Specification.

For the comprehensive Protium UART Specification, please consult the project's documentation: [Protium UART Specification](home/data-collection-unit/documentation/spectronik).

---
<!-- TOC -->
<!-- TOC -->
* [1. Core Components](#1-core-components)
  * [1.1 `ProtiumData` Class: The Data Hub](#11-protiumdata-class-the-data-hub)
  * [1.2 `Spectronik` Class: The Communication Orchestrator](#12-spectronik-class-the-communication-orchestrator)
* [2. Data Processing & Logging](#2-data-processing--logging)
  * [2.1 Parsing Logic:](#21-parsing-logic)
  * [2.2 Logging Output - `ProtiumData::toString()` method](#22-logging-output---protiumdatatostring-method)
  * [2.3 Output Customization & Format:](#23-output-customization--format)
  * [2.4 Example Output (if ALL `PARSE_...` flags in `Config::Spectronik` were `true`):](#24-example-output-if-all-parse_-flags-in-configspectronik-were-true)
* [3. Configuration Driven Behavior](#3-configuration-driven-behavior)
* [Contact](#contact)
<!-- TOC -->
---

## 1. Core Components

### 1.1 `ProtiumData` Class: The Data Hub

The `ProtiumData` class is the central structure for holding parsed sensor values received from the Protium system's UART output, specifically from its "running phase" messages. It inherits from `ILoggable` for standardized logging capabilities.

**Key Data Fields:**

The class encapsulates a comprehensive set of readings. Note that the actual data parsed and logged can be configured via `PARSE_...` flags in `Config::Spectronik`.

*   **Fuel Cell Metrics:**
    *   `FuelCellVoltage` (float): Fuel cell voltage (from `FC_V`, Unit: V)
    *   `FuelCellCurrent` (float): Fuel cell current (from `FC_A`, Unit: A)
    *   `FuelCellPower` (float): Fuel cell power (from `FC_W`, Unit: W)
    *   `EnergyConsumed` (float): Total energy consumed (from `Energy`, Unit: Wh)
    *   `FuelCellTemperature1` (float): Primary fuel cell temperature (from `FCT1`, Unit: °C)
    *   `FanPercentage` (uint8_t): Fan speed/status percentage (from `FAN`, Unit: %)
    *   `NumberOfCells` (uint16_t): Number of cells in the fuel stack (from `Number_of_cell`)
*   **Hydrogen System:**
    *   `H2PressureSensor1` (float): Hydrogen pressure at sensor 1 (from `H2P1`, Unit: Bar)
    *   `H2PressureSensor2` (float): Hydrogen pressure at sensor 2 (from `H2P2`, Unit: Bar)
    *   `H2TankPressure` (float): Hydrogen tank pressure (from `Tank-P`, Unit: Bar)
    *   `H2TankTemperature` (float): Hydrogen tank temperature (from `Tank-T`, Unit: °C)
*   **Power System & Control:**
    *   `VoltageSetpoint` (float): Target voltage setpoint (from `V_Set`, Unit: V)
    *   `CurrentSetpoint` (float): Target current setpoint (from `I_Set`, Unit: A)
    *   `SuperCapacitorVoltage` (float): Super capacitor voltage (from `UCB_V`, Unit: V)
*   **Stasis System:**
    *   `StasisSelector` (uint8_t): Stasis system selector state (from `Stasis_selector`)
    *   `StasisValve1Pressure` (float): Pressure at stasis valve 1 (from `STASIS_V1`, Unit: Bar)
    *   `StasisValve2Pressure` (float): Pressure at stasis valve 2 (from `STASIS_V2`, Unit: Bar)
*   **State & Timestamping:**
    *   `timestamp` (uint64_t): Timestamp of data reception (from `ILoggable` base, via `updateTimestamp()`).
    *   `valid` (bool): Indicates if the data parsing was successful and the object contains valid data (from `ILoggable` base).

---

### 1.2 `Spectronik` Class: The Communication Orchestrator

The `Spectronik` class manages all aspects of UART communication with the Protium system.

**Key Responsibilities:**

*   **Initialization & UART Management:**
    *   `Spectronik(UART_HandleTypeDef *huart)`: Constructor, requires a HAL UART handle.
    *   `init()`: Starts UART DMA reception (`HAL_UARTEx_ReceiveToIdle_DMA`).
    *   `~Spectronik()`: Destructor, stops UART DMA.
*   **Data Handling:**
    *   `register_data(ILoggable *data)`: Registers a `ProtiumData` object (via `dynamic_cast`) to store parsed data.
    *   `uartRxEventCallback(UART_HandleTypeDef *huart, uint16_t Size)`: HAL callback triggered on UART data reception (idle line or buffer full). Manages `rxBuffer`, `rxDataLength`, and `dataReady` flag. Includes error checking for UART (Overrun, Framing, Parity, Noise).
    *   `update()`: Called periodically to process received data if `dataReady` is true. It invokes `parseProtiumData()` and then restarts DMA reception.
*   **Command Transmission:**
    *   `sendStart()`: Transmits the `"start\r"` command via UART.
    *   `sendEnd()`: Transmits the `"end\r"` command via UART.
*   **External Event Handling:**
    *   `gpioExtiCallback()`: Handles GPIO external interrupts (e.g., button press) to toggle fuel cell operation by calling `sendStart()` or `sendEnd()` based on the `sendingEnabled` state.

---

## 2. Data Processing & Logging

### `Spectronik::parseProtiumData()` Function

*Signature:* `private ProtiumData Spectronik::parseProtiumData(const char *long_string)`

This crucial private method is responsible for deserializing the raw UART message string from the Protium system.

### 2.1 Parsing Logic:

1.  **Input Format:** Expects a null-terminated string with key-value pairs, typically delimited by `|` (pipe) or `!` (exclamation mark), and colons `:` separating keys from values (e.g., `KEY1:VALUE1|KEY2:VALUE2!...`).
2.  **Tokenization:** Uses `strdup` (requires `free` later) to create a mutable copy of the input string, then `strtok_r` to split it into tokens based on `|` or `!`.
3.  **Key-Value Extraction:** For each token:
    *   `strchr` finds the colon `:`.
    *   The key and value strings are extracted. Whitespace is trimmed from keys and the beginning of values.
4.  **Conditional Parsing:** Based on `constexpr bool PARSE_...` flags defined in `Config::Spectronik` (e.g., `PARSE_FANPERCENTAGE`, `PARSE_H2PRESSURESENSOR1`), the function attempts to parse specific keys:
    *   It compares the extracted `key` (e.g., `"FAN"`, `"H2P1"`, `"Tank-P"`, `"UCB_V"`) with known Protium identifiers.
    *   If a key matches and its corresponding `PARSE_...` flag is `true`, `sscanf` is used to convert the value string to the appropriate data type (e.g., `int` for `FAN`, `float` for `H2P1`).
5.  **Population:** The parsed values are stored in a new `ProtiumData` object.
6.  **Validity:** The `sensor_data.valid` flag is set to `true` upon completion (unless memory allocation for `strdup` fails).
7.  **Return:** The populated `ProtiumData` object is returned.

### 2.2 Logging Output - `ProtiumData::toString()` method

*Signature:* `public std::string ProtiumData::toString() override`

This method, overriding `ILoggable::toString()`, serializes the sensor data into a formatted string, suitable for logging or transmission.

### 2.3 Output Customization & Format:

The content of the output string is **dynamically determined at compile-time** by the `PARSE_...` boolean constants in the `Config::Spectronik` namespace.

*   **Prefix:** The string always starts with `"SPC"`.
*   **Conditional Fields:** Each sensor value is appended as a comma-separated field *only if* its corresponding `PARSE_...` flag (e.g., `Config::Spectronik::PARSE_FUELCELLVOLTAGE`) is `true`.
    *   Integer types (`FanPercentage`, `NumberOfCells`, `StasisSelector`) are converted using `std::to_string`.
    *   Float types are formatted to two decimal places using `snprintf`.

### 2.4 Example Output (if ALL `PARSE_...` flags in `Config::Spectronik` were `true`):
```c++
SPC,<FuelCellVoltage>,<FuelCellCurrent>,<FuelCellPower>,<EnergyConsumed>,<FuelCellTemperature1>,<FanPercentage>,<NumberOfCells>,<H2PressureSensor1>,<H2PressureSensor2>,<H2TankPressure>,<H2TankTemperature>,<VoltageSetpoint>,<CurrentSetpoint>,<SuperCapacitorVoltage>,<StasisSelector>,<StasisValve1Pressure>,<StasisValve2Pressure>
```
*(Actual output will vary based on active `PARSE_...` flags.)*

---

## 3. Configuration-Driven Behavior

The driver's parsing and logging behavior is heavily influenced by compile-time constants defined in `Config/Config.hpp` under the `Config::Spectronik` namespace.

*   `startString[]`: Defines the command to start the fuel cell (e.g., `"start\r"`).
*   `endString[]`: Defines the command to stop the fuel cell (e.g., `"end\r"`).
*   `PARSE_...` flags (e.g., `PARSE_FANPERCENTAGE`, `PARSE_H2PRESSURESENSOR1`): These boolean `constexpr` flags determine:
    *   Which data fields `Spektronic::parseProtiumData()` will attempt to extract from the incoming UART string.
    *   Which data fields `ProtiumData::toString()` will include in its output string.
*   A `static_assert(valid, ...)` ensures that at least one `PARSE_...` flag is true, preventing a configuration where no data would be processed.

This compile-time configuration allows tailoring the driver to specific needs, optimizing resource usage by only processing and logging relevant data.

---
## Contact

Vladimirs Jurcenoks - [@Vladimir-create](https://gitlab.com/Vladimir-create)  - [v.jurcenoks@student.han.nl](mailto:v.jurcenoks@student.han.nl)

Project Link: https://gitlab.com/hydromotive/2425-acquistionmodule-dev