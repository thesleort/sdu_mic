; ***********************************
; My very first AVR Assembler Program
; ***********************************
.include    "m32adef.inc" ; The ATMEGA32A Microcontroller

.SET  dis_0     = 0b10100000
.SET  dis_1     = 0b11110011
.SET  dis_2     = 0b10010100
.SET  dis_3     = 0b10010001
.SET  dis_4     = 0b11000011
.SET  dis_5     = 0b10001001
.SET  dis_6     = 0b10001000
.SET  dis_7     = 0b10110011
.SET  dis_8     = 0b10000000
.SET  dis_error = 0b10001100
.SET  dis_off   = 0b11111111

.SET  switch_null = 0b11111111
.SET  switch_0    = 0b11111110
.SET  switch_1    = 0b11111101
.SET  switch_2    = 0b11111011
.SET  switch_3    = 0b11110111
.SET  switch_4    = 0b11101111
.SET  switch_5    = 0b11011111
.SET  switch_6    = 0b10111111
.SET  switch_7    = 0b01111111

.org        0x0000       ; Program execution is started at address: 0
            rjmp    Reset 

.org        0x002A
Reset:      ldi     R16,HIGH(RAMEND)    ; Stack setup
            out     SPH,R16             ; Load SPH
            ldi     R16,LOW(RAMEND)     ;
            out     SPL,R16             ; Load SPL
            
            ; PORTC Setup
            ldi     R16, 0x00
            out     DDRC, R16           ; Set PORTC as input
            ldi     R16, 0xFF           ;
            out     PORTC,R16           ; Enable pull-up on PORTC
            ; PORTB Setup
            out     DDRB,R16            ; PORTB = output
            out     PORTB,R16           ; Turn LEDS off

START:      in    R16,PINC
CMP_OFF:    cpi   R16,switch_null
            breq  SEG_OFF
CMP_0:      cpi   R16,switch_0
            breq  SEG_1
CMP_1:      cpi   R16,switch_1
            breq  SEG_2
CMP_2:      cpi   R16,switch_2
            breq  SEG_3
CMP_3:      cpi   R16,switch_3
            breq  SEG_4
CMP_4:      cpi   R16,switch_4
            breq  SEG_5
CMP_5:      cpi   R16,switch_5
            breq  SEG_6
CMP_6:      cpi   R16,switch_6
            breq  SEG_7
CMP_7:      cpi   R16,switch_7
            breq  SEG_8

            rjmp  SEG_ERROR

SEG_1:      ldi   R16,  dis_1
            out   PORTB,R16
            rjmp  START
SEG_2:      ldi   R16,  dis_2
            out   PORTB,R16
            rjmp  START
SEG_3:      ldi   R16,  dis_3
            out   PORTB,R16
            rjmp  START
SEG_4:      ldi   R16,  dis_4
            out   PORTB,R16
            rjmp  START
SEG_5:      ldi   R16,  dis_5
            out   PORTB,R16
            rjmp  START
SEG_6:      ldi   R16,  dis_6
            out   PORTB,R16
            rjmp  START
SEG_7:      ldi   R16,  dis_7
            out   PORTB,R16
            rjmp  START
SEG_8:      ldi   R16,  dis_8
            out   PORTB,R16
            rjmp  START


SEG_OFF:    ldi   R16,  dis_off
            out   PORTB,R16
            rjmp  START

SEG_ERROR:  ldi   R16,  dis_error
            out   PORTB,R16
            rjmp  START