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
.SET  dis_9     = 0b10000001
.SET  dis_error = 0b10001100
.SET  dis_off   = 0b11111111

.SET  leftbits  = 0b11110000
.SET  rightbits = 0b00001111

.org        0x0000       ; Program execution is started at address: 0
            RJMP    Reset 

.org        0x002A
Reset:      LDI     R16,HIGH(RAMEND)    ; Stack setup
            OUT     SPH,R16             ; Load SPH
            LDI     R16,LOW(RAMEND)     ;
            OUT     SPL,R16             ; Load SPL
            
            ; PORTC Setup
            LDI     R16, 0x00
            OUT     DDRC, R16           ; Set PORTC as input
            LDI     R16, 0xFF           ;
            OUT     PORTC,R16           ; Enable pull-up on PORTC
            ; PORTB Setup
            OUT     DDRB,R16            ; PORTB = output
            OUT     PORTB,R16           ; Turn LEDS off

START:      IN    R16,PINC
            COM   R16
            MOV   R17,R16
            ANDI  R16,rightbits
            ANDI  R17,leftbits
            LDI   R18,0x4
SHIFTLOOP:  DEC   R18
            LSR   R17
            CPI   R18,0x0
            BRNE  SHIFTLOOP
            ADD   R16,R17

            CPI   R16,0x1
            BREQ  SEG_1
            CPI   R16,0x2
            BREQ  SEG_2
            CPI   R16,0x3
            BREQ  SEG_3
            CPI   R16,0x4
            BREQ  SEG_4
            CPI   R16,0x5
            BREQ  SEG_5
            CPI   R16,0x6
            BREQ  SEG_6
            CPI   R16,0x7
            BREQ  SEG_7
            CPI   R16,0x8
            BREQ  SEG_8
            CPI   R16,0x9
            BREQ  SEG_9
            CPI   R16,0xa
            BRGE  SEG_E
  
SEG_0:      LDI   R18,dis_0
            OUT   PORTB,R18
            RJMP  START

SEG_1:      LDI   R18,dis_1
            OUT   PORTB,R18
            RJMP  START

SEG_2:      LDI   R18,dis_2
            OUT   PORTB,R18
            RJMP  START

SEG_3:      LDI   R18,dis_3
            OUT   PORTB,R18
            RJMP  START

SEG_4:      LDI   R18,dis_4
            OUT   PORTB,R18
            RJMP  START

SEG_5:      LDI   R18,dis_5
            OUT   PORTB,R18
            RJMP  START

SEG_6:      LDI   R18,dis_6
            OUT   PORTB,R18
            RJMP  START

SEG_7:      LDI   R18,dis_7
            OUT   PORTB,R18
            RJMP  START
          
SEG_8:      LDI   R18,dis_8
            OUT   PORTB,R18
            RJMP  START

SEG_9:      LDI   R18,dis_9
            OUT   PORTB,R18
            RJMP  START

SEG_E:      LDI   R18,dis_error
            OUT   PORTB,R18
            RJMP  START

SEG_DBG:    OUT   PORTB,R16  
            RJMP  START
            
