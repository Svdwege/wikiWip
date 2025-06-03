# Configuration

In this section of the wiki can you find the configuration of the Telemetry sending Unit. Here you can find the used Hardware pins, UARTS with their respected speeds.

## Pin configuration and usage

In _Table 1_ you can see all the used pins and their pin configuration.

_Table 1: shows the pin configuration and usage for all the pins used._

| Pin | PinMode |              Usage               |
|:---:|:-------:|:--------------------------------:|
|  4  | Output  |         Wi-Fi status LED         |
|  5  | Output  |         MQTT status LED          |
|  6  | Output  |         Spare status LED         |
|  9  |   RxD   |        RxD UART2 (Debug)         |
| 10  |   TxD   |        TxD UART2 (Debug)         |
| 17  |   TxD   | TxD UART1 (Data Collection Unit) |
| 18  |   RxD   | RxD UART1 (Data Collection Unit) |

## UART Configuration

This unit uses multiple UARTs. Table 2 provides the important information about these.

_Table 2: UART configurations_

| UART |          Description           | TxD pin | RxD pin | Baud   | UART configuation | 
|:----:|:------------------------------:|---------|---------|--------|:-----------------:|
|  1   | Telemetry Data Collection Unit | 17      | 18      | 460800 |    SERIAL_8N1     |
|  2   |        Debugging  UART         | 10      | 9       | 115200 |    SERIAL_8N1     |

