---
title: Drivers
---
# ⚙️ Drivers Hub

👋 **Welcome to the Drivers Hub!**

> This page serves as the central directory for all software interface drivers developed or utilized within our project. 
>
> Find details and links for each driver below.

---

## 📖 Available Drivers

Below you will find a list of available drivers. Click on the name or the "View Details" link to navigate to its dedicated documentation page.

### 1. ADXL driver
*   **Description:** This document outlines the C++ driver for reading and processing accelerometer data from ADXL sensors.
*   **[➡️ View Details for [ADXL driver]](home/data-collection-unit/drivers/adxl)**

### 2. Collector driver
*   **Description:** This document details the `Collector` component, which orchestrates data processing from various drivers and prepares it for logging and transmission.
*   **[➡️ View Details for [Collector driver]](home/data-collection-unit/drivers/collector)**

### 3. Logger driver
*   **Description:** This document describes the `Logger` driver, responsible for writing data to an OpenLog serial data logger, including automatic file management.
*   **[➡️ View Details for [Logger driver]](home/data-collection-unit/drivers/logger)**

### 4. Motor driver
*   **Description:** This document describes the C++ classes and functions used for handling and decoding CAN messages related to the GEMmotors G1.X motor driver.
*   **[➡️ View Details for [Motor driver]](home/data-collection-unit/drivers/motor)**

### 5. Spectronik driver
*   **Description:** This document outlines the C++ code for the Spectronik driver, which communicates with the Protium-1000/2500 system via UART.
*   **[➡️ View Details for [Spectronik driver]](home/data-collection-unit/drivers/spectronik)**
---

## 🤝 Contributing & Maintaining Driver Documentation

To ensure this hub remains up-to-date and useful:

*   **Adding a New Driver:**
    1.  Create a new, separate page for its detailed documentation under /Drivers.
    2.  Add a new entry to the list above on this Hub page, including a brief description, hardware/system interfaced, status, and a link to your new detail page.
*   **Updating Existing Driver Documentation:**
    1.  Navigate to the specific detail page for the driver.
    2.  Make your edits directly there.
    3.  If the status or high-level description changes, update it on this Hub page as well.

---