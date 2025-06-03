Welcome to the Communication page, which details the communication between the Telemetry Data Collection Unit and the Telemetry Sending Unit.


## Table of contents
<!-- TOC -->
  * [Table of contents](#table-of-contents)
  * [Overview of the expected data](#overview-of-the-expected-data)
      * [Format of Accelerometer data](#format-of-accelerometer-data)
      * [Format of Motor Telemetry data](#format-of-motor-telemetry-data)
      * [Format of Motor Power data](#format-of-motor-power-data)
      * [Format of Spectronik data](#format-of-spectronik-data)
      * [Format of Throttle data](#format-of-throttle-data)
    * [Overview of the raw expected data](#overview-of-the-raw-expected-data)
      * [Raw format of the Accelerometer](#raw-format-of-the-accelerometer)
      * [Raw format of the Motor Telemetry](#raw-format-of-the-motor-telemetry)
      * [Raw format of the Motor Power](#raw-format-of-the-motor-power)
      * [Raw format of the Spectronik](#raw-format-of-the-spectronik)
      * [Raw format of the Throttle](#raw-format-of-the-throttle)
  * [Dataflow to the server](#dataflow-to-the-server)
    * [The used protocol to send data to the server](#the-used-protocol-to-send-data-to-the-server)
      * [Used topics](#used-topics)
    * [The dataformat for sending to the server](#the-dataformat-for-sending-to-the-server)
<!-- TOC -->

## Overview of the expected data

From the _Telemetry Data Collection Unit_, we receive asynchronous data from a Universal Asynchronous Receiver-Transmitter (UART) databus.

The messages are structured in CSV format as shown in **Figure 3**.
```CSV
<HH:MM:SS,sss,ID,token_1,token_2,etc>
```
_**Figure 3:** The used CSV format to send data over the UART. See **Table 3** for an explanation of the format._


_**Table 3**: Explanation of the CSV Format_

| Component |                        Description                        |
|:---------:|:---------------------------------------------------------:|
| HH:MM:SS  | Timestamp in format Hour:Minutes: seconds, e.g., 12:15:30 |
|    sss    |              time in milliseconds, e.g. 350               |
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
<HH:MM:SS,sss,ACC,axis-X,axis-Y,axis-Z>
````
_**Figure 4**: The format of the accelerometer message._


_**Table 5**: Explanation of the Accelerometer data format_

| Component |                        Description                        |
|:---------:|:---------------------------------------------------------:|
| HH:MM:SS  | Timestamp in format Hour:Minutes: seconds, e.g., 12:15:30 |
|    sss    |              time in milliseconds, e.g. 350               |
|    ACC    |             The identification of the message             |
|  axis-X   |                Acceleration in the X-axis                 |
|  axis-Y   |                Acceleration in the Y-axis                 |
|  axis-Z   |                Acceleration in the Z-axis                 |


#### Format of Motor Telemetry data

The Motor Telemetry data follows the format shown in **Figure 5**.

````CSV
<HH:MM:SS,sss,MTL,rpm,trq>
````
_**Figure 5**: The format of the  Motor Telemetry message._

_**Table 6**: Explanation of the  Motor Telemetry data format_

| Component |                        Description                        |
|:---------:|:---------------------------------------------------------:|
| HH:MM:SS  | Timestamp in format Hour:Minutes: seconds, e.g., 12:15:30 |
|    sss    |              time in milliseconds, e.g. 350               |
|    MTL    |             The identification of the message             |
|    rpm    |       Revolutions per minute (RPM) of the Hub-motor       |
|    trq    |         Torque in Newton Meters of the Hub-motor          |


#### Format of Motor Power data

The Motor Power data follows the format shown in **Figure 6**.

````CSV
<HH:MM:SS,sss,MPW,pwr>
````
_**Figure 6**: The format of the  Motor Power message._

_**Table 7**: Explanation of the  Motor Power data format_

| Component |                        Description                        |
|:---------:|:---------------------------------------------------------:|
| HH:MM:SS  | Timestamp in format Hour:Minutes: seconds, e.g., 12:15:30 |
|    sss    |              time in milliseconds, e.g. 350               |
|    MPW    |             The identification of the message             |
|    pwr    |             Power of the Hub-motor, in Watts              |


#### Format of Spectronik data

The Spectronik data follows the format shown in **Figure 7**.

````CSV
<HH:MM:SS,sss,SPC,fan,H2P1,H2P2,TankP,vsc>
````
_**Figure 7**: The format of the  Spectronik message._

_**Table 8**: Explanation of the  Spectronik data format_

| Component |                        Description                        |
|:---------:|:---------------------------------------------------------:|
| HH:MM:SS  | Timestamp in format Hour:Minutes: seconds, e.g., 12:15:30 |
|    sss    |              time in milliseconds, e.g. 350               |
|    SPC    |             The identification of the message             |
|    fan    |                   Fanspeed of fuel cell                   |
|   H2P1    |                Hydrogen pressure sensor 1                 |
|   H2P2    |                Hydrogen pressure sensor 2                 |
|   tankP   |                  Hydrogen tank pressure                   |
|    vsc    |                  Super capacitor voltage                  |


#### Format of Throttle data

The Throttle data follows the format shown in **Figure 8**.

````CSV
<HH:MM:SS,sss,THR,thr>
````
_**Figure 8**: The format of the  Throttle message._

_**Table 9**: Explanation of the  Throttle data format_

| Component |                        Description                        |
|:---------:|:---------------------------------------------------------:|
| HH:MM:SS  | Timestamp in format Hour:Minutes: seconds, e.g., 12:15:30 |
|    sss    |              time in milliseconds, e.g. 350               |
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


## Dataflow to the server

After the data is aggregated, it is ready to be uploaded to the server.
In this section, we cover the protocol used and the expected data format.

As a bonus, we show an example of how to view the parsed data on the server using a terminal in a Linux operating system.


### The used protocol to send data to the server

or sending data to the server, the protocol chosen is Message Queuing Telemetry Transport (MQTT).
The main reason this protocol was selected is that it is quick, reliable, and fairly easy to set up. Especially the setup part, due to tight time constraints.

On the Hydromotive server, the MQTT Broker (Server) is running and is used to exchange the telemetry data of the vehicle.

#### Used topics

The _Telemetry Sending Unit_ will use the following topics:

1. Testing topic
  ```String
    ESP/test
  ```
or
  ```String
    ESP/tests
  ```

2. Racing (telemetry) topic
  ```String
    hm25/telemetry
  ```

3. Racing (Error) topic
  ```String
    hm25/error
  ```


### The dataformat for sending to the server

The format used for sending the data is a _stringified JavaScript Object Notation (JSON) object_.

This format is chosen with the following reasons:
- Low data overhead
- Low chance of transmission-breaking characters
- Human-readable
- Easy to construct and deconstruct
- consistant with the configuration files

The JSON blocks are constructed in the following groups:
- Vehicle data
- Motor data
- Spectronik data

The data identification is kept as short as possible to reduce the data footprint since it is being sent over a cellular network. In **Figure 15**, the stringified JSON is viewable, which is unfortunately not very readable. In **Figure 16**, you can see the beautified JSON object. In **Table 15**, you can see the abbreviations.

```JSON
{"seq":4,"tim":"17:30:20.000","vhl":{"accX":90,"accY":26,"accZ":-197,"thr":45},"mtr":{"pwr":250,"rpm":200,"trq":55},"spc":{"vsc":55.32,"tankP":250.3,"fan":30,"h2P1":0.52,"h2P2":0.63}}
```
_**Figure 15**: The stringified JSON that will be created and uploaded to the MQTT broker._

````JSON
{
  "seq":4,
  "tim":"17:30:20.000",
  "vhl":{
    "accX":90,
    "accY":26,
    "accZ":-197,
    "thr":45
  },
  "mtr":{
    "pwr":250,
    "rpm":200,
    "trq":55
  },
  "spc":{
    "vsc":55.32,
    "tankP":250.3,
    "fan":30,
    "h2P1":0.52,
    "h2P2":0.63
  }
}
````
_**Figure 16**: The beautified JSON object. This is more readable._

_**Table 15**: All the abbreviations that are present in the JSON object._

| Component | JSON block |                        Description                        |
|:---------:|:----------:|:---------------------------------------------------------:|
|    seq    |    None    | sequence number of message, is used to track the messages |
|    tim    |    None    |     Shows the timestamp of the latest datacollection      |
|    vhl    |     -      |                    Vehicle data block                     |
|   accX    |    vhl     |                  Acceleration in X-axis                   |
|   accY    |    vhl     |                  Acceleration in Y-axis                   |
|   accZ    |    vhl     |                  Acceleration in Z-axis                   |
|    mtr    |     -      |           Information related to the Hub-motor            |
|    pwr    |    mtr     |                    Power of Hub-motor                     |
|    rpm    |    mtr     |                     RPM of Hub-motor                      |
|    trq    |    mtr     |                     RPM of Hub-motor                      |
|    trq    |    mtr     |                     RPM of Hub-motor                      |
|    spc    |     -      |      Information related to the Spectronik fuel cell      |
|    vsc    |    spc     |                  Super capacitor voltage                  |
|   tankP   |    spc     |                  Hydrogen tank pressure                   |
|    fan    |    spc     |                Fan speed of the fuel cell                 |
|   H2P1    |    spc     |                Hydrogen pressure sensor 1                 |
|   H2P2    |    spc     |                Hydrogen pressure sensor 2                 |
