//Include DEFINITION FILE
.include "m8535def.inc"
//define constants
.equ LED = 3
.equ Data = 1
.equ CLK = 0

//define variable
.def Acc0 = R16
.def Acc1 = R17
.def S_ed = R18
.def Sotni = R19
.def desyatochka = R20
.def edin = R21
//Begin Programm
.org 0x0
	rjmp RESET ; Reset Handler
//jmp EXT_INT0 ; IRQ0 Handler
//	rjmp EXT_INT1 ; IRQ1 Handler
//	rjmp TIM2_COMP ; Timer2 Compare Handler
//jmp TIM2_OVF ; Timer2 Overflow Handler
//	rjmp TIM1_CAPT ; Timer1 Capture Handler
//	rjmp TIM1_COMPA ; Timer1 Compare A Handler
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

sei
set

//MAIN LOOP
LOOP:


rjmp Loop
//SubProgramm
	Indic:	
	ldi Sotni, 0
	ldi desyatochka, 0
	ldi edin, 0
	Sot:
	subi r18, 100
	brcs dec_0
	inc Sotni
	rjmp Sot

	dec_0:
	ldi r22 , 100
	add r18, r22

	Desyatka:
	subi r18, 10
	brcs dec_1
	inc desyatochka
	rjmp Desyatka

	dec_1:
	ldi r22, 10
	add r18,r22
	mov edin, r18

	NUM_TO_SEG:
	ldi ZL, LOW(CIF*2)
	ldi ZH, HIGH (CIF*2)
	add Zl, sotni
	brcc NTS1
	inc ZH
	NTS1:
	lpm sotni , Z

	ldi ZL, LOW(CIF*2)
	ldi ZH, HIGH (CIF*2)
	add Zl, desyatochka
	brcc NTS2
	inc ZH
	NTS2:
	lpm desyatochka , Z

	ldi ZL, LOW(CIF*2)
	ldi ZH, HIGH (CIF*2)
	add Zl, edin
	brcc NTS3
	inc ZH
	NTS3:
	lpm edin , Z

	ldi Acc1, 0xFF
	rcall sevseg
	mov Acc1, sotni
	rcall sevseg
	mov Acc1, desyatochka
	rcall sevseg
	mov Acc1,edin
	rcall sevseg

	ret

sevseg:
ldi Acc0, 8
ss1:
	lsl Acc1
	brcc Co
	sbi PORTC,Data
	rjmp Clock
Co:
	cbi PORTC,Data
	nop
	nop
Clock:

	sbi PORTC,CLK
	nop
	nop
	cbi PORTC,CLK
	dec Acc0
	brne ss1
	ret






//////////


	reti
//User DATA
//.dseg
ADC_INT:
	push r18
	in r18,SREG
	push r18
	push Acc1
	push Acc0
	push r22
	in r18, ADCH
	rcall Indic
	in Acc0, TIFR
	
	out TIFR,Acc0
	pop r22
	pop Acc0
	pop Acc1
	pop r18
	out SREG, r18
	pop r18

	reti

.org 0x100
CIF:

.DB 0b11000000, 0b11111001, 0b10100100, 0b10110000, 0b10011001, 0b10010010, 0b10000010, 0b11111000, 0b10000000, 0b10010000 
