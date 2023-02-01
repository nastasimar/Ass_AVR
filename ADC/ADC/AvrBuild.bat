@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\2022\AVR\ADC\labels.tmp" -fI -W+ie -C V2E -o "D:\2022\AVR\ADC\ADC.hex" -d "D:\2022\AVR\ADC\ADC.obj" -e "D:\2022\AVR\ADC\ADC.eep" -m "D:\2022\AVR\ADC\ADC.map" "D:\2022\AVR\ADC\ADC.asm"
