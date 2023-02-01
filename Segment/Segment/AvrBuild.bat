@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\2019\AVR\Segment\labels.tmp" -fI -W+ie -C V2E -o "D:\2019\AVR\Segment\Segment.hex" -d "D:\2019\AVR\Segment\Segment.obj" -e "D:\2019\AVR\Segment\Segment.eep" -m "D:\2019\AVR\Segment\Segment.map" "D:\2019\AVR\Segment\Segment.asm"
