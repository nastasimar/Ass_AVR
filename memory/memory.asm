
.include "m8535def.inc"
.def Acc0= R16
.def step = R17
LDI Xl, LOW (0x200)
LDI XH, High (0x200)
LDI R3, 10 

//LDI R16, 16 
//LDI R17, 17 
//LDI R18, 18 
//LDI R19, 19 
//LDI R20, 20 
//LDI R21, 21 
//LDI R22, 22 
//LDI R23, 23 
//LDI R24, 24 
//LDI R25, 25 
//LDI R26, 26 
//LDI R27, 27 
//LDI R28, 28 
//LDI R29, 29 
/* LDI R30, 30 
LDI R31, 31
MOV R0, R16
MOV R1, R17
MOV R2, R18
MOV R3, R19
MOV R4, R20
MOV R5, R21
MOV R6, R22
MOV R7, R23
MOV R8, R24
MOV R9, R25
MOV R10, R26
MOV R11, R27
MOV R12, R28
MOV R13, R29
MOV R14, R30
MOV R15, R31 */


/*LDI R16, 0xFF
OUT DDRB, R16

Clear:
CLR R17

Count:
OUT Port B, R17 
inc R17 
CPI R17, 64
BRNE Count 
rjmp Clear */




/*LDI Acc0, 0
LDI Step, 5
LDI Zh, High (0x100)
LDI Zl, LOW (0x100)
Loop;
ST  Z+, Acc0
Add Acc0, step   
CPI Zh, High (0x1C8) 
BRNE Loop
CPI Zl, Low (0x1C8)
BRNE Loop */ 
LDI Xh, High (0x200)
LDI Xl, Low (0x200)
LDI Zh, High (Data*2)
LDI Zl, Low (Data*2)
Loop:
LPM R20, Z+
ST X+, R20
rcall EEPROM_write
dec R3
Breq Loop  

EEPROM_write:
; Wait for completion of previous write
sbic EECR,EEWE
rjmp EEPROM_write
; Set up address (r18:r17) in address register
out EEARH, Xh
out EEARL, Xl
; Write data (r16) to Data Register
out EEDR,r20
; Write logical one to EEMWE
sbi EECR,EEMWE
; Start eeprom write by setting EEWE
sbi EECR,EEWE

ret












