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
.equ empty = 0b11111111

//define variable
.def Acc0 = R16
.def Acc1 = R17
//Begin Programm
.org 0x0
	rjmp RESET ; Reset Handler
//	rjmp EXT_INT0 ; IRQ0 Handler
//	rjmp EXT_INT1 ; IRQ1 Handler
//	rjmp TIM2_COMP ; Timer2 Compare Handler
.org 0x4
	rjmp TIM2_OVF ; Timer2 Overflow Handler
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

/*--------------16-bit Timer-----------------*/

	ldi r16, (0b00<<WGM10)|(0b01<<COM1B0)
	out TCCR1A, r16

	ldi r16, (0b01<<WGM12)|(0b001<<CS10)
	out TCCR1B, r16

	ldi r16, HIGH(2272/2)
	out OCR1AH, r16
	ldi r16, LOW(2272/2)
	out OCR1AL, r16

	
/*--------------Quartz Timer-----------------*/

	ldi r16, (1<<AS2)
	out ASSR, r16

	ldi r16, (0b101<<CS20)
	out TCCR2, r16

	ldi r16, (1<<TOIE2)
	out TIMSK, r16

/*--------------Keyboard setup-----------------*/

	ldi r16, 3
	out DDRC, r16

	ldi r16, (1<<4) | (1<<5) | (1<<6) | (1<<7)
	out DDRB, r16

	ldi r16, (0<<5) | (0<<6) | (0<<7)
	out DDRD, r16

	set
	sei

/*--------------Display setup-----------------*/

	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, dig_0
	rcall SEV_SEG

	sbi DDRD, 4
	
//MAIN LOOP
LOOP:

	start_loop:
	brtc wait_for_jail


	ldi r19, (0<<PORTD4) | (1<<PORTD5) | (1<<PORTD6) | (1<<PORTD7)
	out PORTB, r19
	rcall DELAY_50

	sbis PIND, 5
	rjmp one

	sbis PIND, 6
	rjmp two
	
	sbis PIND, 7
	rjmp three


	ldi r19, (1<<PORTD4) | (0<<PORTD5) | (1<<PORTD6) | (1<<PORTD7)
	out PORTB, r19
	rcall DELAY_50

	sbis PIND, 5
	rjmp four

	sbis PIND, 6
	rjmp five

	sbis PIND, 7
	rjmp six


	ldi r19, (1<<PORTD4) | (1<<PORTD5) | (0<<PORTD6) | (1<<PORTD7)
	out PORTB, r19
	rcall DELAY_50
	
	sbis PIND, 5
	rjmp seven
	cont_seven:

	sbis PIND, 6
	rjmp eight


	sbis PIND, 7
	rjmp nine

	ldi r19, (1<<PORTD4) | (1<<PORTD5) | (1<<PORTD6) | (0<<PORTD7)
	out PORTB, r19
	rcall DELAY_50

	sbis PIND, 5
	rjmp star

	sbis PIND, 6
	rjmp zero

	sbis PIND, 7
	rjmp jail


	rjmp start_loop

wait_for_jail:

brts start_loop

	ldi r19, (1<<PORTD4) | (1<<PORTD5) | (1<<PORTD6) | (0<<PORTD7)
	out PORTB, r19
	rcall DELAY_50

	sbis PIND, 5
	rjmp star

rjmp wait_for_jail


one:
	ldi r18, 1
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, dig_1
	rcall SEV_SEG
	rjmp start_loop

two:
	ldi r18, 2
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, dig_2
	rcall SEV_SEG
	rjmp start_loop

three:
	ldi r18, 3
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, dig_3
	rcall SEV_SEG
	rjmp start_loop

four:
	ldi r18, 4
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, dig_4
	rcall SEV_SEG
	rjmp start_loop

five:
	ldi r18, 5
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, dig_5
	rcall SEV_SEG
	rjmp start_loop

six:
	ldi r18, 6
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, dig_6
	rcall SEV_SEG
	rjmp start_loop

seven:
	ldi r18, 7
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, dig_7
	rcall SEV_SEG
	rjmp start_loop

eight:
	ldi r18, 8
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, dig_8
	rcall SEV_SEG
	rjmp start_loop

nine:
	ldi r18, 9
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, dig_9
	rcall SEV_SEG
	rjmp start_loop

zero:
	ldi r18, 0
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, empty
	rcall SEV_SEG
	ldi r17, dig_0
	rcall SEV_SEG
	rjmp start_loop


star:
	set
	rjmp start_loop

jail:
	clt
	rjmp start_loop

rjmp LOOP





//SubProgramm
DELAY_50:
    ldi  r20, 7
    ldi  r21, 125
L1: dec  r21
    brne L1
    dec  r20
    brne L1
ret

Num_to_Seg:
	ldi ZL, LOW(NUMBERS*2)
	ldi ZH, HIGH(NUMBERS*2)
	add ZL, Acc0

	brcc NTS
	inc ZH

NTS:
	lpm Acc1, Z
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
TIM2_OVF:

	ldi r16, (0<<WGM13)|(1<<WGM12)|(0b000<<CS10)
	out TCCR1B, r16	


	brts TIM2_OVF_OUT
	
	tst r18



/*	cp r24, r18 
	breq TIM2_OVF_LOAD
	rjmp TIM2_OVF_CONT	
TIM2_OVF_LOAD:
	mov r24, r18
TIM2_OVF_CONT:

*/
	breq TIM2_OVF_RING
	dec r18
		ldi r17, empty
		rcall SEV_SEG
		ldi r17, empty
		rcall SEV_SEG
		ldi r17, empty
		rcall SEV_SEG
		mov r16, r18
		rcall Num_to_Seg
		rcall SEV_SEG
	rjmp TIM2_OVF_OUT

TIM2_OVF_RING:

	ldi r16, (0<<WGM13)|(1<<WGM12)|(0b001<<CS10)
	out TCCR1B, r16
	set	
	
TIM2_OVF_OUT:

reti

//User Data

NUMBERS:
.DB 0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90
DATA_BYTE:
.DB 0x33, 0x44, 0x55
DATA_WORD:
.DW 0x1234, 0x9876


