@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\AVRStudio\AVR projects\ADC\labels.tmp" -fI -W+ie -C V2E -o "D:\AVRStudio\AVR projects\ADC\ADC.hex" -d "D:\AVRStudio\AVR projects\ADC\ADC.obj" -e "D:\AVRStudio\AVR projects\ADC\ADC.eep" -m "D:\AVRStudio\AVR projects\ADC\ADC.map" "D:\AVRStudio\AVR projects\ADC\ADC.asm"
