; ***********************************
; 4 bit adder
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
.SET  dis_on    = 0b00000000
.SET  dis_minus = 0b11011111
.SET  dis_minus_dot = 0b01011111

.SET  dis_dot   = 0b01111111
.SET  dis_dot_neg = 0b10000000

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
            ANDI  R16,rightbits         ; Set trailing bits to 0, 0bxxxx0000
            ANDI  R17,leftbits          ; Set leading bits to 0, 0b0000xxxx
            LDI   R18,0x4               ; Bit-shift right 4 bits
SHIFTLOOP:  DEC   R18
            LSR   R17
            CPI   R18,0x0
            BRNE  SHIFTLOOP
CHECKADD:   IN    R19,PD2
            SBIS  PIND,2
            RJMP  BTN_ADD
CHECKSUB:   IN    R19,PD6
            SBIS  PIND,6
            RJMP  BTN_SUB
CHECKOP:    CPI   R20,0x00
            BREQ  ADDR
            BRNE  SUBR
          
ADDR:       ADD   R16,R17               ; "Add last four bits with first four bits"
            RJMP  CHECKSUM

SUBR:       SUB   R17,R16
            MOV   R16,R17

CHECKSUM:   CPI   R16,0x1               ; Check if sum is 1
            BREQ  SEG_1
            CPI   R16,0x2               ; Check if sum is 2
            BREQ  SEG_2
            CPI   R16,0x3               ; Check if sum is 3
            BREQ  SEG_3
            CPI   R16,0x4               ; Check if sum is 4
            BREQ  SEG_4
            CPI   R16,0x5               ; Check if sum is 5
            BREQ  SEG_5
            CPI   R16,0x6               ; Check if sum is 6
            BREQ  SEG_6
            CPI   R16,0x7               ; Check if sum is 7
            BREQ  SEG_7
            CPI   R16,0x8               ; Check if sum is 8
            BREQ  SEG_8
            CPI   R16,0x9               ; Check if sum is 9
            BREQ  SEG_9
            CPI   R16,0x0
            BREQ  SEG_0
            BRBS  2,SEG_MINUS
            CPI   R16,0xa               ; Check if sum is greater than 9
            BRGE  SEG_E
  
; Display 0 on segment display
SEG_0:      LDI   R18,dis_0
            CALL  DOTROUTINE
            OUT   PORTB,R18
            RJMP  START

; Display 1 on segment display
SEG_1:      LDI   R18,dis_1
            CALL  DOTROUTINE
            OUT   PORTB,R18
            RJMP  START

; Display 2 on segment display
SEG_2:      LDI   R18,dis_2
            CALL  DOTROUTINE
            OUT   PORTB,R18
            RJMP  START

; Display 3 on segment display
SEG_3:      LDI   R18,dis_3
            CALL  DOTROUTINE
            OUT   PORTB,R18
            RJMP  START

; Display 4 on segment display
SEG_4:      LDI   R18,dis_4
            CALL  DOTROUTINE
            OUT   PORTB,R18
            RJMP  START

; Display 5 on segment display
SEG_5:      LDI   R18,dis_5
            CALL  DOTROUTINE
            OUT   PORTB,R18
            RJMP  START

; Display 6 on segment display
SEG_6:      LDI   R18,dis_6
            CALL  DOTROUTINE
            OUT   PORTB,R18
            RJMP  START

; Display 7 on segment display
SEG_7:      LDI   R18,dis_7
            CALL  DOTROUTINE
            OUT   PORTB,R18
            RJMP  START
          
; Display 8 on segment display
SEG_8:      LDI   R18,dis_8
            CALL  DOTROUTINE
            OUT   PORTB,R18
            RJMP  START

; Display 9 on segment display
SEG_9:      LDI   R18,dis_9
            CALL  DOTROUTINE
            OUT   PORTB,R18
            RJMP  START

; Display error on segment display
SEG_E:      LDI   R18,dis_error
            CALL  DOTROUTINE
            OUT   PORTB,R18
            RJMP  START

SEG_MINUS:  LDI   R18,dis_minus_dot
            OUT   PORTB,R18
            RJMP  START

; bitwise display on segment display
SEG_DBG:    OUT   PORTB,R16  
            RJMP  START
            
BTN_ADD:    LDI   R20,0x00
            RJMP  CHECKOP

BTN_SUB:    LDI   R20,0xFF
            RJMP  CHECKOP

DOTROUTINE: PUSH  R20
            PUSH  R21

            MOV   R21,R20
            ANDI  R20,dis_dot_neg
            COM   R18
            OR    R18,R20
            COM   R18
            MOV   R20,R21

            POP   R20
            POP   R21
            RET   