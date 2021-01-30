;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Date: Nov 7, 2020
; Author: Alex Simakov
;
; A simple, and likely highly-inefficient,
; pixel plotter which fills in the screen
; with all available colors as a rainbow
; venetian blind pattern.
;
; Tested with TASM 4.1 in DosBox 0.74-3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.model small
.stack 100h
.data
	X 	dw 	?
	Y 	dw 	?
	COLOR	db  	?

.code

MAXX EQU 320
MAXY EQU 200

main:
	mov ax, 13h
	int 10h           	;switch to VGA 320x200

	mov X, 0		;initialize X
	mov Y, 0		;initialize Y
	mov COLOR, 0		;initialize COLOR

	jmp plotpixel		;begin plotting

nextline:
	mov X, 0		;reset X
	inc COLOR		;next color
	inc Y               	;next Y-coordinate / line
	cmp Y, MAXY		;check Y screen overflow
	jne plotpixel
	jmp keypress        	;done drawing, listen for keystroke

plotpixel:
	mov ax, Y		;store Y in ax
	mov bx, X 		;store X in bx
	mov cx, MAXX        	;store 320 in cx
				;calculate video memory offset as Y*320 + X
	mul cx              	;multiply cx by ax and store in ax
	add ax, bx     		;add ax to cx and store in ax
	mov di, ax              ;move calculated offset to di
	mov bx, 0A000h		;set video segment
	mov es, bx 		;use X as start address
	mov dl, COLOR
	mov es:[di], dl         ;write offset/color

	inc X               	;move down X axis
	cmp X, MAXX         	;check X screen overflow
	jne plotpixel       	;continue down the X axis
	jmp nextline            ;end of line? start a new line

keypress:
	mov ah, 0Bh
	int 21h               	;read key buffer
	cmp al, 0               ;continue loop if zero
	je keypress

exit:
	mov ah, 00h
	mov al, 03h
	int 10h            	;switch to text mode

	mov ah, 4Ch
	int 21h               	;exit to DOS

end main
