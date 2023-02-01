//include DEFINITION FILE
.include "m8535def.inc"
//define constants
.equ LED = 3
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

//	ldi Acc0, (1<<3)//|(1<<7)
//	out DDRB, Acc0

	sbi DDRB, LED
	sbi PORTB, LED

	ldi Acc0, (1<<ISC01)|(0<<ISC00)|(1<<ISC11)|(0<<ISC10)
	out MCUCR, Acc0

	ldi Acc0, (1<<INT0)|(1<<INT1)
	out GICR, Acc0

	sei  

//MAIN LOOP
LOOP:
//
	brtc LOOP


	cbi PORTB,3 
	rcall Delay
	sbi PORTB,3 
	rcall Delay

	rjmp LOOP



//SubProgramm
Delay:
ldi Acc1, 0xC
	D2:

		ldi Acc0, 0x9C
		D1:
			nop
			Inc Acc0
			BRNE D1
		nop
		inc Acc1
		BRNE D2
ret

//Interrupt Routine
EXT_INT0:
	push Acc0
	push Acc1

//code

	//brts EI01 // proverka flaga T
	set
	pop Acc1
	pop Acc0

	reti


EXT_INT1:
	push Acc0
	push Acc1

//code
	clt


	pop Acc1
	pop Acc0

	reti

//User Data
.dseg
DATA_BYTE:
.DB 0x33, 0x44, 0x55
DATA_WORD:
.DW 0x1234, 0x9876



