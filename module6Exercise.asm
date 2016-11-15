TITLE Module 6 Exercise						

INCLUDE Irvine32.inc

.data
bigData QWORD 123456781234567h
arryW  WORD 0000h,0000h,00c1h,1111h, 0500h
.code
main PROC

;;;;;;;;;;;;  part 1: bit-wise instructions ;;;;;;;;;;;;;
; predict what the code will do by answering
; the questions, then step through the code
; to check your answers
	mov eax, OFFSET arryW
	mov WORD PTR [eax], 1234h
	mov al, 1010b
	and al, 1      ; al: 0000 0000b
	or al, 1       ; al: 0000 0001b
				   ; xor 0000 1111
	xor al, 0fh    ; al  0000 1110b
	not al         ; al: 1111 0001b

	mov al, 1010b  ;  0000 1010
	test al, 1000b ;  0000 1000     
				   ; We are testing the if MSB is set
	jz L1		   ; will it jump? NO
	mov bl, 1			
L1:
	xor al, al		 ; al: 0000 0000

nextTest:
	mov al,1000b	;	  0000 1000b
					; 80: 1000 0000b
	test al, 80h	; what are we testing for?
					; it is testing if MSB is set
	jnz L2			; will it jump? 
					; NO
	not al			; al: 0000 1000b

L2:
	mov al,2		; 
	shl al,1		; al: 4d
	sal al,2		; al: 16d

	shr al,1		; al: 8d


	mov al,0feh		; 1111 1110b
	shr al,1		; 0111 1111b
	mov al,0feh     ; 1111 1110b
	sar al,1		; 1111 1111b


	mov al, 0fh		; 0000 1111b
	ror al,4	; al: 1111 0000b
	rol al,4	; al: 0000 1111b

	mov al, 0f0h; al: 1111 0000b
	stc				; cf = 1 ; al = 1111 0000
	rcr al, 4		; cf = 0 ; al: 0001 1111
	mov al, 0f0h	; 1111 00000
	clc				; cf = 0 ; al = 1111 0000
	rcl al, 4;		; cf = 1 ; al = 0000 0111

	mov ax,1234h	
	mov bx,5678h
	shld ax,bx,4	; ax:2345h bx: 5678h
	shrd bx,ax,4	; ax:2345h bx: 5567h

	;;;;;;;;;;;;;;; part 2: solve these problems ;;;;;;;;;;;;

;Problem 1:
mov ax, 11h
mov bx, 1000h
mul bx				; result:0001  1000 
and eax, 0000ffffh
shl edx, 16
add eax, edx 
call writeDec

;Problem 2:
; multiply bigData by 2, then store the result back in bigData
mov eax, DWORD PTR bigData
shl eax, 1
mov DWORD PTR bigData, eax



;Problem 3 - indirect addressing:
; multiply bigData by 2, then store the result back in bigData,
; but we only have the address of bigData in ebx

mov ebx, OFFSET bigData
mov eax, [ebx]
shl eax, 1
mov [ebx], eax



	exit
main ENDP

END main