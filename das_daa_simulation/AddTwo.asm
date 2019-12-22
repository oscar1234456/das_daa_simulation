; ---------------------------------------------------------------- 
; 作者: 陳泰元 110616038
; 程式操作說明:
;	直接執行即可，已事先寫入課本講義範例第一題(對48及35做加法與減法)
;	會在Console中先顯示做減法、Das後的暫存器與旗標狀況，第二部分再顯示做加法、Daa後的暫存器與旗標狀況。
;   自製Das名稱:myDAS
;   自製Daa名稱:myDAA
; 符合之評分標準:
;   1.  程式有意義且可以組譯執行(+20 % )
;   2.  完成DAS指令一樣功能的procedure(+70 % )
;   3.  完成DAA指令一樣功能的procedure(+20 % )
; 自評分數:
; 90分(人非聖賢，孰能無過!)
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
; myDAS:仿製真正的Das(Decimal adjust after subtraction)
; 能將Packed BCD減法最後以Packed BCD表示，並改動CF、AF旗標
; ------------------------------------------------------------------
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

; ----------------------------------------------------------------
; myDAA:仿製真正的Daa(Decimal adjust after addition)
; 能將Packed BCD加法最後以Packed BCD表示，並改動CF、AF旗標
; ------------------------------------------------------------------
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



