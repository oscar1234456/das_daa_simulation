.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
include Irvine32.inc
.data
; Define your variables here
.code

main PROC
    mov al, 48h
	sub al, 35h
    call myDAS
	call DumpRegs

	INVOKE ExitProcess,0
main ENDP


myDAS PROC
	mov bl, al
	lahf
	mov cl, ah
	and bl, 00001111b
	and cl, 00010000b
	shr cl,4

	.IF bl > 9  ||  cl == 1
		sub al, 6
		pushf
		or ah,00010000b
		popf
		sahf
	.ELSE
		pushf
		or ah,00000000b
		popf
		sahf
	.ENDIF

	lahf
	mov cl, ah
	and cl, 00000001b

	.IF al > 9Fh || cl == 1
		sub al, 60h
		pushf
		or ah, 00000001b
		popf
		sahf
	.ELSE
		pushf
		or ah, 00000000b
		popf
		sahf
	.ENDIF

ret
myDAS ENDP



END main



