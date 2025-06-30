# The Telemetry Receiving Unit

Welcome to the _Telemetry Receiving Unit_ wiki page! Here you can find the information about this unit.

# General information

The telemetry receiving unit is the server-side code that reads messages from the MQTT broker running on the server. After a message is successfully received, it will be inserted into the MySQL database running locally on the server.

The software is running in a Docker container with Alpine as the operating system.

# Location to find information

- For information about the communication between the ESP32-S3 and the server, [please see sender-server wiki](/home/communication/sender-server)
- For information about the configuration file for the receiving unit, [please see the Configure-receiving-unit wiki](/home/Receiving-unit/Configure-receiving-unit)

Within this repository, there are examples of the different functions implemented in this program. These examples can be used to learn about specific features and can be found under `<root_of_repository>\examples\telemetry-receiving\`