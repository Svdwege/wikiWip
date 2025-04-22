"start" can be send to start the module.

half year rapport:
choice needs to be documented.

ToDo:

Test cable

- continuity
- measure sensor return

Test Sensor

transmit data from car to server.
temp sim from KPN?

server+db:Julian
hardware:
software:

how does the user want the data

- logged?
- live?
- stored for analysis?

as sub team general grade: ex 7, ask each individual question ensure knowledge is present and if they contributed to the team.

Remko: Version management required

deadline: 2 weeks?

Docs: officially follow Documentation, practically have meetings and rapid change, plan of approach to big after 7 pages small doc with deadlines. assume half march race, 1 week ahead be done.
Gantt/inwriting deadlines, deliverables. for future use.

Document: pinout of uart connector and make Cable
Send invoice to Rishi/Anna? for PCB. keer Remko up to date.
Change to C++
Ensure all code is in Remko's Gitlab before the End

Scaling down to:
Serial: read in from Spectronic Controller.
CAN: get settings from PT
Datalogging to SD (Adafruit datalogger(openlog))
Telemetry to Server

Cable seems fine, all pins are measured through.

0.5 V with ~10 mV per Bar
voltage divider made: 10K + 1k1 ensures 0.5 volt minimum
