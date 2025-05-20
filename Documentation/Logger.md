---
title: Logger
---
# Openlog

## important info

Send 0x1a(control-z) 3 times for command mode.

Wait for '>' to be send to confirm we are in command mode. (takes approx. 15ms)

'\<' is send when the module is in Logging mode.
When initializeing the device the default state is logging mode and we should wait or check if '\<' has been send.
[hookup guide and quick walkthrough](https://learn.sparkfun.com/tutorials/openlog-hookup-guide)

## openlog firmware versions

- OpenLog - Firmware that ships with OpenLog. '?' command will show the version loaded onto a unit.
- OpenLog_Light - Used for high-speed logging. By removing the menu and command mode the receive buffer is increased.
- OpenLog_Minimal - Highest speed logging. Baud rate must be set in code and uploaded. Hardest, most advanced, and best at high-speed logging.
