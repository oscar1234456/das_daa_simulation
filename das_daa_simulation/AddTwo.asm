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

	mov al, 35h
	add al, 48h
    call myDAA
	call DumpRegs

	INVOKE ExitProcess,0
main ENDP


myDAS PROC
	mov bl, al
	lahf ;將EFlag暫存器低8bit送進AH(SF,ZF,Res.,AF,Res.,PF,Res.,CF)
	mov cl, ah
	and bl, 00001111b	;藉由bl捕捉al的低4bit
	and cl, 00010000b	;藉由cl得知AuxCarry的狀況
	shr cl,4 ;把上一步之bit推至第一位

	.IF bl > 9  ||  cl == 1	;依照講義logic進行實作(al(lo)>0或AuxCarry == 1)
		sub al, 6
		pushf
		or ah,00010000b;調整AuxCarry = 1
		popf
		sahf ;將AH的8bit送至Eflag
	.ELSE
		pushf
		or ah,00000000b; 調整AuxCarry = 0
		popf
		sahf ;將AH的8bit送至Eflag
	.ENDIF

	lahf ; 再一次將EFlag暫存器低8bit送進AH(因為line29 sub會再一次影響)
	mov cl, ah
	and cl, 00000001b

	.IF al > 9Fh || cl == 1 ; 依照講義logic進行實作(al > 0或Carry == 1)
		sub al, 60h
		pushf
		or ah, 00000001b ; 調整Carry = 1
		popf
		sahf ; 將AH的8bit送至Eflag
	.ELSE
		pushf
		or ah, 00000000b ; 調整Carry = 0
		popf
		sahf ; 將AH的8bit送至Eflag
	.ENDIF

ret
myDAS ENDP

myDAA PROC
	mov bl, al
	lahf ;將EFlag暫存器低8bit送進AH(SF,ZF,Res.,AF,Res.,PF,Res.,CF)
	mov cl, ah
	and bl, 00001111b	;藉由bl捕捉al的低4bit
	and cl, 00010000b	;藉由cl得知AuxCarry的狀況
	shr cl,4 ;把上一步之bit推至第一位

	.IF bl > 9  ||  cl == 1	;依照講義logic進行實作(al(lo)>0或AuxCarry == 1)
		add al, 6
		pushf
		or ah,00010000b;調整AuxCarry = 1
		popf
		sahf ;將AH的8bit送至Eflag
	.ELSE
		pushf
		or ah,00000000b; 調整AuxCarry = 0
		popf
		sahf ;將AH的8bit送至Eflag
	.ENDIF

	lahf ; 再一次將EFlag暫存器低8bit送進AH(因為line29 sub會再一次影響)
	mov cl, ah
	and cl, 00000001b

	mov bl, al
	and bl, 11110000b ;擷取高4位元
	shr bl,4 ;移到後4位元

	.IF bl > 9 || cl == 1 ; 依照講義logic進行實作(al > 0或Carry == 1)
		add al, 60h
		pushf
		or ah, 00000001b ; 調整Carry = 1
		popf
		sahf ; 將AH的8bit送至Eflag
	.ELSE
		pushf
		or ah, 00000000b ; 調整Carry = 0
		popf
		sahf ; 將AH的8bit送至Eflag
	.ENDIF

ret
myDAA ENDP

END main



