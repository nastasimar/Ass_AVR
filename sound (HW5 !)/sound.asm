//include DEFINITION FILE
.include "m8535def.inc"
//define constants
.equ LED = 3
.equ do = 1000000/262
.equ do_d = 1000000/277
.equ re = 1000000/294
.equ re_d = 1000000/311
.equ mi = 1000000/330
.equ fa = 1000000/349
.equ fa_d = 1000000/370
.equ sol = 1000000/392
.equ sol_d = 1000000/415
.equ la = 1000000/440
.equ la_d = 1000000/466
.equ si = 1000000/494
//define variable
.def Acc0 = R16
.def Acc1 = R17
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

	sbi DDRB, LED

	ldi Acc0, (1<<ISC01)|(0<<ISC00)|(1<<ISC11)|(0<<ISC10)
	out MCUCR, Acc0

	ldi Acc0, (1<<INT0)|(1<<INT1)
	out GICR, Acc0

	ldi r16, (0<<WGM11)|(0<<WGM10)|(0b01<<COM1B0)
	out TCCR1A, r16
	ldi r16, (0<<WGM13)|(1<<WGM12)|(0b001<<CS10)
	out TCCR1B, r16

	sei  //razreshenie raboty controllera
	sbi DDRD, 4

//MAIN LOOP
LOOP:


	//F#

	ldi Acc0, HIGH(do)
	out OCR1AH, Acc0
	ldi Acc0, LOW(do)
	out OCR1AL, Acc0

	rcall Delay_250ms
	rcall Delay_250ms

	ldi Acc0, HIGH(fa)
	out OCR1AH, Acc0
	ldi Acc0, LOW(fa)
	out OCR1AL, Acc0

	rcall Delay_250ms
    rcall Delay_250ms

	ldi Acc0, HIGH(mi)
	out OCR1AH, Acc0
	ldi Acc0, LOW(mi)
	out OCR1AL, Acc0

	rcall Delay_250ms
	rcall Delay_250ms

	ldi Acc0, HIGH(do)
	out OCR1AH, Acc0
	ldi Acc0, LOW(do)
	out OCR1AL, Acc0

	rcall Delay_250ms

	ldi Acc0, HIGH(do)
	out OCR1AH, Acc0
	ldi Acc0, LOW(do)
	out OCR1AL, Acc0

	rcall Delay_250ms
	rcall Delay_250ms

	ldi Acc0, HIGH(re)
	out OCR1AH, Acc0
	ldi Acc0, LOW(re)
	out OCR1AL, Acc0

	rcall Delay_250ms

	ldi Acc0, HIGH(do)
	out OCR1AH, Acc0
	ldi Acc0, LOW(do)
	out OCR1AL, Acc0

	rcall Delay_250ms
	rcall Delay_250ms

	ldi Acc0, HIGH(sol)
	out OCR1AH, Acc0
	ldi Acc0, LOW(sol)
	out OCR1AL, Acc0

	rcall Delay_250ms
	rcall Delay_250ms

	ldi Acc0, HIGH(fa)
	out OCR1AH, Acc0
	ldi Acc0, LOW(fa)
	out OCR1AL, Acc0

	rcall Delay_250ms
	rcall Delay_250ms

	ldi Acc0, HIGH(do)
	out OCR1AH, Acc0
	ldi Acc0, LOW(do)
	out OCR1AL, Acc0

	rcall Delay_250ms

	ldi Acc0, HIGH(do)
	out OCR1AH, Acc0
	ldi Acc0, LOW(do)
	out OCR1AL, Acc0

	rcall Delay_250ms
	rcall Delay_250ms

	ldi Acc0, HIGH(do)
	out OCR1AH, Acc0
	ldi Acc0, LOW(do)
	out OCR1AL, Acc0

	rcall Delay_250ms

	ldi Acc0, HIGH(la)
	out OCR1AH, Acc0
	ldi Acc0, LOW(la)
	out OCR1AL, Acc0

	rcall Delay_250ms
	rcall Delay_250ms
	
	
	ldi Acc0, HIGH(fa)
	out OCR1AH, Acc0
	ldi Acc0, LOW(fa)
	out OCR1AL, Acc0

	rcall Delay_250ms

	ldi Acc0, HIGH(fa)
	out OCR1AH, Acc0
	ldi Acc0, LOW(fa)
	out OCR1AL, Acc0

	rcall Delay_250ms
	

	ldi Acc0, HIGH(mi)
	out OCR1AH, Acc0
	ldi Acc0, LOW(mi)
	out OCR1AL, Acc0

	rcall Delay_250ms

	ldi Acc0, HIGH(re)
	out OCR1AH, Acc0
	ldi Acc0, LOW(re)
	out OCR1AL, Acc0

	rcall Delay_250ms
	rcall Delay_250ms

	ldi Acc0, HIGH(la_d)
	out OCR1AH, Acc0
	ldi Acc0, LOW(la_d)
	out OCR1AL, Acc0

	rcall Delay_250ms

	ldi Acc0, HIGH(la_d)
	out OCR1AH, Acc0
	ldi Acc0, LOW(la_d)
	out OCR1AL, Acc0

	rcall Delay_250ms
	rcall Delay_250ms
	

	ldi Acc0, HIGH(la)
	out OCR1AH, Acc0
	ldi Acc0, LOW(la)
	out OCR1AL, Acc0

	rcall Delay_250ms

	ldi Acc0, HIGH(fa)
	out OCR1AH, Acc0
	ldi Acc0, LOW(fa)
	out OCR1AL, Acc0

	rcall Delay_250ms
	rcall Delay_250ms
	
	ldi Acc0, HIGH(sol)
	out OCR1AH, Acc0
	ldi Acc0, LOW(sol)
	out OCR1AL, Acc0

	rcall Delay_250ms

	ldi Acc0, HIGH(fa)
	out OCR1AH, Acc0
	ldi Acc0, LOW(fa)
	out OCR1AL, Acc0

	rcall Delay_250ms
	rcall Delay_250ms

	
	
rjmp LOOP

//SubProgramm

Delay_250ms:
    ldi  r18, 2
    ldi  r19, 69
    ldi  r20, 170
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
ret
	
//Interrupt Routine

TIM2_OVF:
	brts up
	dec r16
	brne T_OUT
	set
	rjmp T_OUT
	up:
	inc r16
	cpi r16, 255
	brne T_OUT
	clt
	T_OUT:
	out OCR0, r16
	reti
	
/***************************/

EXT_INT0:
	push Acc0
	push Acc1

	set

	pop Acc1
	pop Acc0

	reti

/***************************/

EXT_INT1:
	push Acc0
	push Acc1

	clt

	pop Acc1
	pop Acc0

	reti
	
/***************************/




//User Data
.dseg
DATA_BYTE:
.DB 0x33, 0x44, 0x55
DATA_WORD:
.DW 0x1234, 0x9876

