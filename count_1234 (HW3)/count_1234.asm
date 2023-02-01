//include DEFINITION FILE
.include "m8535def.inc"
//define constants
.equ LED = 3
.equ D = 1
.equ CLK = 0

.equ dig_0 = 0b11000000
.equ dig_1 = 0b11111001
.equ dig_2 = 0b10100100
.equ dig_3 = 0b10110000
.equ dig_4 = 0b10011001
.equ dig_5 = 0b10010010
.equ dig_6 = 0b10000010
.equ dig_7 = 0b11111000
.equ dig_8 = 0b10000000
.equ dig_9 = 0b10010000


//define variable
.def Acc0 = R16
.def Acc1 = R17
//Begin Programm
.org 0x0
	rjmp RESET ; Reset Handler
	rjmp EXT_INT0 ; IRQ0 Handler
	rjmp EXT_INT1 ; IRQ1 Handler
//	rjmp TIM2_COMP ; Timer2 Compare Handler
//	rjmp TIM2_OVF ; Timer2 Overflow Handler
//	rjmp TIM1_CAPT ; Timer1 Capture Handler
//	rjmp TIM1_COMPA ; Timer1 Compare A Handler
//	rjmp TIM1_COMPB ; Timer1 Compare B Handler
//	rjmp TIM1_OVF ; Timer1 Overflow Handler
//	rjmp TIM0_OVF ; Timer0 Overflow Handler
//	rjmp SPI_STC ; SPI Transfer Complete Handler
//	rjmp USART_RXC ; USART RX Complete Handler
//	rjmp USART_UDRE ; UDR Empty Handler
//	rjmp USART_TXC ; USART TX Complete Handler
//	rjmp ADC ; ADC Conversion Complete Handler
//	rjmp EE_RDY ; EEPROM Ready Handler
//	rjmp ANA_COMP ; Analog Comparator Handler
//	rjmp TWSI ; Two-wire Serial Interface Handler
//	rjmp EXT_INT2 ; IRQ2 Handler
//	rjmp TIM0_COMP ; Timer0 Compare Handler
//	rjmp SPM_RDY ; Store Program Memory Ready Handler



.org 0x15
RESET:
//INIT STACK
	ldi Acc0, LOW(RAMEND)
	out SPL, Acc0
	ldi Acc0, HIGH(RAMEND)
	out SPH, Acc0

//INIT Special Function Register

	ldi Acc0, (1<<ISC01)|(0<<ISC00)|(1<<ISC11)|(0<<ISC10)
	out MCUCR, Acc0

	ldi Acc0, (1<<INT0)|(1<<INT1)
	out GICR, Acc0

	sei  


//MAIN LOOP
LOOP:

	ldi r16, 3
	out DDRC, r16
	ldi xl, low(0x6A)
	ldi xh, high(0x6A)

	ldi r17, 0b11111111
	rcall SEV_SEG
	ldi r17, 0b11111111
	rcall SEV_SEG
	ldi r17, 0xFF
	rcall SEV_SEG
	ldi r17, 0b11111111
	rcall SEV_SEG

	DIG_MOVING:

	ldi r17, dig_0
	rcall sev_seg
	rcall DELAY_500
	ldi r17, dig_1
	rcall sev_seg
	rcall DELAY_500
	ldi r17, dig_2
	rcall sev_seg
	rcall DELAY_500
	ldi r17, dig_3
	rcall sev_seg
	rcall DELAY_500
	ldi r17, dig_4
	rcall sev_seg
	rcall DELAY_500
	ldi r17, dig_5
	rcall sev_seg
	rcall DELAY_500
	ldi r17, dig_6
	rcall sev_seg
	rcall DELAY_500
	ldi r17, dig_7
	rcall sev_seg
	rcall DELAY_500
	ldi r17, dig_8
	rcall sev_seg
	rcall DELAY_500
	ldi r17, dig_9
	rcall sev_seg
	rcall DELAY_500
	rjmp DIG_MOVING


	rjmp LOOP


//SubProgramm
DELAY_500:
    ldi  r20, 3
    ldi  r21, 138
    ldi  r22, 86
L1: dec  r22
    brne L1
    dec  r21
    brne L1
    dec  r20
    brne L1
ret


SEV_SEG:
	ldi r16, 8
	start:
	lsl r17
	brcc C0
	sbi PORTC, 1
	rjmp clock
	C0:
		cbi PORTC, 1
		nop
		nop
	clock:
	sbi PORTC, 0
	nop
	nop
	cbi PORTC, 0
	dec r16
	brne start
ret

//Interrupt Routine
EXT_INT0:
	push xl
	push xh
	push r17

	set

	pop r17
	pop xh
	pop xl
	reti

EXT_INT1:
	push xl
	push xh

	clt

	pop xh
	pop xl
	reti

//User Data
.dseg
DATA_BYTE:
.DB 0x33, 0x44, 0x55
DATA_WORD:
.DW 0x1234, 0x9876



