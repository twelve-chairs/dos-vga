;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Date: Nov 7, 2020
; Author: Alex Simakov
;
; A simple, and likely
; highly-inefficient,
; pixel plotter
; which fills in the
; screen with all available
; colors as a rainbow
; venetian blind pattern.
;
; Tested with TASM 4.1
; in DosBox 0.74-3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.model small
.stack 100h
.data
.code

MAXX EQU 640
MAXY EQU 400

main:
	mov ax,4F02h
	mov bx,100h     ;www.wagemakers.be/english/doc/vga
	int 10h         ;switch to SVGA

	mov cx, 0 		;initialize x
	mov dx, 0 		;initialize y
	mov al, 0 		;initiialize color
	jmp plotpixel	;begin plotting

resetcolor:
	mov al, 0

nextline:
	inc al			;next color
	mov cx, 0		;reset X
	inc dx          ;next line
	cmp dx, MAXY	;check Y screen overflow
	jne plotpixel
	jmp keypress    ;done drawing, listen for keystroke

plotpixel:
	mov ah, 0Ch
	int 10h         ;plot to screen

	inc cx          ;move down X axis
	cmp cx, MAXX    ;check X screen overflow
	jne plotpixel   ;continue down the X axis
	jmp nextline    ;end of line? make a new line

keypress:
	mov ah, 0Bh
	int 21h         ;read key buffer
	cmp al, 0       ;continue if zero
	je keypress

exit:
	mov ah, 00h
	mov al, 03h
	int 10h         ;switch to text mode

	mov ah, 4Ch
	int 21h         ;exit to DOS

end main