
# Installation

**The Telemetry Sending Unit software** is fully developed in PlatformIO. The software is developed in CLion 2025 using the PlatformIO plugin, primarily due to personal preference. However, any other supported Integrated Development Environment (IDE) should work as well.

PlatformIO is a plugin for popular C++ IDEs such as Visual Studio Code, Eclipse and CLion. It supports a wide range of microcontrollers from various brands, including Espressif, AVR, NXP, STM32, and many more.

The primary reason for choosing PlatformIO is its extensive support for easily switching between microcontrollers using the `platformio.ini` file, as well as its wide range of community libraries.


## Prerequisites

- PlatformIO Plugin.
- PlatformIO Core, CLI tool (Optional).
- Visual Studio Code / CLion (or any other supported IDE for PlatformIO).


### Links to install these prerequisites

- [Download page of PlatformIO](https://platformio.org/).
- [PlatformIO Core (CLI tool, is optional)](https://docs.platformio.org/en/latest/core/index.html).
- C++ IDE
    - [Full List of Supported IDEs for PlatformIO](https://platformio.org/install/integration).
    - [Visual Studio Code download page](https://code.visualstudio.com/).
    - [Clion download page](https://www.jetbrains.com/clion/).


## First time working with the Telemetry Sending Unit software

Getting started and further developing the Telemetry Sending Unit software is straightforward. Follow these steps:

1. [Clone the repository, if you haven't already](https://gitlab.com/hydromotive/2425-acquistionmodule-dev).
2. Open your favorite (and supported) IDE with the PlatformIO plugin installed.
3. Click on _Open..._ (in CLion, the shortcut is: `CTRL + O`).
4. Navigate to `<root of repository folder>\telemetry-unit\`.
5. Open the folder `telemetry-sending`.

Now, the PlatformIO plugin will initialize, and the build targets and configuration will be loaded.

## How to upload the code to ESP32-S3

Connect the ESP32 S3 to your laptop via a USB-C cable, using the UART labeled port.

### Structure of config.json


### Upload filesystem to ESP32-S3

> "**Note :** it is not nessecary to upload the filesystem everytime afer a software update, unless the JSON structure changed" 

1. Create a folder within the project named data (it should look like `ROOT_OF_PROJECT/data`)
2. Copy the config.json from data_template to the data folder.
3. Configure the config.json

```
telemetry-sending
├── data
│   ├─ test.config
-------------
```

4. Upload file system via the terminal by using:
```
pio run --target uploadfs
```


### Upload code to ESP32-S3

> "**Note: ** The Telemetry Sending software only works then the filesystem is uploaded to the ESP32-S3!"

1. Connect the ESP32-S3 Via a USB-C cable to your laptop. Use the UART labeled USB-C connector
2. Compile the software with PlatformIO
You can use the following command:

```
pio.exe run -e lolin_s3
```

3. Upload the compiled software to the ESP32-S3
   You can use the following command:

```
pio.exe run -t upload -e lolin_s3
```
