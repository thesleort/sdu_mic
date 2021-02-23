# sdu_mic

## Assembling
How to assemble: `avra -I /usr/local/include/avr/ <asmfile>`

## USB id
ID 0403:6001 Future Technology Devices International, Ltd FT232 Serial (UART) IC

## avrdude

```
sudo avrdude -p ATMEGA32  -c usbasp -U flash:w:opgave1.hex
```