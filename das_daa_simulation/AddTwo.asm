.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data
	;Define your variables here
.code

main PROC
	;Write your assembly code here
	INVOKE ExitProcess,0
main ENDP
END main