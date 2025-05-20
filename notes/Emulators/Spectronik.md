---
title: Spectronik
---





### Spectronik Emulator Detailed Documentation

👋 **Welcome to the Spectronik Emulator Documentation!** This guide provides detailed information about the emulator's hardware setup, software functionality, and communication protocols.

### Table of Contents (Spectronik Emulator Details)
<!-- TOC -->
* [Spectronik Emulator Detailed Documentation](#spectronik-emulator-detailed-documentation)
    * [Table of Contents (Spectronik Emulator Details)](#table-of-contents-spectronik-emulator-details)
    * [1. Introduction](#1-introduction)
    * [2. Hardware](#2-hardware-)
      * [2.1. Configuration Overview](#21-configuration-overview-)
      * [2.2. Design Document & PCB Visuals](#22-design-document--pcb-visuals-)
        * [2.2.1. Schematic](#221-schematic-)
        * [2.2.2. PCB Layout](#222-pcb-layout-)
        * [2.2.3. 3D Model](#223-3d-model-)
    * [3. Software](#3-software-)
      * [3.1. Overview](#31-overview)
      * [3.2. Configuration Constants for Dynamic Behavior](#32-configuration-constants-for-dynamic-behavior-)
      * [3.3. UART Command Interface](#33-uart-command-interface-)
      * [3.4. Data String Formats](#34-data-string-formats-)
        * [3.4.1. Continuous Data Transmission String (`long_string`) Example](#341-continuous-data-transmission-string-long_string-example-)
        * [3.4.2. System Off Message (`end_string`) Example](#342-system-off-message-end_string-example-)
      * [3.5. String Construction](#35-string-construction-)
  * [Contact](#contact)
<!-- TOC -->
---
### 1. Introduction

This document describes a C code snippet for the MKL25Z4 microcontroller. It implements UART communication to simulate and transmit dynamic system data based on received commands and physical button input. This allows for testing and interaction with a system expecting data from a spectronik device.

---

### 2. Hardware 

#### 2.1. Configuration Overview 

The emulator is designed to run on specific hardware with the following configuration:

*   **Target MCU:** MKL25Z4 (on FRDM-KL25Z)
*   **UART Peripheral:** UART2
    *   **UART Pins (MCU direct):**
        *   `PTE22` (MCU pin for UART2_RX)
        *   `PTE23` (MCU pin for UART2_TX)
    *   **External UART Interface (via level shifter):** The board includes BSS138 level shifters to interface the 3.3V MCU UART signals with a 5V system. The 4-pin connector `J3` provides:
        *   5V_UART2_RX
        *   5V_UART2_TX
        *   GND
        *   5V
*   **Baud Rate:** 57600 bps
*   **Data Format:** 8N1 (8 data bits, No parity, 1 stop bit)
*   **User Inputs & Outputs:**
    *   **Button (S1):** Connected to MCU pin `PTA5`. Used to stop data transmission.
    *   **LED1 (Green):** Connected to MCU pin `PTA1`. Used for status indication (e.g., power on, activity).
    *   **LED2 (Red):** Connected to MCU pin `PTA4`. Used for status indication (e.g., transmission active, error).

#### 2.2. Design Document & PCB Visuals 

The complete hardware design files, including schematics and PCB layout, are available in the project repository.

*   **KiCad Project Files & PDF Schematic:**
    *   [View/Download emulator.pdf from GitLab](https://gitlab.com/hydromotive/2425-acquistionmodule-dev/-/blob/Spectronik-emulator/emulator.pdf?ref_type=heads)
    *   *(The full KiCad project can be found in the same repository directory.)*

##### 2.2.1. Schematic 
The schematic outlines the connections between the FRDM-KL25Z development board, LEDs, button, UART level shifters, and external connector.

![Emulator Schematic](https://i.imgur.com/4vR2G6j.png)
*Figure 1: Spektronic Emulator Circuit Schematic*

##### 2.2.2. PCB Layout 
*(Placeholder for an image of the PCB layout)*

*   **Example:**
    ```
    ![Emulator PCB Layout](https://via.placeholder.com/600x400.png/cccccc/000000?text=PCB+Layout+Image)
    *Figure 2: Spektronic Emulator PCB Layout*
    ```

##### 2.2.3. 3D Model 
*(Placeholder for an image of the 3D model of the PCB)*

*   **Example:**
    ```
    ![Emulator PCB 3D Model](https://via.placeholder.com/600x400.png/cccccc/000000?text=PCB+3D+Model+Image)
    *Figure 3: Spektronic Emulator PCB 3D Model*
    ```

---

### 3. Software 

#### 3.1. Overview

The software running on the MKL25Z4 microcontroller is responsible for generating simulated data, handling UART communication, and responding to user commands.

#### 3.2. Configuration Constants for Dynamic Behavior 

The behavior of the simulated dynamic variables (`FAN`, `H2P1`, `H2P2`, `Tank_P`, `UCB_V`) is controlled by preprocessor `#define` constants within the C code. Modifying these values directly alters the simulation characteristics before compilation.

*   `TIME_STEP`: Determines how much the internal `time_counter` increments each update cycle. This affects the speed of all time-dependent functions (Ramp, Sin, Cos).
*   `H2P1_INCREMENT`: Controls the step size for the linear increase (Ramp) of the `H2P1` value per time step.
*   `H2P2_AMPLITUDE`, `H2P2_OFFSET`: Define the amplitude and vertical shift (DC offset) of the sine wave function applied to `H2P2`.
*   `TANK_P_AMPLITUDE`, `TANK_P_OFFSET`: Define the amplitude and vertical shift (DC offset) of the cosine wave function applied to `Tank_P`.
*   `UCB_V_AMPLITUDE`, `UCB_V_OFFSET`: Define the amplitude and vertical shift (DC offset) of the combined sine/cosine function applied to `UCB_V`.

Changing these constants before compiling the code will change the rate, range, and characteristics of the data simulation.

#### 3.3. UART Command Interface 

The system responds to specific commands received via UART2. These commands control the data transmission mode. Commands must be terminated with a carriage return (`\r`).

*   **`values\r`**:
    *   Upon receiving this exact string, the system performs *one* update of the dynamic values.
    *   It then transmits the formatted data string (`long_string`) *one time*.
*   **`start\r`**:
    *   Upon receiving this exact string, the system enters a continuous transmission mode.
    *   It updates the dynamic values every 1 second and transmits the formatted data string (`long_string`).
*   **`end\r`**:
    *   Upon receiving this exact string, or if the physical button connected to `PORTC` pin 3 is pressed, the system:
        *   Stops the continuous transmission mode (if active).
        *   Transmits a fixed "System Off" message (`end_string`) *one time*.

#### 3.4. Data String Formats 

This section details the formats of the primary data strings transmitted by the emulator.

##### 3.4.1. Continuous Data Transmission String (`long_string`) Example 
The primary data string (`long_string`) transmitted by the emulator during continuous operation or upon receiving the `values\r` command has the following format. Note that `[2J` is an ANSI escape sequence that typically clears the terminal screen.

```
[2J|FC_V : 31.01 V | FC_A : 7.63 A | FC_W : 236.5 W | Energy: 88 Wh| FCT1: 47.85 C | FAN : %d %% | H2P1 : %.2f B | H2P2 : %.2f B | Tank-P: %.2f B | Tank-T: 0.00 C | V_Set: 36.00 V | I_Set: 11.00 A | UCB_V: %.2f V | Stasis_selector: 0 | STASIS_V1 : 35.20 B | STASIS_V2 : 35.80 B | Number_of_cell :50 | | | | ! Fan PWM auto \r\n
```

##### 3.4.2. System Off Message (`end_string`) Example 
When the `end\r` command is received or the physical button connected to `PORTC` pin 3 is pressed, the system transmits the `end_string`. This message is defined in the C code as follows:
```c
    Abnormal shutdown initiated
    This Mileage:    14.0 Wh
    This Runtime:    0000:07 hrs
    Total Mileage:   1.57 kWh
    Total Runtime:   0001:40 hrs
    System Off
```
#### 3.5. String Construction 

The C standard library function `snprintf` is used to build the `long_string` by inserting dynamic values into the template shown above. The format specifiers in the template are replaced by the current values of specific program variables as follows:

*   **`%d`** (for `FAN`):
    *   Replaced by the integer value of `FAN * 100`.
    *   Since `FAN` is typically 0 or 1 in the simulation, this will insert `0` or `100` into the "FAN" field, representing percentage.
*   **`%.2f`** (first instance, for `H2P1`):
    *   Replaced by the value of the `float` variable `H2P1`.
    *   Formatted to two decimal places.
*   **`%.2f`** (second instance, for `H2P2`):
    *   Replaced by the value of the `float` variable `H2P2`.
    *   Formatted to two decimal places.
*   **`%.2f`** (third instance, for `Tank_P`):
    *   Replaced by the value of the `float` variable `Tank_P`.
    *   Formatted to two decimal places.
*   **`%.2f`** (fourth instance, for `UCB_V`):
    *   Replaced by the value of the `float` variable `UCB_V`.
    *   Formatted to two decimal places.

## Contact

Vladimirs Jurcenoks - [@Vladimir-create](https://gitlab.com/Vladimir-create)  - [v.jurcenoks@student.han.nl](mailto:v.jurcenoks@student.han.nl)

Project Link: https://gitlab.com/hydromotive/2425-acquistionmodule-dev
    