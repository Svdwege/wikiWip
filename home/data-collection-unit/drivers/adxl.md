---
title: ADXL
---


# ADXL345 Accelerometer Driver

This document describes the `ADXL345` driver, a C++ component designed to interface with the ADXL345 3-axis accelerometer via SPI.

For more details see [ADXL354 documentation](https://www.analog.com/media/en/technical-documentation/data-sheets/adxl345.pdf)

---

<!--TOC-->

* [1. Core Purpose](#1-core-purpose)
* [2. System Overview Diagram](#2-system-overview-diagram)
* [3. Key Operations](#3-key-operations)
  * [3.1 Initialization (`init()`)](#31-initialization-init)
  * [3.2 Data Ready & Processing (`processIRQ()`)](#32-data-ready--processing-processirq)
  * [3.3 Data Storage (`register_data()`)](#33-data-storage-register_data)
* [4. Key Data Structure (`accelerometerData`)](#4-key-data-structure-accelerometerdata)
* [Contact](#contact)

<!--TOC-->

---

## 1. Core Purpose

The `ADXL345` driver provides a simple, robust way to **read 3-axis acceleration data** from the ADXL345 sensor. 
It handles all sensor configuration and communication, making raw acceleration values available for logging or further processing.

## 2. System Overview Diagram

This diagram illustrates how the `ADXL345` driver interacts with the sensor and provides data to the rest of the system.

```
      
+-------------------+      (IRQ/EXTI)        +---------------------------------+      (Data Update)       +---------------------------+
|   ADXL345 Sensor  |----------------------->|          ADXL345 Driver         |------------------------->|  accelerometerData Object |
|                   |                        |                                 |                          | (ILoggable)               |
+-------------------+                        | - Configures Sensor             |                          | - Xaccel, Yaccel, Zaccel  |
                                             | - Listens for IRQ               |                          |                           |
                                             | - Reads & Parses Data           |                          +---------------------------+
                                             +---------------------------------+

    
```

## 3. Key Operations

The driver manages the sensor through a few key stages:

### 3.1 Initialization (`init()`)

* **Purpose:** Prepares the ADXL345 sensor for accurate measurement.
* **Action:** Verifies the sensor's presence and configures its internal settings (data rate, power mode, and enabling the 'data ready' interrupt) via SPI.

### 3.2 Data Ready & Processing (`processIRQ()`)

* **Purpose:** Efficiently captures new acceleration data.
* **Action:** This method is called when new data is available via a hardware interrupt. 
It quickly reads the latest X, Y, and Z acceleration values over SPI and stores them in a dedicated data object.

### 3.3 Data Storage (`register_data()`)

* **Purpose:** Register a data object to write processed data to.
* **Action:** Connects the `ADXL345` driver to an `accelerometerData` object.

## 4. Key Data Structure (`accelerometerData`)

The `accelerometerData` class (defined in `Data/Accelerometer.hpp`) is the standard container for the sensor's output.
It holds the X, Y, and Z acceleration values, along with a timestamp and a validity flag. 
Being an `ILoggable` object, it can easily convert its data into a formatted string (e.g., `"ACC,X,Y,Z"`) for logging or telemetry.

---

## Contact

Sjoerd
