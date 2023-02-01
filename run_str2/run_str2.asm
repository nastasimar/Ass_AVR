//Include DEFINITION FILE
.include "m8535def.inc"
//define constants
.equ LED = 3
.equ Data = 1
.equ CLK = 0

//define variable
.def Acc0 = R16
.def Acc1 = R17


//Begin Programm
.org 0x0
	rjmp RESET ; Reset Handler
//jmp EXT_INT0 ; IRQ0 Handler
//	rjmp EXT_INT1 ; IRQ1 Handler
//	rjmp TIM2_COMP ; Timer2 Compare Handler
//	rjmp TIM2_OVF ; Timer2 Overflow Handler
//	rjmp TIM1_CAPT ; Timer1 Capture Handler
.org 0x6
	rjmp TIM1_COMPA ; Timer1 Compare A Handler
//	rjmp TIM1_COMPB ; Timer1 Compare B Handler
//	rjmp TIM1_OVF ; Timer1 Overflow Handler
//	rjmp TIM0_OVF ; Timer0 Overflow Handler
//	rjmp SPI_STC ; SPI Transfer Complete Handler
//rjmp USART_RXC ; USART RX Complete Handler
//	rjmp USART_UDRE ; UDR Empty Handler
//	rjmp USART_TXC ; USART TX Complete Handler
.org 0x00E
rjmp ADC_INT ; ADC Conversion Complete Handler
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

//INIT Spec Func Reg
//settings adc
ldi Acc0,3
out DDRC, Acc0

ldi Acc0, (0b101 << CS00)
out TCCR0, Acc0

ldi Acc0, (0b01 << REFS0) | (1 << ADLAR) | (0b0 << MUX0)
out ADMUX, Acc0

ldi Acc0, (1 << ADEN) |(1 << ADATE) | (0 << ADIF) | (1 << ADIE) | (0b111 << ADPS0)
out ADCSRA, Acc0

ldi Acc0, (0b100 << ADTS0)
out SFIOR, Acc0

ldi Acc0, (1 << ADEN) |(1 << ADATE) | (1 << ADSC) | (1 << ADIE) | (0b111 << ADPS0)
out ADCSRA, Acc0 
// settings timer1
	ldi r16, (0b00<<WGM10) //CTC
	out TCCR1A, r16

	ldi Acc1, 0
	out OCR1AH, Acc1
	ldi Acc1, 0xFF
	out OCR1AL, Acc1

    ldi r16, (0b01 << WGM12) | (0b100<<CS10) //prescaler 64
	out TCCR1B, r16
	
	ldi r16, (1<<OCIE1A)
	out TIMSK, r16



  
   
	
	sbi DDRD, 1 

ldi r17,0
sei

ldi r23,255

//MAIN LOOP
LOOP:
	rcall DISPLAY
loop1:
rjmp Loop1
//SubProgramm
	CHANGE:
  MOV Acc1, r18
  add Acc1, r18
   ldi Acc0, LOW(32768)
   add Acc1, Acc0
   OUT OCR1AL, Acc1
/*   LSR ACC1
   LSR ACC1
   LSR ACC1
   LSR ACC1
   LSR ACC1
   LSR ACC1
   LSR ACC1
   LSR ACC1 */
 //  ldi Acc0, LOW(0)
 //  OUT OCR1AL, Acc0
   ldi Acc0, HIGH(32768)
   out OCR1AH, Acc0
   rcall NUM_TO_SEG
   ret
 
	rcall sevseg
	INC Acc1
	rcall sevseg
	INC Acc1
	rcall sevseg
	INC Acc1
	rcall sevseg
    INC Acc1

	ret

DISPLAY:
	push r16
	push r25
	ldi r16, 4
	mov r25, r17
DISPLAY_0:
	rcall Num_to_Seg
	rcall sevseg
	inc Acc1
	cpi Acc1, 15
	brne DISPLAY_1
	ldi Acc1, 0
DISPLAY_1:
	dec r16
	brne DISPLAY_0
	mov r17, r25
	inc r17
	cpi r17, 15
	brne DISPLAY_2
	ldi Acc1, 0
DISPLAY_2:
	pop r25
	pop r16
ret

Num_to_Seg:
	ldi ZL, LOW(CIF*2)
	ldi ZH, HIGH(CIF*2)
	add ZL, Acc1

	brcc NTS
	inc ZH

NTS:
	lpm r19, Z
ret

SEVSEG:
	push r16

	ldi r16, 8
	start:
	lsl r19
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






//////////

//User DATA
//.dseg
ADC_INT:
	push r18
	in r18,SREG
	push r18
	push Acc1
	push Acc0
	push r22

	in r23, ADCH
	com r23
//	com r23
//	out OCR1AH, r18
//	rcall change 
	in Acc0, TIFR
	out TIFR,Acc0

	pop r22
	pop Acc0
	pop Acc1
	pop r18
	out SREG, r18
	pop r18

	reti


TIM1_COMPA: 
	
	cp r22, r23
	brlo TIM1_COMPA_INC
    rcall DISPLAY
	clr r22
	rjmp TIM1_COMPA_OUT
TIM1_COMPA_INC:
	cpi r23, 200
	brlo TIM1_COMPA_INC2
	inc r22
	inc r22
TIM1_COMPA_INC2:// speed 
	inc r22
	inc r22
	inc r22
	inc r22
	inc r22
	inc r22

TIM1_COMPA_OUT:
	reti


.org 0x100
CIF:
.DB 0b11000111, 0x88, 0b10010010, 0x87, 0xFF, 0x8C, 0xAF, 0xC0, 0x90, 0xAF, 0x88, 0xEA, 0xFF,0xFF, 0xFF
