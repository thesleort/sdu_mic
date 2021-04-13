.include    "m32adef.inc" ; The ATMEGA32A Microcontroller

.SET dis_state  = 0b11110000

.DEF iloopL = R24
.DEF iloopH = R25
.equ iVal 	= 2500       ; instructions per millisecond

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

START:      IN    R16,PINC  
            COM   R16
            LDI   R16,dis_state
            LDI   R17,0b11111111
            LDI   R20,50
            MOV   R21,R20
LOOP:       OUT   PORTB,R16
            EOR   R16,R17
            RCALL WAITER
            RCALL BTN_ADD
            RCALL BTN_SUB
            RJMP  LOOP

WAITER:
            MOV   R20,R21
DELAY10MS:
            LDI   iloopL,LOW(iVal)
            LDI   iloopH,HIGH(iVal)
INNERLOOP:  SBIW  iloopL,1
            BRNE  INNERLOOP
            DEC   R20
            BRNE  DELAY10MS
            NOP
            RET

BTN_ADD:    LDI  R22,5
            IN    R18,PD2
            SBIS  PIND,2
            ; LDI   R19,0x00
            ; CPI   R19,0xff
            ; BREQ  BTN_ADD_RET
            ADD  R21,R22
BTN_ADD_RET:RET

BTN_SUB:    IN    R18,PD6
            SBIS  PIND,6
            ; LDI   R19,0x00
            ; CPI   R19,0xff
            ; BREQ  BTN_SUB_RET 
            SUBI  R21,5
BTN_SUB_RET:RET

END:        NOP