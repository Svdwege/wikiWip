---
title: Logger
---
---
title: Logger
---
# Logger Driver

This document describes the `Logger` driver, a C++ component designed for efficient and automated data logging to an **OpenLog serial data logger**.

---

<!--TOC-->

* [1. Core Purpose](#1-core-purpose)
* [2. How it Works (System Overview)](#2-how-it-works-system-overview)
* [3. Key Operations](#3-key-operations)
  * [3.1 Initialization (`init()`)](#31-initialization-init)
  * [3.2 Sending Data (`logData()` Methods)](#32-sending-data-logdata-methods)
  * [3.3 Automatic File Management](#33-automatic-file-management)
* [Contact](#contact)

<!--TOC-->

---

## 1. Core Purpose

The `Logger` driver acts as a **smart interface** between your microcontroller's application and an OpenLog device. Its main job is to **reliably write data to an SD card** without the application needing to worry about serial protocols, hardware resets, or managing individual log files.

## 2. How it Works (System Overview)

The `Logger` class bridges your code with the OpenLog, which in turn writes to an SD card.

```
      
+------------------------+      +--------------+      +--------------+
|     Microcontroller    |      |    Logger    |      |    OpenLog   |
|                        |      |  (C++ Class) |      |   (SD Card)  |
|                        |      |              |      |              |
| 1. Data to Log         +----->| 2. Processes |----->| 3. Stores    |
|                        |      |   & Transmits|      |    Data      |
|                        |      |              |      |              |
|                        |      |  (via UART)  |      |              |
|                        |      |              |      |              |
+------------------------+      +--------------+      +--------------+
```

## 3. Key Operations

The `Logger` handles three main phases:

### 3.1 Initialization (`init()`)

* **Purpose:** Prepares the OpenLog for logging by ensuring it's in a known, active state.
* **Action:** Performs a hardware reset and waits for the OpenLog to signal its readiness.

### 3.2 Sending Data (`logData()` Methods)

* **Purpose:** Provides flexible methods to send various data types to the OpenLog.
* **Action:** Can log:
  * **Direct Strings:** Simple text messages.
  * **Raw Bytes:** Binary data streams.
  * **ILoggable Objects:** Structured application data that can convert itself into a loggable string.

---

## Contact

Sjoerd