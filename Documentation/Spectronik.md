---
title: Spectronik
---


# Spectronik documentation

This document outlines the UART communication protocol for the Protium-1000/2500 system.

**Original PDF**: [Click here to view the full original specification](https://hannl-my.sharepoint.com/shared?listurl=%2Fpersonal%2Fjaap%5Fjanssens%5Fhan%5Fnl%2FDocuments&id=%2Fpersonal%2Fjaap%5Fjanssens%5Fhan%5Fnl%2FDocuments%2FHAN%20Hydromotive%2F2024%2D2025%2FPowertrain%2Ftelemetry%2Dunit%2FTelemetry%20unit%202024%2Fhardware%2Fdocumentation%2FProtium%201000%2D2500%20UART%20Specification%20%2D%2023%2E03%2E15%20%281%29%2Epdf&parent=%2Fpersonal%2Fjaap%5Fjanssens%5Fhan%5Fnl%2FDocuments%2FHAN%20Hydromotive%2F2024%2D2025%2FPowertrain%2Ftelemetry%2Dunit%2FTelemetry%20unit%202024%2Fhardware%2Fdocumentation)

---

<!-- TOC -->
* [1. Protium-1000/2500 UART Communication Specification](#1-protium-10002500-uart-communication-specification)
  * [1.1 UART Specification](#11-uart-specification)
  * [1.2 UART Connector Specification](#12-uart-connector-specification)
  * [1.3 Serial Communication with PLC](#13-serial-communication-with-plc)
* [2. Message Output from the Protium-1000/2500](#2-message-output-from-the-protium-10002500)
  * [2.1 Example Running Phase Message:](#21-example-running-phase-message)
* [3. Parsing Algorithm:](#3-parsing-algorithm)
* [4. Message Input to the Protium-1000/2500](#4-message-input-to-the-protium-10002500)
* [5. Phases of Operation](#5-phases-of-operation)
  * [5.1 Startup Phase](#51-startup-phase)
  * [5.2 Running Phase](#52-running-phase)
  * [5.3 End Phase](#53-end-phase)
    * [5.3.1 Normal Shutdown:](#531-normal-shutdown)
    * [5.3.2 Abnormal Shutdown:](#532-abnormal-shutdown)
* [Annex A: List of Commands](#annex-a-list-of-commands)
<!-- TOC -->

## 1. Protium-1000/2500 UART Communication Specification

## 1.1 UART Specification

The following parameters define the UART communication settings for the Protium-1000/2500:

| Parameter     | Value         |
|---------------|---------------|
| Baud Rate     | 57600 bps     |
| Data Bits     | 8             |
| Parity Bit    | None          |
| Stop Bits     | 1             |
| Flow Control  | None          |
| Logic Level   | 5V HIGH, 0V LOW |

---

## 1.2 UART Connector Specification

The Protium-1000/2500 uses a 4-pin Molex PicoBlade connector. A premade cable assembly (part number: `0151340403`) may be used. The pinout is:

1. +5V
2. PLC Rx (Protium Tx)
3. PLC Tx (Protium Rx)
4. GND

---

## 1.3 Serial Communication with PLC

Serial communication with a PLC (RS232/RS485 capable) is possible with the following considerations:

- Use an **RS232/RS485 to TTL converter** (Protium uses 5V TTL logic).
- TTL cable length should be **< 1 meter**.
- **Full duplex** connection is required (separate Rx and Tx lines).

---

## 2. Message Output from the Protium-1000/2500

All UART output **from** the device is in human-readable **ASCII strings**.

- `|` (pipe, `0x7C`) = start of message / field separator
- `!` (exclamation, `0x21`) = end of message

### 2.1 Example Running Phase Message:
`````c++
|FC_V : 71.17 V | FCT1: 30.90 C | H2P1 : 0.61 B | DCDCV: XX.X V |
FC_A : 10.21 A | FCT2: 28.46 C | H2P2 : 0.59 B | DCDCA: XX.X A |
FC_W : 726.6 W | FAN : 89 % | Tank-P: 117.0 B | DCDCW: XXXX.X W |
Energy: 298 Wh| BLW : 21 % | Tank-T: 25.08 C | BattV: 23.49 V |
!
Fan PWM auto
Blower auto
`````

### 3. Parsing Algorithm:
1. Extract message from first `|` to `!`.
2. Split by `|`.
3. For each field, split by `:` to get name and value.

---

## 4. Message Input to the Protium-1000/2500

All UART input **to** the device is also an ASCII string and must end with a **newline character**.

If an invalid command is sent:
`````c++
Command not found.
`````

---

## 5. Phases of Operation

The system has 3 operational phases:

- **Startup**
- **Running**
- **End**

---

## 5.1 Startup Phase

At power-up, the system enters the Startup phase. It sends identification and status messages such as:
`````c++
Spectronik Protium 2500
Type help<enter> for list of commands
Total Mileage: 1.57 kWh
Total Runtime: 0001:40 hrs
Ready to start.
`````
System checks then follow:
`````c++
P2500 2203-05 initialising
Firmware version : V2.5_03032022_0642_2203-05-A
No. of cells : 80
Entering to Starting phase...
Anode Supply Pressure OK
Temperature Check OK
`````
To proceed to the Running phase, send:
`````c++
start
`````

---

## 5.2 Running Phase

Once running, the system outputs status updates at **1Hz**, in the format described earlier.

---

## 5.3 End Phase

The system enters the End Phase under:

1. **Normal shutdown** (via `end` command)
2. **Abnormal shutdown** (e.g. critical error)

### 5.3.1 Normal Shutdown:
`````c++
Shutdown initiated
This Mileage: 14.0 Wh
This Runtime: 0000:07 hrs
Total Mileage: 1.57 kWh
Total Runtime: 0001:40 hrs
System Off
`````
### 5.3.2 Abnormal Shutdown:
`````c++
Abnormal shutdown initiated
This Mileage: 14.0 Wh
This Runtime: 0000:07 hrs
Total Mileage: 1.57 kWh
Total Runtime: 0001:40 hrs
System Off
`````
---

## Annex A: List of Commands

| Command | Function | Valid Phase | ASCII Hex |
|---------|----------|-------------|-----------|
| `start` | Enter running phase | Startup | `73 74 61 72 74` |
| `end` | Exit running phase | Running | `65 6E 64` |
| `f` | Set fans to auto | Running | `66` |
| `b` | Set blowers to auto | Running | `62` |
| `p` | Single manual purge | Running | `70` |
| `ver` | Display firmware version | Startup | `76 65 72` |
| `9` | Decrease fan speed by 1% | Running | `39` |
| `0` | Increase fan speed by 1% | Running | `30` |
| `-` | Decrease fan speed by 5% | Running | `2D` |
| `=` | Increase fan speed by 5% | Running | `3D` |
| `[` | Decrease blower intensity by 3% | Running | `5B` |
| `]` | Increase blower intensity by 3% | Running | `5D` |

---

## Contact

Vladimirs Jurcenoks - [@Vladimir-create](https://gitlab.com/Vladimir-create)  - [v.jurcenoks@student.han.nl](mailto:v.jurcenoks@student.han.nl)

Project Link: https://gitlab.com/hydromotive/2425-acquistionmodule-dev