.include "m8535def.inc"
.equ LED = 3 
.def acc0 = R16
.def acc1 = R17
.def razr1 = R20
.def razr2 = R21
.org 0x0

rjmp RESET
rjmp EXT_INT0
rjmp EXT_INT1

.org 0x15
RESET:
	ldi acc0, low(RAMEND)
	out SPL, acc0 
	ldi acc1, high(RAMEND)
	out SPH, acc1
	
	sbi DDRB, LED
	//sbi PORTB, LED

	ldi acc0, (1 << ISC01) | (1 << ISC00) | (1 << ISC11) | (1 << ISC10)
	out MCUCR, Acc0

	ldi acc0, (1 << INT0) | (1 << INT1)
	out GICR, Acc0

	sei

LOOP:
	sbi PORTB, LED
	brtc loop
	cbi PORTB, LED
	rcall Delay
	sbi PORTB, LED
	rcall Delay
	rjmp loop

Delay:
	ldi razr1, 255
	ldi razr2, 65

PDelay:	

	subi razr1, 1
	sbci razr2, 0
	brcc PDelay
	ret	

EXT_INT0:
	push acc0
	push acc1

	//brts EI01
	set
	rjmp End_EI0

//EI01:
	//clt

End_EI0:	
	pop acc1
	pop acc0

	reti

EXT_INT1:
	push acc0
	push acc1

	clt
	rjmp End_EI0

	
