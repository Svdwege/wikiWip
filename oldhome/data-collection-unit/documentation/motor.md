---
title: Motor
---

# GEMmotors G1.X Instruction Manual – Extracted Information

_Revision 008, date: 8.9.2021_

**Original PDF**: [Click here to view the full original specification](https://hannl-my.sharepoint.com/personal/jaap_janssens_han_nl/_layouts/15/onedrive.aspx?CID=f663e4aa-0285-40f3-a3e6-5114972ff027&id=%2Fpersonal%2Fjaap%5Fjanssens%5Fhan%5Fnl%2FDocuments%2FHAN%20Hydromotive%2F2024%2D2025%2FPowertrain%2Ftelemetry%2Dunit%2FTelemetry%20unit%202024%2Fhardware%2Fdocumentation%2FGEMMotors%2DG1%2EX%2DREV008%2Epdf)


---
<!-- TOC -->
* [1. Signal Cable](#1-signal-cable)
  * [1.1 Signal Descriptions](#11-signal-descriptions)
* [2. Communication Settings and Messages](#2-communication-settings-and-messages)
  * [Tab. 2: CAN RX Message 0 (ID = CAN RX address)](#tab-2-can-rx-message-0-id--can-rx-address-)
  * [Tab. 3: CAN TX Message status_0 (ID = CAN TX address + 0)](#tab-3-can-tx-message-status_0-id--can-tx-address--0-)
  * [Tab. 4: CAN TX Message status_1 (ID = CAN TX address + 1)](#tab-4-can-tx-message-status_1-id--can-tx-address--1-)
  * [Tab. 5: CAN TX Message status_2 (ID = CAN TX address + 2)](#tab-5-can-tx-message-status_2-id--can-tx-address--2-)
  * [Tab. 6: CAN TX Message status_3 (ID = CAN TX address + 3)](#tab-6-can-tx-message-status_3-id--can-tx-address--3-)
* [3. Error List](#3-error-list)
* [4. Warning List](#4-warning-list)
* [Contact](#contact)
<!-- TOC -->

## 1. Signal Cable

Motors G1.X have a single signal cable terminated without connector (direct‐wire).  
To use a connector, GEM recommend a 10-pin Würth 661010213322. See Fig. 13 for pinout.

**Tab. 1: Signal list and short description**

| Name       | Type           | Voltage level               | Function                         | Connector pin (wire color) |
|------------|----------------|-----------------------------|----------------------------------|----------------------------|
| +12 V      | Input          | 12 V ±10%, I < 500 mA       | MCU DC supply                    | 5 (red)                    |
| Brake      | Input          | 12 V = brakes off; GND = on | Brake signal                     | 4 (orange)                 |
| HW Enable  | Input          | 0 V = disable; 12 V = enable| Motor HW enable/disable          | 3 (brown)                  |
| CAN High   | Standard       | Standard CAN voltage        | CAN H communication              | 2 (blue)                   |
| UART RX    | Standard       | 3.3 V TTL                   | Debug RX                         | 1 (green)                  |
| UART TX    | Standard       | 3.3 V TTL                   | Debug TX                         | 10 (white)                 |
| CAN Low    | Standard       | Standard CAN voltage        | CAN L communication              | 9 (yellow)                 |
| MODE       | Input          | 0 V = change, 12 V = no-chg  | Mode select button               | 8 (gray)                   |
| Throttle   | Analog input   | 0 V = none; 12 V = full     | Throttle analogue input          | 7 (violet)                 |
| GND        | Input          | 0 V                         | Signal ground                    | 6 (black)                  |

### 1.1 Signal Descriptions

- **+12 V:** Stable 12 V ±10%; filter contactor coil to avoid spikes.  
- **Brake:** 0 V = regen on (throttle ignored); 12 V = regen off. Optional if via CAN.  
- **HW Enable:** 12 V to enable power electronics; loss = immediate shutdown (still accessible via CAN).  
- **CAN High / Low:** For CAN control or diagnostics (not required if analog).  
- **UART RX / TX:** Reserved for debugging only.  
- **MODE:** Push‐button (GND for 50 ms = single change; hold = cycle modes). Optional if only one mode or via CAN.  
- **Throttle:** 0–12 V (or 0–5 V selectable) throttle control. Optional if via CAN.

---

## 2. Communication Settings and Messages

**CAN settings:**

- Protocol: CAN 2.0A  
- Baud rate: 125 kbps (125–500 kbps)  
- RX period: 10 ms  
- TX period: 1 message per RX period  
- Endianness: Intel  
- Addresses set via GEM Flash tool (0x100/0x101 reserved for bootloader)

### Tab. 2: CAN RX Message 0 (ID = CAN RX address)  
| Byte    | Bits     | Description     | Data Type    | Value                                                                 |
|---------|----------|-----------------|--------------|-----------------------------------------------------------------------|
| 1–2     | 16..0    | control_value   | Signed 16 bit| –100 .. 100 (% torque) or –10000 .. 10000 (RPM×10)                    |
| 3 (1..0)| Unsigned | control_mode    | U8           | 0=setting, 1=TORQUE, 2=SPEED                                          |
| 3 (4..2)| Unsigned | motor_mode      | U8           | 0=normal,1=boost,2=reverse,3=regeneration,4..7=custom                 |
| 3 (5)   | Unsigned | sw_enable       | U8           | 0=stay IDLE,1=switch to RUN                                           |
| 3 (6)   | Unsigned | reserved        | U8           | 0                                                                     |
| 3 (7)   | Unsigned | debug_mode      | U8           | 0=normal,1=debug                                                      |
| 4–5     | —        | reserved        | U8           | Not used                                                              |

### Tab. 3: CAN TX Message status_0 (ID = CAN TX address + 0)  
| Byte    | Bits     | Description     | Data Type    | Value                                        |
|---------|----------|-----------------|--------------|----------------------------------------------|
| 1–2     | 16..0    | control_value   | S16          | –10000..10000 (% or RPM×10)                  |
| 3 (1..0)| Unsigned | control_mode    | U8           | 0=TORQUE,1=SPEED                             |
| 3 (4..2)| Unsigned | motor_mode      | U8           | 0=normal,1=boost,2=reverse,3=regeneration,...|
| 3 (5)   | Unsigned | sw_enable       | U8           | 0=DISABLED,1=ENABLED                         |
| 3 (7..6)| Unsigned | motor_state     | U8           | 0=INIT,1=IDLE,2=RUN,3=ERROR                  |
| 4–5     | 16..0    | motor_torque    | S16          | Nm                                           |
| 6–7     | 16..0    | motor_rpm       | S16          | 0.1 RPM resolution                           |
| 8       | 8..0     | motor_temp      | S8           | °C                                           |

### Tab. 4: CAN TX Message status_1 (ID = CAN TX address + 1)  
| Byte | Description            | Data Type | Value                                           |
|------|------------------------|-----------|-------------------------------------------------|
| 1–2  | inv_peak_cur           | S16       | Peak inverter current (A)                       |
| 3–4  | motor_power            | S16       | Motor power (W)                                 |
| 5–8  | Reserved               | —         | Not used                                        |

### Tab. 5: CAN TX Message status_2 (ID = CAN TX address + 2)  
| Byte    | Description   | Data Type | Value                                    |
|---------|---------------|-----------|------------------------------------------|
| 1–8     | warning_code  | U64       | Bit-field warning codes (see Tab. 8)     |

### Tab. 6: CAN TX Message status_3 (ID = CAN TX address + 3)  
| Byte    | Description  | Data Type | Value                                   |
|---------|--------------|-----------|-----------------------------------------|
| 1–8     | error_code   | U64       | Bit-field error codes (see Tab. 7)      |

_On each received CAN RX message, one of the TX messages is sent in response._

---

## 3. Error List

**Tab. 7: Error list**  

| Code | Description                                |
|------|--------------------------------------------|
| 1    | Settings not found                        |
| 2    | Motor stalled                             |
| 3    | Controller data reading timeout           |
| …    | …                                         |
| 10   | HW enable not set                         |
| …    | …                                         |
| 21–26| Inverter 1–6 overcurrent                  |
| 27   | DC overvoltage                            |
| 28   | DC undervoltage                           |
| …    | …                                         |
| 30   | CAN communication timeout                 |
| 31–36| Inverter 1–6 fault                        |
| 37   | CAN send error                            |
| 38   | Lost frames on CAN bus                    |
| 39   | Overspeed error                           |
| 40   | CPU overloaded                            |

_(Full list 1–40 as in original)_  

---

## 4. Warning List

**Tab. 8: Warning list**  

| Code | Description                              |
|------|------------------------------------------|
| 2    | Motor about to stall                    |
| 6–7  | Delay in reading temp/position sensor   |
| 11–19| Delay in reading inverter/CPU/hall/dclink temps |
| 20   | Delay in dclink communication           |
| 21–26| Inverter 1–6 overcurrent warnings       |
| 27   | DC overvoltage warning                  |
| 28   | DC undervoltage warning                 |
| 30   | CAN communication timeout warning       |
| 31–36| Inverter 1–6 fault warnings             |
| 37   | CAN send warning                        |
| 38   | Lost frames on CAN bus warning          |
| 39   | Overspeed warning                       |
| 40   | CPU overloaded warning                  |
| 41   | Torque limited                          |
| 42   | Starting at high RPM                    |

---  
## Contact

Vladimirs Jurcenoks - [@Vladimir-create](https://gitlab.com/Vladimir-create)  - [v.jurcenoks@student.han.nl](mailto:v.jurcenoks@student.han.nl)

Project Link: https://gitlab.com/hydromotive/2425-acquistionmodule-dev
```
