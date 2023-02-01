//include DEFINITION FILE
.include "m8535def.inc"
//define constants
.equ LED = 3
//define variable
.def Acc0 = R16
.def Acc1 = R17
.def RAZR_1 = R18
.def RAZR_10 = R19
.def RAZR_100 = R20
.def ASCII = R22
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
.org 0x00E
	rjmp ADC_CONV ; ADC Conversion Complete Handler
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

/////////////UART///////////////
	ldi ASCII, 0x30	

	ldi r16, 3
	out DDRC, r16	

	ldi r16, (0b01<<REFS0)|(1<<ADLAR)|(0b00000<<MUX0)
	out ADMUX, r16

	ldi r16, (0<<ADSC)|(1<<ADEN)|(0<<ADIF)|(1<<ADATE)|(1<<ADIE)|(0b100<<ADPS0)  //nastraivaem no ne vkluchaem
	out ADCSRA, r16

	in r16, SFIOR
	sbr r16, (0b100<<ADTS0)
	out SFIOR, r16


	ldi r16, 0b101<<CS00
	out TCCR0, r16

	ldi r16, (1<<ADSC)|(1<<ADEN)|(0<<ADIF)|(1<<ADATE)|(1<<ADIE)|(0b100<<ADPS0)  //vkluchaem
	out ADCSRA, r16

	sei  //razreshenie raboty controllera


//MAIN LOOP
LOOP:

rjmp LOOP


Indicator:
clr RAZR_100
clr RAZR_10
clr RAZR_1
sotni:
	subi r16, 100
	BRCS dec_0
	//brmi dec_0
	inc RAZR_100
	rjmp sotni
dec_0:
	ldi r21, 100
	add r16, r21 // vozvrashaem
dec_1:
	subi r16, 10
	BRCS ed_0
	//brmi ed_0
	inc RAZR_10
	rjmp dec_1
ed_0:
	ldi r21, 10
	add r16, r21
ed_1:
	subi r16, 1
	breq data_out
	inc RAZR_1
	rjmp ed_1
data_out:

	ldi r17, 11
	rcall Num_to_Seg
	rcall SEV_SEG

	mov r17, RAZR_100
	rcall Num_to_Seg
	rcall SEV_SEG

	mov r17, RAZR_10
	rcall Num_to_Seg
	rcall SEV_SEG

	mov r17, RAZR_1
	rcall Num_to_Seg
	rcall SEV_SEG

ret
//SubProgramm

Num_to_Seg:
	ldi ZL, LOW(NUMBERS*2)
	ldi ZH, HIGH(NUMBERS*2)
	add ZL, Acc1

	brcc NTS
	inc ZH

NTS:
	lpm Acc1, Z
ret

SEV_SEG:
	push r16

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

	pop r16
ret

//Interrupt Routine
EXT_INT0:
	push Acc0
	push Acc1

//code

	set

ENT:
	sbis UCSRA, UDRE
	rjmp ENT
	
	ldi r16, 0x31
	out UDR, r16

	pop Acc1
	pop Acc0

	reti


EXT_INT1:
	push Acc0
	push Acc1

//code
	

	pop Acc1
	pop Acc0

	reti

ADC_CONV:
	push r16
	push r18
	in r18, SREG
	push r18

	in r16, ADCH
	rcall Indicator

	in r16, TIFR //sbros flaga
	out TIFR, r16
	


	pop r18
	out SREG, r18
	pop r18
	pop r16

	reti
	

//User Data
.dseg
NUMBERS:
.DB 0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90, 0xFF
DATA_WORD:
.DW 0x1234, 0x9876

