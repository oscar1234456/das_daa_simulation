.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
include Irvine32.inc
.data
; Define your variables here
.code

main PROC
	mov al, 32h
	sub al, 39h
    call myDAS
	call DumpRegs

	INVOKE ExitProcess,0
main ENDP


myDAS PROC
	mov bl, al
	lahf ;�NEFlag�Ȧs���C8bit�e�iAH(SF,ZF,Res.,AF,Res.,PF,Res.,CF)
	mov cl, ah
	and bl, 00001111b	;�ǥ�bl����al���C4bit
	and cl, 00010000b	;�ǥ�cl�o��AuxCarry�����p
	shr cl,4 ;��W�@�B��bit���ܲĤ@��

	.IF bl > 9  ||  cl == 1	;�̷����qlogic�i���@(al(lo)>0��AuxCarry == 1)
		sub al, 6
		pushf
		or ah,00010000b;�վ�AuxCarry = 1
		popf
		sahf ;�NAH��8bit�e��Eflag
	.ELSE
		pushf
		or ah,00000000b; �վ�AuxCarry = 0
		popf
		sahf ;�NAH��8bit�e��Eflag
	.ENDIF

	lahf ; �A�@���NEFlag�Ȧs���C8bit�e�iAH(�]��line29 sub�|�A�@���v�T)
	mov cl, ah
	and cl, 00000001b

	.IF al > 9Fh || cl == 1 ; �̷����qlogic�i���@(al > 0��Carry == 1)
		sub al, 60h
		pushf
		or ah, 00000001b ; �վ�Carry = 1
		popf
		sahf ; �NAH��8bit�e��Eflag
	.ELSE
		pushf
		or ah, 00000000b ; �վ�Carry = 0
		popf
		sahf ; �NAH��8bit�e��Eflag
	.ENDIF

ret
myDAS ENDP



END main



