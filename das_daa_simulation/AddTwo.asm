; ---------------------------------------------------------------- 
; �@��: ������ 110616038
; �{���ާ@����:
;	��������Y�i�A�w�ƥ��g�J�ҥ����q�d�ҲĤ@�D(��48��35���[�k�P��k)
;	�|�bConsole������ܰ���k�BDas�᪺�Ȧs���P�X�Ъ��p�A�ĤG�����A��ܰ��[�k�BDaa�᪺�Ȧs���P�X�Ъ��p�C
;   �ۻsDas�W��:myDAS
;   �ۻsDaa�W��:myDAA
; �ŦX�������з�:
;   1.  �{�����N�q�B�i�H��Ķ����(+20 % )
;   2.  ����DAS���O�@�˥\�઺procedure(+70 % )
;   3.  ����DAA���O�@�˥\�઺procedure(+20 % )
; �۵�����:
; 90��(�H�D�t��A�E��L�L!)
; ------------------------------------------------------------------
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

	INVOKE ExitProcess, 0
main ENDP

; ----------------------------------------------------------------
; myDAS:��s�u����Das(Decimal adjust after subtraction)
; ��NPacked BCD��k�̫�HPacked BCD��ܡA�ç��CF�BAF�X��
; ------------------------------------------------------------------
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

; ----------------------------------------------------------------
; myDAA:��s�u����Daa(Decimal adjust after addition)
; ��NPacked BCD�[�k�̫�HPacked BCD��ܡA�ç��CF�BAF�X��
; ------------------------------------------------------------------
myDAA PROC
	mov bl, al
	lahf ;�NEFlag�Ȧs���C8bit�e�iAH(SF,ZF,Res.,AF,Res.,PF,Res.,CF)
	mov cl, ah
	and bl, 00001111b	;�ǥ�bl����al���C4bit
	and cl, 00010000b	;�ǥ�cl�o��AuxCarry�����p
	shr cl,4 ;��W�@�B��bit���ܲĤ@��

	.IF bl > 9  ||  cl == 1	;�̷����qlogic�i���@(al(lo)>0��AuxCarry == 1)
		add al, 6
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

	mov bl, al
	and bl, 11110000b ;�^����4�줸
	shr bl,4 ;�����4�줸

	.IF bl > 9 || cl == 1 ; �̷����qlogic�i���@(al > 0��Carry == 1)
		add al, 60h
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
myDAA ENDP

END main



