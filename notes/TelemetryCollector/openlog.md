# Openlog

## important info

Send 0x1a(control-z) 3 times for command mode.
Wait for '>' to be send to confirm we are in command mode.
'\<' is send when the module is in Logging mode.
When initializeing the device the default state is logging mode and we should wait or check if '\<' has been send.
[hookup guide and quick walkthrough](https://learn.sparkfun.com/tutorials/openlog-hookup-guide)

## openlog firmware versions

- OpenLog - Firmware that ships with OpenLog. '?' command will show the version loaded onto a unit.
- OpenLog_Light - Used for high-speed logging. By removing the menu and command mode the receive buffer is increased.
- OpenLog_Minimal - Highest speed logging. Baud rate must be set in code and uploaded. Hardest, most advanced, and best at high-speed logging.

## box

what commands

build and test setup in advance
perfboad with headers for each pin on the connector

##note 

LOG00004.TXT: contains the first test results sending 100x154 bytes of data over uart using DMA.

The logging library currently accepts a u8 array or a object which inherits from `Ilogable_object`.
This ensures that a `toString()` method is implemented for the data which needs to be logged.
Then call the `logger.logData()` method with the object carrying the data.

The loggable object can be made using the composite design pattern.
However it might be overcomplicating it, so to keep it simple for the first prototype the loggable data will be a single object with all info as properties.
Where `toString()` calls the subobjects to `toString()` functions to create a string representation of the composite object.
