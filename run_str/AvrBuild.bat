@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\AVRStudio\AVR projects\run_str\labels.tmp" -fI -W+ie -C V2E -o "D:\AVRStudio\AVR projects\run_str\run_str.hex" -d "D:\AVRStudio\AVR projects\run_str\run_str.obj" -e "D:\AVRStudio\AVR projects\run_str\run_str.eep" -m "D:\AVRStudio\AVR projects\run_str\run_str.map" "D:\AVRStudio\AVR projects\run_str\run_str.asm"
