; a translation for z80 CP/M from the 8080 version given here:
; https://rosettacode.org/wiki/Execute_HQ9%2B#8080_Assembly
;
; manual translation by Shiela Dixon


putch:	equ	2	; Write character
puts:	equ	9	; Write string
fopen:	equ	15	; Open file
fread:	equ	20	; Read record
setdma:	equ	26	; Set DMA address
fcb:	equ	5Ch	; FCB for first file on command line
	org	100h
	;;;	Open source file given on command line
	ld	de,fcb
	ld	c,fopen
	call	5	; Open file
	inc	a	; A=FF = error
	ld	de,efile
	jp z,s_out	; If error, print error message and stop
	ld	de,src	; Start reading file at src
	;;;	Load the entire source file into memory	
block:	push	de	; Set DMA address to next free location
	ld	c,setdma
	call	5
	ld	de,fcb	; Read 128-byte record
	ld	c,fread
	call	5
	pop	de	; Advance pointer by 128 bytes
	ld	hl,128
	add hl, de 	; in the 8080 version, this is the dad	d instruction ; DAD D means DE + HL --> HL. 
	ex de,hl	; 
	dec	a	; A=1 = end of file
	jp z,block	; If not EOF, read next block
	ex de,hl
	ld (hl),26	; Terminate last block with EOF byte to be sure
	ld	bc,src	; BC = source pointer
ins:	ld a,(bc)	; Get current instruction
	cp	26	; If EOF, stop
	ret z
	or	32	; Make lowercase
	push	bc	; Keep source pointer
	cp	'h'	; H=hello
	call z,hello
	cp	'q'	; Q=quine
	call z,quine
	cp	'9'	; 9=bottles
	call z,botls
	cp	'+'	; +=increment
	call z,incr
	pop	bc	; Restore source pointer
	inc	bc	; Next instruction
	jp ins
	;;;	Increment accumulator
incr:	ld	hl,accum
	inc (hl)
	ret
	;;;	Print "Hello, World"
hello:	ld	de,histr
	jp	s_out
	;;;	Print the source
quine:	ld	hl,src	; Pointer to source
qloop:	ld a,(hl)	; Load byte
	cp	26	; Reached the end?
	ret z		; If so, stop
	push	hl	; Otherwise, keep pointer
	ld e,a
	ld	c,putch	; Print character
	call	5
	pop	hl	; Restore pointer
	inc hl	; Next byte
	jp	qloop
	;;;	99 bottles of beer
botls:	ld	e,99	; 99 bottles
bverse:	call	nbeer	; _ bottle(s) of beer
	ld	hl,otw	; on the wall
	call	bstr
	call	nbeer	; _ bottle(s) of beer
	ld	hl,nl	; \r\n
	call	bstr
	ld	hl,tod	; Take one down and pass it around
	call	bstr
	dec	e	; Decrement counter
	push	af	; Keep status
	call 	nbeer	; _ bottle(s) of beer
	ld	hl,otw
	call	bstr	; on the wall
	ld	hl,nl	; \r\n
	call	bstr
	pop	af	; restore status
	jp nz,bverse	; If not at 0, next verse
	ret
nbeer:	push	de	; keep counter
	call	btlstr	; _ bottle(s)
	ld	de,ofbeer
	call	s_out	; of beer
	pop 	de
	ret
bstr:	push	de	; keep counter
	ex de,hl		; print string in HL
	call	s_out
	pop	de	; restore counter
	ret
	;;;	Print "N bottle(s)"
btlstr:	push	de	; Keep counter
	ld	a,e	; Print number
	call 	num
	ld	de,bottle
	call	s_out	; Print " bottle"
	pop 	de	; Restore counter
	dec	e	; If counter is 1,
	ret z		; then stop,
	ld	e,'s'	; otherwise, print S
	ld	c,putch
	jp	5
	;;;	Print number (0-99) in A
num:	and	a	; If 0, print "no more"
	ld	de,nomore
	jp z,s_out
	ld	b,'0'-1	; Tens digit
nloop:	inc	b	; Increment tens digit
	sub	10	; Subtract 10
	jp nc,nloop
	add a,'0'+10	; Ones digit
	ld	de,snum-1
	ld (de),a	; Store ones digit
	ld	a,b	; Tens digit zero?
	cp	'0'
	jp z,s_out	; If so, only print ones digit
	dec	de	; Otherwise, store tens digit
	ld (de),a
s_out:	ld	c,puts	; Print result
	jp	5



efile:	db	'File error.$'
histr:	db	'Hello, world!',13,10,'$'
	db	'..'
snum:	db	'$'
nomore:	db	'No more$'
bottle:	db	' bottle$'
ofbeer:	db	' of beer$'
otw:	db	' on the wall',13,10,'$'
tod:	db	'Take one down and pass it around'
nl:	db	13,10,'$'
accum:	db	0 	; Accumulator
src:	equ	$	; Program source

