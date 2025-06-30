---
title: 'Collector <---> Data Sender '
---
Welcome to the Communication page, which details the communication between the Telemetry Data Collection Unit and the Telemetry Sending Unit.

## Communication protocol

The collector sends data at 460800 baud 8 bit no parity and 1 stop bit.
This provides overhead for metadata which hasn't been implemented, it also provides more processing time for the data sender.

## Overview of the expected data

From the _Telemetry Data Collection Unit_, we receive asynchronous data from a Universal Asynchronous Receiver-Transmitter (UART) databus.

The messages are structured in CSV format as shown in **Figure 3**.
```CSV
<hh:mm:ss,fff,ID,token_1,token_2,etc>
```
_**Figure 3:** The used CSV format to send data over the UART. See **Table 3** for an explanation of the format._


_**Table 3**: Explanation of the CSV Format_

| Component |                        Description                        |
|:---------:|:---------------------------------------------------------:|
| hh:mm:ss  | Timestamp in format Hour:Minutes: seconds, e.g., 12:15:30 |
|    fff    |              time in milliseconds, e.g. 350               |
|    ID     |             The identification of the message             |
|  token_1  |                     first actual data                     |
|  token_2  |                    second actual data                     |


As stated before, there are a total of five different messages sent over the UART, each containing different parts of information about the vehicle. These messages are identifiable by the ID present in the message. In **Table 4**, you can see all the possible IDs.

_**Table 4**: All the Identifiers that are used to collect and send data._

| Identifier |         Description         |
|:----------:|:---------------------------:|
|    ACC     |     Accelerometer data      |
|    MTL     |    Motor Telemetry data     |
|    MPW     |      Motor Power data       |
|    SPC     | Spectronik (fuel cell) data |
|    THR     |        Throttle data        |


#### Format of Accelerometer data

The accelerometer data follows the format shown in **Figure 4**.

````CSV
<hh:mm:ss,fff,ACC,axis-X,axis-Y,axis-Z>
````
_**Figure 4**: The format of the accelerometer message._


_**Table 5**: Explanation of the Accelerometer data format_

| Component |                        Description                        |
|:---------:|:---------------------------------------------------------:|
| hh:mm:ss  | Timestamp in format Hour:Minutes: seconds, e.g., 12:15:30 |
|    fff    |              time in milliseconds, e.g. 350               |
|    ACC    |             The identification of the message             |
|  axis-X   |                Acceleration in the X-axis                 |
|  axis-Y   |                Acceleration in the Y-axis                 |
|  axis-Z   |                Acceleration in the Z-axis                 |


#### Format of Motor Telemetry data

The Motor Telemetry data follows the format shown in **Figure 5**.

````CSV
<hh:mm:ss,fff,MTL,rpm,trq>
````
_**Figure 5**: The format of the  Motor Telemetry message._

_**Table 6**: Explanation of the  Motor Telemetry data format_

| Component |                        Description                        |
|:---------:|:---------------------------------------------------------:|
| hh:mm:ss  | Timestamp in format Hour:Minutes: seconds, e.g., 12:15:30 |
|    fff    |              time in milliseconds, e.g. 350               |
|    MTL    |             The identification of the message             |
|    rpm    |       Revolutions per minute (RPM) of the Hub-motor       |
|    trq    |         Torque in Newton Meters of the Hub-motor          |


#### Format of Motor Power data

The Motor Power data follows the format shown in **Figure 6**.

````CSV
<hh:mm:ss,fff,MPW,pwr>
````
_**Figure 6**: The format of the  Motor Power message._

_**Table 7**: Explanation of the  Motor Power data format_

| Component |                        Description                        |
|:---------:|:---------------------------------------------------------:|
| hh:mm:ss  | Timestamp in format Hour:Minutes: seconds, e.g., 12:15:30 |
|    fff    |              time in milliseconds, e.g. 350               |
|    MPW    |             The identification of the message             |
|    pwr    |             Power of the Hub-motor, in Watts              |


#### Format of Spectronik data

The Spectronik data follows the format shown in **Figure 7**.

````CSV
<hh:mm:ss,fff,SPC,fan,H2P1,H2P2,TankP,vsc>
````
_**Figure 7**: The format of the  Spectronik message._

_**Table 8**: Explanation of the  Spectronik data format_

| Component |                        Description                        |
|:---------:|:---------------------------------------------------------:|
| hh:mm:ss  | Timestamp in format Hour:Minutes: seconds, e.g., 12:15:30 |
|    fff    |              time in milliseconds, e.g. 350               |
|    SPC    |             The identification of the message             |
|    fan    |                   Fanspeed of fuel cell                   |
|   H2P1    |                Hydrogen pressure sensor 1                 |
|   H2P2    |                Hydrogen pressure sensor 2                 |
|   tankP   |                  Hydrogen tank pressure                   |
|    vsc    |                  Super capacitor voltage                  |


#### Format of Throttle data

The Throttle data follows the format shown in **Figure 8**.

````CSV
<hh:mm:ss,fff,THR,thr>
````
_**Figure 8**: The format of the  Throttle message._

_**Table 9**: Explanation of the  Throttle data format_

| Component |                        Description                        |
|:---------:|:---------------------------------------------------------:|
| hh:mm:ss  | Timestamp in format Hour:Minutes: seconds, e.g., 12:15:30 |
|    fff    |              time in milliseconds, e.g. 350               |
|    THR    |             The identification of the message             |
|    thr    |                     Throttle position                     |


### Overview of the raw expected data

In the previous chapter, we explained the expected data format and the abbreviations of the identifiers. In this section, we will detail how the data is expected to be received from the Telemetry Data Collection Unit.

Please note that this data is sent as byte data with start and stop bytes and might not be fully readable via a serial terminal.

- The start byte is identified as `0x01`.
- The stop byte is identified as `0x18`.
- At the end of every message, before the stop byte, there is a 2-byte Cyclic Redundancy Check (CRC).
- The CRC used is _CRC-16-CCITT_.

the general format is shown in **Figure 9**.

```String
\x0112:15:30,350,<ID>,<token_1>,<token_2>,<etc>\xAA\xBB\x18
```
_**Figure 9**: The general raw format of the messages being sent over the UART_

These raw data stings could be used to emulate the _Telemetry Data collection Unit_.


#### Raw format of the Accelerometer

The raw format of the accelerometer data follows the format shown in **Figure 10**.

```String
\x0100:33:58,334,ACC,-251,74,36\xB2\xA4\x18
```
_**Figure 10**: The raw data string of the accelerometer message, including CRC and start and stop bytes. See **Table 10** for more information about the data types._

_**Table 10**: Explanation of the Raw Accelerometer Data Format._

| Component |                Description                |
|:---------:|:-----------------------------------------:|
|   \x01    |         Start byte of the message         |
| 00:33:58  | Timestamp in format Hour:Minutes: seconds |
|    334    |           time in milliseconds            |
|    ACC    |     The identification of the message     |
|   -251    |  Acceleration in the X-axis, in Int16_t   |
|    74     |  Acceleration in the Y-axis, in Int16_t   |
|    36     |  Acceleration in the Z-axis, in Int16_t   |
|   \xB2    | Most Significant Bytes (MSB)  of the CRC  |
|   \xA4    | Least Significant Bytes (LSB)  of the CRC |
|   \x18    |         Stop byte of the message          |


#### Raw format of the Motor Telemetry

The raw format of the Motor Telemetry data follows the format shown in **Figure 11**.

```String
\x0100:33:47,024,MTL,0,0\x85\xA3\x18
```
_**Figure 11**: The raw data string of the Motor Telemetry message, including CRC and start and stop bytes. See **Table 11* for more information about the data types._

_**Table 11**: Explanation of the Raw  Motor Telemetry Data Format._

| Component |                Description                |
|:---------:|:-----------------------------------------:|
|   \x01    |         Start byte of the message         |
| 00:33:47  | Timestamp in format Hour:Minutes: seconds |
|    024    |           time in milliseconds            |
|    MTL    |     The identification of the message     |
|     0     |           Motor rpm, in Int16_t           |
|     0     |          Motor torque, in Int8_t          |
|   \x85    | Most Significant Bytes (MSB)  of the CRC  |
|   \xA3    | Least Significant Bytes (LSB)  of the CRC |
|   \x18    |         Stop byte of the message          |


#### Raw format of the Motor Power

The raw format of the Motor Power data follows the format shown in **Figure 12**.

```String
\x0100:47:35,934,MPW,0\x8C\x05\x18
```
_**Figure 12**: The raw data string of the Motor Power message, including CRC and start and stop bytes. See **Table 12** for more information about the data types._

_**Table 12*: Explanation of the Raw  Motor Power Data Format._

| Component |                Description                |
|:---------:|:-----------------------------------------:|
|   \x01    |         Start byte of the message         |
| 00:47:35  | Timestamp in format Hour:Minutes: seconds |
|    934    |           time in milliseconds            |
|    MPW    |     The identification of the message     |
|     0     |          Motor power, in Int16_t          |
|   \x8C    | Most Significant Bytes (MSB)  of the CRC  |
|   \x05    | Least Significant Bytes (LSB)  of the CRC |
|   \x18    |         Stop byte of the message          |


#### Raw format of the Spectronik

The raw format of the Spectronik data follows the format shown in **Figure 13**.

```String
\x0100:47:32,199,SPC,100,7.22,0.00,0.02,0.0\xF2\xCF\x18
```
_**Figure 13**: The raw data string of the Spectronik message, including CRC and start and stop bytes. See **Table 13** for more information about the data types._

_**Table 13**: Explanation of the Raw  Spectronik Data Format._

| Component |                Description                |
|:---------:|:-----------------------------------------:|
|   \x01    |         Start byte of the message         |
| 00:47:32  | Timestamp in format Hour:Minutes: seconds |
|    199    |           time in milliseconds            |
|    SPC    |     The identification of the message     |
|    100    |           Fan speed, in uint8_t           |
|   7.22    |   Hydrogen sensor pressure 1, in float    |
|   0.00    |   Hydrogen sensor pressure 2, in float    |
|   0.00    |     Hydrogen tank pressure, in float      |
|   0.02    |         Super capacitor, in float         |
|   \xF2    | Most Significant Bytes (MSB)  of the CRC  |
|   \xCF    | Least Significant Bytes (LSB)  of the CRC |
|   \x18    |         Stop byte of the message          |


#### Raw format of the Throttle

The raw format of the Throttle data follows the format shown in **Figure 14**.

```String
\x0100:47:36,181,THR,0\xAB\xBA\x18
```
_**Figure 14**: The raw data string of the Throttle message, including CRC and start and stop bytes. See **Table 14** for more information about the data types._

_**Table 14**: Explanation of the Raw  Throttle Data Format._

| Component |                Description                |
|:---------:|:-----------------------------------------:|
|   \x01    |         Start byte of the message         |
| 00:47:36  | Timestamp in format Hour:Minutes: seconds |
|    181    |           time in milliseconds            |
|    THR    |     The identification of the message     |
|     0     |       throttle position, in uint8_t       |
|   \xAB    | Most Significant Bytes (MSB)  of the CRC  |
|   \xBA    | Least Significant Bytes (LSB)  of the CRC |
|   \x18    |         Stop byte of the message          |