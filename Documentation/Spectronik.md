---
title: Spectronik
---

# Protium-1000/2500 UART Communication Specification

This document outlines the UART communication protocol for the Protium-1000/2500 system.

**Original PDF**: [Click here to view the full original specification](https://hannl-my.sharepoint.com/shared?listurl=%2Fpersonal%2Fjaap%5Fjanssens%5Fhan%5Fnl%2FDocuments&id=%2Fpersonal%2Fjaap%5Fjanssens%5Fhan%5Fnl%2FDocuments%2FHAN%20Hydromotive%2F2024%2D2025%2FPowertrain%2Ftelemetry%2Dunit%2FTelemetry%20unit%202024%2Fhardware%2Fdocumentation%2FProtium%201000%2D2500%20UART%20Specification%20%2D%2023%2E03%2E15%20%281%29%2Epdf&parent=%2Fpersonal%2Fjaap%5Fjanssens%5Fhan%5Fnl%2FDocuments%2FHAN%20Hydromotive%2F2024%2D2025%2FPowertrain%2Ftelemetry%2Dunit%2FTelemetry%20unit%202024%2Fhardware%2Fdocumentation)

---

<!-- TOC -->
* Table of Contents
* [Protium-1000/2500 UART Communication Specification](#protium-10002500-uart-communication-specification)
  * [UART Specification](#uart-specification)
  * [UART Connector Specification](#uart-connector-specification)
  * [Serial Communication with PLC](#serial-communication-with-plc)
  * [Message Output from the Protium-1000/2500](#message-output-from-the-protium-10002500)
    * [Example Running Phase Message:](#example-running-phase-message)
    * [Parsing Algorithm:](#parsing-algorithm)
  * [Message Input to the Protium-1000/2500](#message-input-to-the-protium-10002500)
  * [Phases of Operation](#phases-of-operation)
  * [Startup Phase](#startup-phase)
  * [Running Phase](#running-phase)
  * [End Phase](#end-phase)
    * [Normal Shutdown:](#normal-shutdown)
    * [Abnormal Shutdown:](#abnormal-shutdown)
  * [Annex A: List of Commands](#annex-a-list-of-commands)
<!-- TOC -->

## UART Specification

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

## UART Connector Specification

The Protium-1000/2500 uses a 4-pin Molex PicoBlade connector. A premade cable assembly (part number: `0151340403`) may be used. The pinout is:

1. +5V
2. PLC Rx (Protium Tx)
3. PLC Tx (Protium Rx)
4. GND

---

## Serial Communication with PLC

Serial communication with a PLC (RS232/RS485 capable) is possible with the following considerations:

- Use an **RS232/RS485 to TTL converter** (Protium uses 5V TTL logic).
- TTL cable length should be **< 1 meter**.
- **Full duplex** connection is required (separate Rx and Tx lines).

---

## Message Output from the Protium-1000/2500

All UART output **from** the device is in human-readable **ASCII strings**.

- `|` (pipe, `0x7C`) = start of message / field separator
- `!` (exclamation, `0x21`) = end of message

### Example Running Phase Message:
`````c++
|FC_V : 71.17 V | FCT1: 30.90 C | H2P1 : 0.61 B | DCDCV: XX.X V |
FC_A : 10.21 A | FCT2: 28.46 C | H2P2 : 0.59 B | DCDCA: XX.X A |
FC_W : 726.6 W | FAN : 89 % | Tank-P: 117.0 B | DCDCW: XXXX.X W |
Energy: 298 Wh| BLW : 21 % | Tank-T: 25.08 C | BattV: 23.49 V |
!
Fan PWM auto
Blower auto
`````

### Parsing Algorithm:
1. Extract message from first `|` to `!`.
2. Split by `|`.
3. For each field, split by `:` to get name and value.

---

## Message Input to the Protium-1000/2500

All UART input **to** the device is also an ASCII string and must end with a **newline character**.

If an invalid command is sent:
`````c++
Command not found.
`````

---

## Phases of Operation

The system has 3 operational phases:

- **Startup**
- **Running**
- **End**

---

## Startup Phase

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

## Running Phase

Once running, the system outputs status updates at **1Hz**, in the format described earlier.

---

## End Phase

The system enters the End Phase under:

1. **Normal shutdown** (via `end` command)
2. **Abnormal shutdown** (e.g. critical error)

### Normal Shutdown:
`````c++
Shutdown initiated
This Mileage: 14.0 Wh
This Runtime: 0000:07 hrs
Total Mileage: 1.57 kWh
Total Runtime: 0001:40 hrs
System Off
`````
### Abnormal Shutdown:
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
