---
title: Logger
---

# Logger Driver
This document describes the `Logger` driver, a C++ component designed for efficient and automated data logging to an **OpenLog serial data logger**.

---
<!-- TOC -->
* [1. Core Purpose](#1-core-purpose)
* [2. How it Works (System Overview)](#2-how-it-works-system-overview)
* [3. Key Operations](#3-key-operations)
  * [3.1 Initialization (`init()`)](#31-initialization-init)
  * [3.2 Sending Data (`logData()` Methods)](#32-sending-data-logdata-methods)
  * [3.3 Automatic File Management](#33-automatic-file-management)
* [Contact](#contact)
<!-- TOC -->
---

## 1. Core Purpose

The `Logger` driver acts as a **smart interface** between your microcontroller's application and an OpenLog device. Its main job is to **reliably write data to an SD card** without the application needing to worry about serial protocols, hardware resets, or managing individual log files.

## 2. How it Works (System Overview)

The `Logger` class bridges your code with the OpenLog, which in turn writes to an SD card.

**Logger diagram**: [Click here to view diagram](https://gitlab.com/hydromotive/2425-acquistionmodule-dev/-/wikis/Drivers/Logger/Diagram)
## 3. Key Operations

The `Logger` handles three main phases:

### 3.1 Initialization (`init()`)

*   **Purpose:** Prepares the OpenLog for logging by ensuring it's in a known, active state.
*   **Action:** Performs a hardware reset and waits for the OpenLog to signal its readiness.
### 3.2 Sending Data (`logData()` Methods)

*   **Purpose:** Provides flexible methods to send various data types to the OpenLog.
*   **Action:** Can log:
    *   **Direct Strings:** Simple text messages.
    *   **Raw Bytes:** Binary data streams.
    *   **ILoggable Objects:** Structured application data that can convert itself into a loggable string.

### 3.3 Automatic File Management

*   **Purpose:** Organizes log data into manageable files and prevents single files from growing indefinitely.
*   **Action:**
    1.  **Tracking:** Monitors the size of the current log file.
    2.  **Rollover:** When a file reaches a set size limit (e.g., 10 KB), the driver **automatically**:
        *   Switches the OpenLog to a command mode.
        *   Determines the next sequential log file name.
        *   Instructs the OpenLog to open and write to this new file.
        *   Returns the OpenLog to data-logging mode.
    *   **Benefit:** Seamless file creation and switching occur transparently, without application intervention.

---
## Contact
sjoerd