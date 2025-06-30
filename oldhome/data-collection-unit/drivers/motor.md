---
title: Motor
---


# Motor Driver

This document provides an in-depth overview of the C++ software components designed for interfacing with the GEMmotors G1.X motor controller via the CAN bus. The implementation is guided by the GEMmotors G1.X REV008 instruction manual and focuses on robust data handling and configurable logging.

-   **Primary Manual (External PDF):** [GEMmotors-G1.X-REV008](https://hannl-my.sharepoint.com/personal/jaap_janssens_han_nl/_layouts/15/onedrive.aspx?CID=f663e4aa%2D0285%2D40f3%2Da3e6%2D5114972ff027&id=%2Fpersonal%2Fjaap%5Fjanssens%5Fhan%5Fnl%2FDocuments%2FHAN%20Hydromotive%2F2024%2D2025%2FPowertrain%2Ftelemetry%2Dunit%2FTelemetry%20unit%202024%2Fhardware%2Fdocumentation%2FGEMMotors%2DG1%2EX%2DREV008%2Epdf&parent=%2Fpersonal%2Fjaap%5Fsens%5Fhan%5Fnl%2FDocuments%2FHAN%20Hydromotive%2F2024%2D2025%2FPowertrain%2Ftelemetry%2Dunit%2FTelemetry%20unit%202024%2Fhardware%2Fdocumentation)
-   **Project CAN Definitions (GitLab Wiki):** [Motor Documentation](home/data-collection-unit/documentation/motor)

---
<!-- TOC -->
* [1. Core Architecture: Event-Driven & Configurable](#1-core-architecture-event-driven--configurable)
  * [1.1 `CanDispatcher`](#11-candispatcher)
  * [1.2 `ICanMessageHandler` & Specific Handlers](#12-icanmessagehandler--specific-handlers)
  * [1.3 Handlers managing](#13-handlers-managing)
* [2. Data Structures: Capturing Motor Insights](#2-data-structures-capturing-motor-insights)
  * [2.1 `MotorTelemetry` Class (for CAN ID `0x064`)](#21-motortelemetry-class-for-can-id-0x064)
  * [2.2 `MotorPower` Class (for CAN ID `0x065`)](#22-motorpower-class-for-can-id-0x065)
  * [2.3 `MotorCtrlCommand` Class (for CAN ID `0x045`)](#23-motorctrlcommand-class-for-can-id-0x045)
* [3. Configurable Logging: `toString()` Powerhouse](#3-configurable-logging-tostring-powerhouse)
  * [3.1 `MotorTelemetry::toString()`](#31-motortelemetrytostring)
  * [3.2 `MotorPower::toString()`](#32-motorpowertostring)
  * [3.3 `MotorCtrlCommand::toString()`](#33-motorctrlcommandtostring)
* [4. CAN Message Decoding: Conditional & Precise](#4-can-message-decoding-conditional--precise)
  * [4.1 `CanTelemetryHandler::decodeData()` (for CAN ID `0x064`)](#41-cantelemetryhandlerdecodedata-for-can-id-0x064)
  * [4.2 `CanPowerHandler::decodeData()` (for CAN ID `0x065`)](#42-canpowerhandlerdecodedata-for-can-id-0x065)
  * [4.3 `CanControlCommandHandler::decodeData()` (for CAN ID `0x045`)](#43-cancontrolcommandhandlerdecodedata-for-can-id-0x045)
* [5. Configuration-Driven System: The `Config.hpp` Edge](#5-configuration-driven-system-the-confighpp-edge)
* [Contact](#contact)
<!-- TOC -->
## 1. Core Architecture: Event-Driven & Configurable

The driver employs a flexible architecture centered around a `CanDispatcher` and specialized message handlers.

### 1.1 `CanDispatcher`
The `CanDispatcher` class is the central hub for incoming CAN messages.
*   **Initialization (`init()`):** Starts the CAN peripheral (`HAL_CAN_Start`) and activates RX FIFO0 message pending interrupts (`HAL_CAN_ActivateNotification`).
*   **Handler Registration (`registerHandler()`):** Allows associating specific CAN message IDs with dedicated handler objects (implementing `ICanMessageHandler`).
*   **Message Routing (`dispatch()`):** Upon CAN message reception (typically called from `HAL_CAN_RxFifo0MsgPendingCallback`), this method looks up the registered handler for the incoming `canId` and invokes its `handleRawData()` method.

### 1.2 `ICanMessageHandler` & Specific Handlers
Handlers implement the `ICanMessageHandler` interface, requiring a `handleRawData()` method. They also typically implement `IProcess` for initialization and periodic updates.
*   **`CanTelemetryHandler`:** Processes motor status and telemetry (CAN ID `0x064`).
*   **`CanPowerHandler`:** Processes motor power metrics (CAN ID `0x065`).
*   **`CanControlCommandHandler`:** Processes feedback or status related to motor control commands (CAN ID `0x045`). *(Note: This typically handles messages *received* from the controller, not commands *sent* to it by this system).*

### 1.3 Handlers managing
1.  **CAN Filter Configuration (`init()`):** Sets up hardware CAN filters for its specific message ID and filter bank (configured in `Config.hpp`).
2.  **Raw Data Reception (`handleRawData()`):** Buffers the incoming raw CAN payload and sets a `dataPending` flag. The timestamp of reception is captured on the associated data object.
3.  **Deferred Processing (`update()`):** If `dataPending` is true, it calls an internal `decodeData()` method.
4.  **Data Object Registration (`register_data()`):** Links the handler to a specific data storage object (e.g., `MotorTelemetry*`) via `dynamic_cast`.

---

## 2. Data Structures: Capturing Motor Insights

These classes encapsulate data parsed from CAN messages. All inherit from `ILoggable`, enabling standardized, configurable string representations via their `toString()` methods. They also store a `timestamp` (updated upon message reception or creation) and a `valid` flag.

### 2.1 `MotorTelemetry` Class (for CAN ID `0x064`)
Holds comprehensive telemetry from the motor controller (GEM Manual: Tab 3).

*   `control_value` (int16_t): Current control level reported by the motor. (Bytes 0-1)
*   `control_mode` (uint8_t): Current control mode. (Byte 2, Bit 0)
*   `motor_mode` (uint8_t): Current motor operational mode. (Byte 2, Bits 1-3)
*   `sw_enable` (uint8_t): Software enable status. (Byte 2, Bit 4)
*   `motor_state` (uint8_t): Current motor operational state. (Byte 2, Bits 6-7)
*   `motor_torque` (int16_t): Measured/estimated motor torque (Nm). (Bytes 3-4)
*   `motor_rpm` (int16_t): Measured motor speed (0.1 RPM resolution; divide by 10 for RPM). (Bytes 5-6)
*   `motor_temp` (int8_t): Maximum inverter temperature (°C). (Byte 7)

### 2.2 `MotorPower` Class (for CAN ID `0x065`)
Holds power and current data (GEM Manual: Tab 4).

*   `inv_peak_cur` (int16_t): Maximum PEAK current of all inverters (A). (Bytes 0-1)
*   `motor_power` (int16_t): Current motor power (W). (Bytes 2-3)

### 2.3 `MotorCtrlCommand` Class (for CAN ID `0x045`)
Represents data related to motor control commands, typically status/feedback received from the controller regarding commands (GEM Manual: Tab 2).
*(Note: The member `control_value` is `uint8_t`, which differs from the typical range described in its comment. The parsing logic uses specific bytes from the CAN message for each field).*

*   `control_value` (uint8_t): Control value status/feedback. (Parsed from Byte 1 of CAN message).
*   `control_mode` (uint8_t): Control mode status. (Parsed from Byte 3, Bits 0-1 of CAN message).
*   `motor_mode` (uint8_t): Motor mode status. (Parsed from Byte 3, Bits 2-4 of CAN message).
*   `sw_enable` (uint8_t): Software enable status. (Parsed from Byte 3, Bit 5 of CAN message).
*   `debug_mode` (uint8_t): Debug mode status. (Parsed from Byte 3, Bit 7 of CAN message).

---

## 3. Configurable Logging: `toString()` Powerhouse

A key feature of this driver is its highly configurable logging output. Each data class (`MotorTelemetry`, `MotorPower`, `MotorCtrlCommand`) implements `ILoggable::toString()`. The content of the generated string is **dynamically determined at compile-time** by `PARSE_...` boolean constants defined in `Config.hpp`.

### 3.1 `MotorTelemetry::toString()`
*   Prefix: `"MTL"`
*   Conditionally includes: `control_value`, `control_mode`, `motor_mode`, `sw_enable`, `motor_state`, `motor_torque`, `motor_rpm`, `motor_temp`.
*   Example (if all `Config::CAN::Telemetry::PARSE_MTL_...` flags are true):

```c++
MTL,<control_value>,<control_mode>,<motor_mode>,<sw_enable>,<motor_state>,<motor_torque>,<motor_rpm>,<motor_temp>
```

### 3.2 `MotorPower::toString()`
*   Prefix: `"MPW"`
*   Conditionally includes: `motor_power`, `inv_peak_cur`.
*   Example (if all `Config::CAN::Power::PARSE_MPW_...` flags are true):

```c++
MPW,<motor_power>,<inv_peak_cur>
```

### 3.3 `MotorCtrlCommand::toString()`
*   Prefix: `"THR"`
*   Conditionally includes: `control_value`, `control_mode`, `motor_mode`, `sw_enable`, `debug_mode`.
*   Example (if all `Config::CAN::ControlCommand::PARSE_THR_...` flags are true):

```c++
THR,<control_value>,<control_mode>,<motor_mode>,<sw_enable>,<debug_mode>
```

---

## 4. CAN Message Decoding: Conditional & Precise

Each specialized handler (`CanTelemetryHandler`, `CanPowerHandler`, `CanControlCommandHandler`) contains a `decodeData()` method. This method parses the buffered `latestRawData` into the registered data object (`pMotorTelemetry`, `pMotorPowerData`, or `pMotorCtrlCommand`).

**Crucially, the decoding of each individual field is conditional, controlled by `if constexpr (PARSE_..._FLAG)` directives.** This ensures that only data explicitly enabled in the configuration is processed.

### 4.1 `CanTelemetryHandler::decodeData()` (for CAN ID `0x064`)
Parses the 8-byte payload into `pMotorTelemetry`:
*   `control_value` (int16_t): `(latestRawData[0] << 8) | latestRawData[1]` (if `PARSE_MTL_CONTROL_VALUE`)
*   `control_mode` (uint8_t): `latestRawData[2] & 0x01` (if `PARSE_MTL_CONTROL_MODE`)
*   `motor_mode` (uint8_t): `(latestRawData[2] >> 1) & 0x07` (if `PARSE_MTL_MOTOR_MODE`)
*   `sw_enable` (uint8_t): `(latestRawData[2] >> 4) & 0x01` (if `PARSE_MTL_SW_ENABLE`)
*   `motor_state` (uint8_t): `(latestRawData[2] >> 6) & 0x03` (if `PARSE_MTL_MOTOR_STATE`)
*   `motor_torque` (int16_t): `(latestRawData[3] << 8) | latestRawData[4]` (if `PARSE_MTL_MOTOR_TORQUE`)
*   `motor_rpm` (int16_t): `(latestRawData[5] << 8) | latestRawData[6]` (if `PARSE_MTL_MOTOR_RPM`)
*   `motor_temp` (int8_t): `latestRawData[7]` (if `PARSE_MTL_MOTOR_TEMP`)
    Sets `pMotorTelemetry->valid = true` after parsing.

### 4.2 `CanPowerHandler::decodeData()` (for CAN ID `0x065`)
Parses the 4-byte payload (or more, uses first 4) into `pMotorPowerData`:
*   `inv_peak_cur` (int16_t): `(latestRawData[0] << 8) | latestRawData[1]` (if `PARSE_MPW_INV_PEAK_CUR`)
*   `motor_power` (int16_t): `(latestRawData[2] << 8) | latestRawData[3]` (if `PARSE_MPW_MOTOR_POWER`)
    
Sets `pMotorPowerData->valid = true` after parsing.

### 4.3 `CanControlCommandHandler::decodeData()` (for CAN ID `0x045`)
Parses payload (assumed to be at least 4 bytes if all fields are enabled) into `pMotorCtrlCommand`:
*   `control_value` (uint8_t): `latestRawData[1]` (if `PARSE_THR_CONTROL_VALUE`)
*   `control_mode` (uint8_t): `(latestRawData[3] >> 0) & 0x03` (if `PARSE_THR_CONTROL_MODE`)
*   `motor_mode` (uint8_t): `(latestRawData[3] >> 2) & 0x07` (if `PARSE_THR_MOTOR_MODE`)
*   `sw_enable` (uint8_t): `(latestRawData[3] >> 5) & 0x01` (if `PARSE_THR_SW_ENABLE`)
*   `debug_mode` (uint8_t): `(latestRawData[3] >> 7) & 0x01` (if `PARSE_THR_DEBUG_MODE`)
    Sets `pMotorCtrlCommand->valid = true` after parsing.
    *(Note: Assumes `Config::CAN::ControlCommand::DATA_LENGTH` is sufficient, e.g., 4, if all fields are parsed from `latestRawData[3]`)*.

---

## 5. Configuration-Driven System: The `Config.hpp` Edge

The entire driver's behavior regarding which CAN messages are handled, how they are filtered, what data is parsed, and what is logged, is governed by compile-time constants in `Config.hpp` (typically within namespaces like `Config::CAN::Telemetry`, `Config::CAN::Power`, and `Config::CAN::ControlCommand`).

**Key Configuration Parameters per Message Type:**
*   `ID` (uint32_t): The CAN message identifier.
*   `DATA_LENGTH` (uint8_t): Expected data length code (DLC) for the message. Used by handlers to validate incoming data.
*   `FILTER_BANK` (uint8_t): The hardware CAN filter bank to be used by the handler.
*   `PARSE_...` flags (constexpr bool): A set of boolean flags (e.g., `PARSE_MTL_MOTOR_RPM`, `PARSE_MPW_MOTOR_POWER`) that individually enable/disable:
    *   The parsing of the corresponding data field in the handler's `decodeData()` method.
    *   The inclusion of the corresponding data field in the data object's `toString()` method.
*   `static_assert(valid, ...)`: Ensures that for each message type, at least one `PARSE_...` flag is enabled, preventing configurations where a handler might be active but no data is ever processed or logged.

This configuration-driven approach provides exceptional flexibility, allowing developers to tailor the driver's resource consumption and data output precisely to the application's requirements without modifying core logic.

---
## Contact

Vladimirs Jurcenoks - [@Vladimir-create](https://gitlab.com/Vladimir-create)  - [v.jurcenoks@student.han.nl](mailto:v.jurcenoks@student.han.nl)

Project Link: https://gitlab.com/hydromotive/2425-acquistionmodule-dev