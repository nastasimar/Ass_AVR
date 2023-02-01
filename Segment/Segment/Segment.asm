.include "m8535def.inc" 
.def i1=r17 
.def i2=r18 
.def i3=r19 
.def i4=r20 
.def temp=r16 
.equ ch0=0b00000011 
.equ ch1=0b10011111 
.equ ch2=0b00100101 
.equ ch3=0b00001101 
.equ ch4=0b10011001 
.equ ch5=0b01001001 
.equ ch6=0b01000001 
.equ ch7=0b00011111 
.equ ch8=0b00000001 
.equ ch9=0b00001001 
.equ chv=0b10000011 
.equ che=0b01100001 
.equ chr=0b00010001 
.org 0x0 
rjmp Reset 
.org 0x15 
Reset: 

ldi temp, HIGH(RAMEND) 
out SPH, temp 
ldi temp, LOW(RAMEND) 
out SPL, temp 
rcall Init_ports 
rcall obnull 

Loop: 
sbi PORTB,4 
sbi PORTB,5 
sbi PORTB,6 
cbi PORTB,7 
rcall delay 


sbis PIND,5 
rjmp zv 
sbis PIND,6 
rjmp null 


cbi PORTB,4 
sbi PORTB,5 
sbi PORTB,6 
sbi PORTB,7 

sbis PIND,5 
rjmp one 
sbis PIND,6 
rjmp two 
sbis PIND,7 
rjmp three 

sbi PORTB,4 
cbi PORTB,5 
sbi PORTB,6 
sbi PORTB,7 

sbis PIND,5 
rjmp four 
sbis PIND,6 
rjmp five 
sbis PIND,7 
rjmp six 

sbi PORTB,4 
sbi PORTB,5 
cbi PORTB,6 
sbi PORTB,7 

sbis PIND,5 
rjmp seven 
sbis PIND,6 
rjmp eight 
sbis PIND,7 
rjmp nine 


rjmp Loop 


;--------------------— 
one: 
ldi temp,1 
rcall sum 
rjmp Loop 
two: 
ldi temp,2 
rcall sum 
rjmp Loop 
three: 
ldi temp,3 
rcall sum 
rjmp Loop 
four: 
ldi temp,4 
rcall sum 
rjmp Loop 
five: 
ldi temp,5 
rcall sum 
rjmp Loop 
six: 
ldi temp,6 
rcall sum 
rjmp Loop 
seven: 
ldi temp,7 
rcall sum 
rjmp Loop 
eight: 
ldi temp,8 
rcall sum 
rjmp Loop 
nine: 
ldi temp,9 
rcall sum 
rjmp Loop 
null: 
ldi temp,0 
rcall sum 
rjmp Loop 
zv: 
rcall obnull 
rjmp Loop 
;---------------------— 
Init_ports: 
ldi temp,0b11110000 
out DDRB, temp 
ldi temp,0b000000000 
out DDRD, temp 
sbi DDRC,0 
sbi DDRC,1 
ret 
;---------------------— 
obnull: 
ldi i4,0 
ldi i3,0 
ldi i2,0 
ldi i1,0 
rcall razryad 
ret 
;---------------------— 

razryad: 
mov temp, i4 
rcall download 
rcall Send_byte_indicator 
mov temp, i3 
rcall download 
rcall Send_byte_indicator 
mov temp, i2 
rcall download 
rcall Send_byte_indicator 
mov temp, i1 
rcall download 
rcall Send_byte_indicator 
rcall long_delay 
ret 
;-----------------------— 

download: 
cpi temp,0 
BREQ nol1 

cpi temp,1 
BREQ one1 
cpi temp,2 
BREQ two1 
cpi temp,3 
BREQ three1 
cpi temp,4 
BREQ four1 
cpi temp,5 
BREQ five1 
cpi temp,6 
BREQ six1 
cpi temp,7 
BREQ seven1 
cpi temp,8 
BREQ eight1 
cpi temp,9 
BREQ nine1 
ret 

nol1: 
ldi temp, ch0 
ret 
one1: 
ldi temp, ch1 
ret 
two1: 
ldi temp, ch2 
ret 
three1: 
ldi temp, ch3 
ret 
four1: 
ldi temp, ch4 
ret 
five1: 
ldi temp, ch5 
ret 
six1: 
ldi temp, ch6 
ret 
seven1: 
ldi temp, ch7 
ret 
eight1: 
ldi temp, ch8 
ret 
nine1: 
ldi temp, ch9 
ret 

;----------------------------------— 
Send_byte_indicator: 
cbi PORTC,0 
cbi PORTC,1 
clr r21 


send_loop: 
lsr temp 
brcs Send1 
rjmp Send0 

Send1: 
sbi PORTC,1 
rjmp strobe 
Send0: 
cbi PORTC,1 

strobe: 
sbi PORTC,0 
nop 
nop 
cbi PORTC,0 
inc r21 
cpi r21,8 
brne send_loop 
ret 

sum: 
add i1,temp 
rcall sravn1 
rcall sravn2 
rcall sravn3 
rcall sravn4 
rcall razryad 
ret 
sravn1: 
cpi i1,10 
brsh otnim1 
ret 
otnim1: 
subi i1,10 
inc i2 
ret 
sravn2: 
cpi i2,10 
breq otnim2 
ret 
otnim2: 
subi i2,10 
inc i3 
ret 

sravn3: 
cpi i3,10 
breq otnim3 
ret 
otnim3: 
subi i3,10 
inc i4 
ret 
sravn4: 
cpi i4,10 
breq overflow 
ret 
overflow: 
ldi temp, ch0 
rcall Send_byte_indicator 
ldi temp, chv 
rcall Send_byte_indicator 
ldi temp, che 
rcall Send_byte_indicator 
ldi temp, chr 
rcall Send_byte_indicator 
sbi PORTB,7 
sbi PORTB,4 
sbi PORTB,5 
cbi PORTB,6 
Over: 
sbic PIND,5 
rjmp Over 
rcall obnull 
ret 
delay: 
clr r22 
delay_loop: 
inc r22 
cpi r22,0 
brne delay_loop 
ret 
long_delay: 
clr r23 
long_delay_loop: 
inc r23 
rcall delay 
cpi r23,0 
brne long_delay_loop 
ret
