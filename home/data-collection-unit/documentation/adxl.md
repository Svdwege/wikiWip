---
title: ADXL
---

---
title: ADXL
---

# ADXL345 Accelerometer documentation

This document provides a concise summary of the essential technical specifications for the Analog Devices ADXL345 3-axis digital accelerometer, derived from its official datasheet.

For more details see [ADXL354 documentation](https://www.analog.com/media/en/technical-documentation/data-sheets/adxl345.pdf)

---
<!-- TOC -->
* [1. General Characteristics](#1-general-characteristics)
* [2. Performance Specifications](#2-performance-specifications)
* [3. Electrical & Power](#3-electrical--power)
* [4. Interfaces & Features](#4-interfaces--features)
* [5. Physical Characteristics](#5-physical-characteristics)
* [Contact](#contact)
<!-- TOC -->

---

## 1. General Characteristics

*   **Type:** 3-Axis Digital Accelerometer
*   **Measurement Ranges (User-Selectable):** ±2 g, ±4 g, ±8 g, ±16 g
*   **Digital Output Format:** 16-bit, Two's Complement

## 2. Performance Specifications

*   **Resolution:**
  *   Fixed 10-bit for lower g-ranges.
  *   Up to 13-bit resolution at ±16 g (maintains 4 mg/LSB scale factor across all ranges).
*   **Sensitivity (Scale Factor):** 3.9 mg/LSB
*   **Output Data Rate (ODR):** User-selectable from 0.1 Hz to 3200 Hz
*   **Operating Temperature Range:** -40°C to +85°C

## 3. Electrical & Power

*   **Supply Voltage (Vs):** 2.0 V to 3.6 V
*   **I/O Voltage (VDD I/O):** 1.7 V to Vs
*   **Typical Supply Current (at Vs = 2.5V):**
  *   Measurement Mode (ODR ≥ 100 Hz): ~140 µA
  *   Measurement Mode (ODR < 10 Hz): ~30 µA
  *   Standby Mode: ~0.1 µA

## 4. Interfaces & Features

*   **Digital Interfaces:** SPI (3- or 4-wire) and I2C
*   **Interrupts:** Flexible interrupt modes mappable to two output pins (INT1, INT2).
*   **Embedded Memory:** 32-level First-In, First-Out (FIFO) buffer to minimize host processor load.
*   **Special Sensing Functions:**
  *   Single tap/double tap detection
  *   Activity/inactivity monitoring
  *   Free-fall detection

## 5. Physical Characteristics

*   **Package:** Small and thin 3 mm × 5 mm × 1 mm LGA package
*   **Device Weight:** ~30 mg
