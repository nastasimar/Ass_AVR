//include DEFINITION FILE
.include "m8535def.inc"
//define constants
.equ LED = 3
.equ ASCII = 0x30
.equ endl = 0x0A
//define variable
.def Acc0 = R16
.def Acc1 = R17
.def S_ed = R18
.def S_dec = R19
.def M_ed = R20
.def M_dec = R21
//Begin Programm
.org 0x0
	rjmp RESET ; Reset Handler
	rjmp EXT_INT0 ; IRQ0 Handler
	rjmp EXT_INT1 ; IRQ1 Handler
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

//UART

	clr S_ed
	clr S_dec
	clr M_ed
	clr M_dec

	ldi r16, 3
	out DDRC, r16	

	ldi r16, (1<<U2X)
	out UCSRA, r16

	ldi r16, (1<<RXEN)|(1<<TXEN)
	out UCSRB, r16
	
	ldi r16, (1<<URSEL)
	out UCSRC, r16

	ldi r16, (1<<URSEL)|(0b00<<UPM0)|(0b11<<UCSZ0)
	out UCSRC, r16

	ldi r16, (1<<AS2)
	out ASSR, r16

	ldi r16, (0b101<<CS20)
	out TCCR2, r16

	ldi r16, (1<<TOIE2)
	out TIMSK, r16
	
	ldi Acc0, (1<<ISC01)|(0<<ISC00)|(1<<ISC11)|(0<<ISC10)
	out MCUCR, Acc0


	
	sbi DDRD, 1
	sei  

//MAIN LOOP
LOOP:

	rjmp LOOP

//SubProgramm

Num_to_Seg:
	ldi ZL, LOW(NUMBERS*2)
	ldi ZH, HIGH(NUMBERS*2)
	add ZL, r16

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
EXT_INT0:
	push Acc0
	push Acc1

//code

	set


TIM2_OVF:
	push Acc0
	push Acc1

	inc S_ed
	cpi S_ed, 10
	breq S_dec_inc

	rjmp TIM2_OVF_IND

S_dec_inc:
	clr S_ed
	inc S_dec
	cpi S_dec, 6	
	breq M_ed_inc

	rjmp TIM2_OVF_IND	

M_ed_inc:
	clr S_dec
	inc M_ed
	cpi M_ed, 10	
	breq M_dec_inc

	rjmp TIM2_OVF_IND
	
M_dec_inc:
	clr M_ed
	inc M_dec
	cpi M_dec, 6
	breq M_dec_clr

	rjmp TIM2_OVF_IND

M_dec_clr:
	clr M_dec

TIM2_OVF_IND:

	ldi r22, ASCII
	
	mov Acc0, M_dec
	rcall Num_to_Seg
	add Acc0, r22
	out UDR, Acc0
	rcall SEV_SEG


	mov Acc0, M_ed
	rcall Num_to_Seg
	add Acc0, r22
	out UDR, Acc0

//dot
	BRTS T_set
	//ori Acc1, 0x80
	sbr Acc1, (1<<7)
	set
	rjmp T_out
T_set:
	//ANDI Acc1, 0x7F
	cbr Acc1, (1<<7)
	clt
T_out:
//DOT

	//ori Acc1, 0x80
	//sbr Acc1, 0x80
	rcall SEV_SEG
	ldi Acc1, 58
	out UDR, Acc1

	mov Acc0, S_dec
	rcall Num_to_Seg
	add Acc0, r22
	out UDR, Acc0


	rcall SEV_SEG
//	ldi Acc1, endl
//	out UDR, Acc1

	mov Acc0, S_ed
	rcall Num_to_Seg
	add Acc0, r22
	out UDR, Acc0
	rcall SEV_SEG
//	ldi Acc1, endl
	ldi Acc1, 32
	out UDR, Acc1
	
	pop Acc1
	pop Acc0

	reti

//User Data

NUMBERS:
.DB 0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90
DATA_WORD:
.DW 0x1234, 0x9876

