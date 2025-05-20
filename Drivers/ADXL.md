---
title: ADXL
---
# Driver

Currently uses 4 wire spi with interrupt resulting in a 7 pole cable when paired with power and ground,
this should be brought down to 3 wire spi to get a 6 pin cable

settings:
- Output data rate: 100 hz 
- measurement mode: true
- dataready interrupt
- interrupts on pin: int0
- fullres 
- 16g range

- https://www.analog.com/media/en/technical-documentation/data-sheets/adxl345.pdf
