;added third call
;at the very end of the program, I made the SP point to $18
;to show that I am done

;first call
;load Q = 0x03C3
LDA #$C3
STA $0200
LDA #$03
STA $0201

;load R = 0xFF24
LDA #$24
STA $0202
LDA #$FF
STA $0203

;Put Q's address on the stack
LDA #$02
PHA
LDA #$00
PHA

;Put R's address on the stack
LDA #$02
PHA
LDA #$02
PHA

;Put N on the stack
LDA #$02
PHA

;Return value placeholder
PHA
PHA

;offset for address in zero-page
LDY #$00

JSR SubNWord

;reset stack pointer for next call
LDX #$FF
TXS

;second call
;load Q = E4
LDA #$E4
STA $0204

;load R = F0
LDA #$F0
STA $0205

;put Q's address on the stack
LDA #$02
PHA
LDA #$04
PHA

;put R's address on the stack
LDA #$02
PHA
LDA #$05
PHA

;put N on the stack
LDA #$ 01
PHA

;return value placeholder
PHA
PHA

;offset for zero page
LDY #$00

JSR SubNWord

;reset stack pointer for next call
LDX #$FF
TXS

;call 3
;load Q = 00006301
LDA #$01
STA $0206
LDA #$63
STA $0207
LDA #$00
STA $0208
LDA #$00
STA $0209

;load R = ffffd824
LDA #$24
STA $020A
LDA #$D8
STA $020B
LDA #$FF
STA $020C
LDA #$FF
STA $020D

;put first byte of Q's address on the stack
LDA #$02
PHA
LDA #$06
PHA

;put first byte of R's address on the stack
LDA #$02
PHA
LDA #$0A
PHA

;put N on the stack
LDA #$04
PHA

;Return value placeholder
PHA
PHA

;offset for address in zero-page
LDY #$00

JSR SubNWord

;set stack pointer to weird value show we are done :)
LDX #$18
TXS

JSR end

SubNWord:
;put Q's address in zero page
TSX
LDA $0108, X
STA $00
LDA $0109, X
STA $01

;put R's address in zero page
LDA $0106, X
STA $02
LDA $0107, X
STA $03

loop:

;put Q's current byte on A register
LDA ($00), Y

;set carry bit to 1
SEC

;subtract P's current byte from Q's current byte
SBC ($02), Y

;do I clear the carry here?

;store A (result of subtraction)
STA $3000, Y

;increment Y before comparing
INY

;have we gone through N bytes?
CPY $01FB
;if not, repeat subtraction on next byte
BNE loop

;returning address where subtraction result is stored

;store address on the stack
LDA #$30
STA $0104, X
LDA #$00
STA $0103, X

;retrieve and store address on the stack
LDA $0103, X
STA $4000
LDA $0104, X
STA $4001

RTS

end:
BRK

