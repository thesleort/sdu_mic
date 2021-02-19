; ***********************************
; My very first AVR Assembler Program
; ***********************************
.include    "m32adef.inc" ; The ATMEGA32A Microcontroller

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

Loop:       in      R16,PINC            ; Read from PORTC
            out     PORTB,R16           ; Write to PORTB
            rjmp    Loop                ; Jump to Loop label