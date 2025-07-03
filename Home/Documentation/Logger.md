


# OpenLog Documentation

The OpenLog is a dedicated serial data logger built around an **ATmega328 microcontroller (16MHz, Optiboot/Arduino Uno compatible)**. It's designed to efficiently store serial data to a microSD card, making it ideal for embedded applications.

**Full information**: [Click here to view the full original website](https://learn.sparkfun.com/tutorials/openlog-hookup-guide)


---
<!-- TOC -->
* [1. Operating Modes & Entry](#1-operating-modes--entry)
* [2. Hardware Overview](#2-hardware-overview)
    * [2.1 Power Characteristics](#21-power-characteristics)
    * [2.2 MicroSD Card](#22-microsd-card)
    * [2.3 Interfaces](#23-interfaces)
    * [2.4 Status LEDs](#24-status-leds)
* [3. OpenLog Firmware Versions](#3-openlog-firmware-versions)
* [4. Configuration & Troubleshooting](#4-configuration--troubleshooting)
    * [4.1 Configuration File (`config.txt`)](#41-configuration-file-configtxt)
    * [4.2 Common Troubleshooting & Solutions](#42-common-troubleshooting--solutions)
<!-- TOC -->

---

## 1. Operating Modes & Entry

The OpenLog has two primary operational modes:

1.  **Logging Mode (`<`)**
    *   **Default State:** OpenLog starts in this mode after initialization.
    *   **Indication:** The module sends `<` to confirm it's ready to receive and log any incoming serial data.
    *   **Function:** All received serial data is directly written to the microSD card.

2.  **Command Mode (`>`)**
    *   **Purpose:** Used for configuration, file management, and system control.
    *   **Indication:** The module sends `>` to confirm it's ready to accept commands.
    *   **Entering Command Mode:**
        *   Send the ASCII character `0x1A` (Control-Z) **three (3) times consecutively**.
        *   Wait for the OpenLog to send `>` (typically ~15ms) to confirm entry into Command Mode.
    *   **Exiting Command Mode:** Return to Logging Mode by setting the system mode via commands or by power cycling the device.

## 2. Hardware Overview

### 2.1 Power Characteristics

*   **VCC Input:** 3.3V - 12V (Recommended: 3.3V - 5V)
*   **RXI Input (Receive):** 2.0V - 3.8V
*   **TXO Output (Transmit):** 3.3V
*   **Current Draw (typical with microSD):**
    *   **Idle:** ~5mA - 6mA
    *   **Active Writing:** ~20mA - 23mA (can vary with microSD card and baud rate)

### 2.2 MicroSD Card

*   **Supported Sizes:** 64MB to 32GB
*   **Supported Formats:** FAT16 or FAT32
*   **Performance Note:** Card response time can vary significantly based on manufacturer, class, and existing data. For optimal performance, use a newly formatted card (Class 4 or higher recommended for 9600bps, Class 6+ for higher baud rates).

### 2.3 Interfaces

*   **Serial UART (FTDI Header):** Primary interface for communication.
    *   **Connection Warning:** Due to pin compatibility with Arduino Pro/Mini, a direct plug into an FTDI breakout board is **not** possible. You must **cross TXO (OpenLog) to RXI (FTDI) and RXI (OpenLog) to TXO (FTDI)**.
*   **SPI Test Points:** Available for advanced users to reprogram the ATmega328 bootloader.
*   **MicroSD Card:** Beyond storage, the `config.txt` file on the card allows direct configuration updates.

### 2.4 Status LEDs

Two LEDs provide critical operational feedback:

*   **STAT1 (Blue, D5/PD5):** Toggles with each character received, indicating active serial communication.
*   **STAT2 (Green, D13/PB5):** Blinks when the SPI interface is active, specifically when 512 bytes are written to the microSD card.

## 3. OpenLog Firmware Versions

Different firmware versions optimize for specific use cases:

1.  **OpenLog:** Standard firmware. Ships by default. Includes full menu and command mode. Use `?` command to check the loaded version.
2.  **OpenLog_Light:** Designed for **high-speed logging**. Removes the menu and command mode to increase the receive buffer size.
3.  **OpenLog_Minimal:** Achieves the **highest logging speed**. Requires baud rate to be hard-coded and uploaded. Recommended for experienced users prioritizing maximum throughput.

## 4. Configuration & Troubleshooting

### 4.1 Configuration File (`config.txt`)

For firmware v1.6+, most system settings can be updated by modifying the `config.txt` file on the microSD card (using a card reader and text editor).

*   **Settings (comma-separated):**
    *   `baud`: Communication baud rate (e.g., 9600, 115200).
    *   `escape`: ASCII decimal value of the escape character (default: 26 for Ctrl+Z).
    *   `esc#`: Number of escape characters required to enter command mode (default: 3).
    *   `mode`: System boot-up mode (0=New Log, 1=Sequential Log, 2=Command Mode).
    *   `verb`: Verbose error messages (1=On, 0=Off; `!` for errors if Off).
    *   `echo`: Echo received characters in command mode (1=On, 0=Off).
    *   `ignoreRX`: Disables emergency reset via RX pin (1=On, 0=Off).
*   **File Behavior:** If `config.txt` is not found, OpenLog creates it with current settings. It prioritizes `config.txt` settings over internal EEPROM at power-up.

### 4.2 Common Troubleshooting & Solutions

1.  **STAT LED Blinks:**
    *   **3 Blinks (STAT1):** MicroSD card failed to initialize. Reformat with FAT/FAT16.
    *   **5 Blinks (STAT1):** Baud rate has changed; **power cycle** OpenLog for settings to take effect.
2.  **Dropped Characters at High Baud Rates:**
    *   OpenLog has a 512-byte receive buffer. At 115200bps, this buffer can be overrun in ~44ms.
    *   **Solution:** Add small delays (e.g., `delay(15);`) between large `Serial.print()` statements in your microcontroller code to allow OpenLog time to write.
3.  **"Too many logs" Error:**
    *   OpenLog supports up to 65,534 log files in the root directory.
    *   **Solution:** Reformat your microSD card to improve logging speed and reset log count.
4.  **Emergency Reset:**
    *   If the OpenLog is stuck or at an unknown baud rate:
        *   Tie the `RX` pin to `GND`.
        *   Power up OpenLog.
        *   Wait for the LEDs to blink in unison (approx. 2 seconds).
        *   Power down OpenLog and remove the jumper.
    *   **Result:** Resets to 9600bps with 3x Ctrl+Z escape character.
    *   **Note:** This feature can be overridden by the `ignoreRX` setting in `config.txt`.
5.  **Arduino Serial Monitor Compatibility:**
    *   `Serial.println()` sends both newline and carriage return, which can cause issues.
    *   **Solution:** Send only carriage return for commands: `Serial.print("COMMAND\r");` or `Serial.print("COMMAND"); Serial.write(13);`.