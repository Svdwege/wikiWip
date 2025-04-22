# Interfaces and general structure

The general structure which the collector system follows is the following:
There is a `Driver` which is the part of the code which pull the information of the line.
These include but are not limited to: ADXL345, can bus listener and the spectronic UART listener.
The `Driver`s then update their respective raw data stores and set a flag that tells the collector that they have raw data which needs to be processed.
This is then done by calling the each Process the Collector knows about and updating the data structure with the decoded data.
Once the data has been decoded and processed it's flag is set to let the controller know the that it needs to be logged.

```
             Driver               Process                 Collector

           +--------+           +---------+             +-----------+
           |        |           |         |             |           |
           |        |           |         |             |           |
           |        +----------→|         +------------→|           |
           |        |           |         |             |           |
           |        |           |         |             |           |
           +--------+           +---------+             +-----------+

```

## tiny printf debug logging.

The tpf library with the accompanying Serial wire output decoder program
This program has a few predefined logging levels this being:

- level 0:Test
- level 1:Error
- level 2:Warn
- level 3:Trace
- level 4:Info
- level 5:Debug

These logging levels correspond with output channels of the ITM trace port
