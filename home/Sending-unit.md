Welcome to the _Telemetry Sending Unit_ wiki page! Here, you will find detailed information on how to effectively use the software and contribute to its further development. Discover insights into the data flow, and understand the expected input and output data to maximize your experience with our tool.

The _Telemetry Unit_ consists of three major parts:

- Telemetry Data Collection Unit
- **Telemetry Sending Unit** (the current wiki)
- Telemetry Receiving Unit

All of these parts need to work in collaboration to function successfully. The main role of the _Telemetry Sending Unit_ is to collect and aggregate data from the _Telemetry Data Collection Unit_ and send it via a protocol to the _Telemetry Receiving Unit_.

# List of abbreviations

| abbreviations | Definition |
|:-------------:|:----------:|
| IDE | Intergraded Development Environments |
| CLI | Command Line Interface |
| UART | Universal asynchronous receiver-transmitter |
| RPM | Revolutions per minute |
| CRC | Cyclic Redundancy Check |
| MSB | Most Significant Bytes |
| LSB | Least Significant Bytes |
| MQTT | Message Queuing Telemetry Transport |
| hm25 | Hydromotive 2025 |
| JSON | JavaScript Object Notation |

# Location to find information
- Information about the configuration of the ESP32-S3, [please see the ESP32-S3-configuration](/home/Sending-unit/ESP32-S3-configuration).
- For installing a file system and upload code, [please see Installation of ESP32-S3 software](/home/Sending-unit/ESP32-S3-Installation).
- For information about the data flow of the ESP32-S3, [please see the ESP32-S3-dataflow](/home/Sending-unit/ESP32-S3-dataflow)
- For information about the communication between data collection unit and Sending unit, [please see the comm between data collector and data sender](/home/Communication/communication-between-data-collector-and-data-sender)
