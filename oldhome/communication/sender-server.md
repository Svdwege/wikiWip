---
title: Sender <---> Server
---
## Dataflow to the server

After the data is aggregated, it is ready to be uploaded to the server. In this section, we cover the protocol used and the expected data format.

As a bonus, we show an example of how to view the parsed data on the server using a terminal in a Linux operating system.

### The used protocol to send data to the server

or sending data to the server, the protocol chosen is Message Queuing Telemetry Transport (MQTT). The main reason this protocol was selected is that it is quick, reliable, and fairly easy to set up. Especially the setup part, due to tight time constraints.

On the Hydromotive server, the MQTT Broker (Server) is running and is used to exchange the telemetry data of the vehicle.

#### Used topics

The _Telemetry Sending Unit_ uses the following topics:

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

3. Racing (Error) topic [Not implemented]

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

**_Figure 15_**_: The stringified JSON that will be created and uploaded to the MQTT broker._

```JSON
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
```

**_Figure 16_**_: The beautified JSON object. This is more readable._

**_Table 15_**_: All the abbreviations that are present in the JSON object._

| Component | JSON block | Description |
|:---------:|:----------:|:-----------:|
| seq | None | sequence number of message, is used to track the messages |
| tim | None | Shows the timestamp of the latest datacollection |
| vhl | \- | Vehicle data block |
| accX | vhl | Acceleration in X-axis |
| accY | vhl | Acceleration in Y-axis |
| accZ | vhl | Acceleration in Z-axis |
| mtr | \- | Information related to the Hub-motor |
| pwr | mtr | Power of Hub-motor |
| rpm | mtr | RPM of Hub-motor |
| trq | mtr | RPM of Hub-motor |
| trq | mtr | RPM of Hub-motor |
| spc | \- | Information related to the Spectronik fuel cell |
| vsc | spc | Super capacitor voltage |
| tankP | spc | Hydrogen tank pressure |
| fan | spc | Fan speed of the fuel cell |
| H2P1 | spc | Hydrogen pressure sensor 1 |
| H2P2 | spc | Hydrogen pressure sensor 2 |

