TITLE  Assignment 6: Bit-wise instructions
		
; Name: Dat Nguyen	
; Date: 3:54 PM 11/9/2016

INCLUDE Irvine32.inc


.data
eaxStr BYTE "EAX is 0", 0ah, 0dh, 0
divisibleStr BYTE "EBX is divisible by 4", 0ah, 0dh, 0
notdiv		 BYTE "EBX is not divisible by 4", 0ah, 0dh, 0
oneStr BYTE "Number of 1's: ", 0
zeroStr BYTE "Number of 0's: ", 0
var1 QWORD 0ffffffffffffffeh
arr WORD 1, -2, -3, 4

.code
main PROC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Question 1. (4pts) Add code after the  mov  instruction below to use 3 different ways
;;; to check if EAX is 0 and jump to label Zero if it is.

mov eax, -5     ; sample value for eax. You should test with other values.
;;; FIRST way: don't use CMP and don't modify eax, check for eax == 0 and jump to Zero label, 
;;; otherwise continue with second way

	or eax, eax
	jz Zero

;;; SECOND way: don't use CMP, don't modify eax, and don't use the same instructions as above,
;;; check for eax == 0 and jump to Zero label, otherwise continue with the third way

	test eax, 0ffffffffh
	jz   Zero

;;; THIRD way: don't use CMP, don't modify eax, and don't use the same instructions as above,
;;; check for eax == 0 and jump to Zero label, otherwise continue with question 2
;Alternative solution:
	;test eax, eax
	; jz	Zero
	; jmp Question2


	mov ebx, eax
	and eax, 0ffffffffh
	jz Zero
	jmp Question2


Zero:
	mov		edx, OFFSET eaxStr
	call	writeString			; print eax is 0
	call	crlf


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Question 2. (3pts) Add 2 lines of code after the mov instruction below to check if ebx is divisible by 4. 
;;; Don't use DIV or IDIV in your answer, instead use ONE bit-wise instruction to check,
;;; and ONE branching instruction to print / not print that ebx is divisible by 4.

Question2:
	mov		ebx, 9
	test	ebx, 000000003h				;test bit 0 or bit 1 is set (... 0011)
	jz		isDivBy4					; jump if either bit 0 or bit 1 is set to 1

NotDivBy4:
	mov		edx, OFFSET notdiv
	call	WriteString
	jmp		Done

IsDivBy4:
	mov		edx, OFFSET divisibleStr
	call	writeString	
Done:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Question 3. (5pts) Write code to count how many 1's and how many 0's there are in var1.
;;; Then use the oneStr and zeroStr text strings (already defined above) to print the result.
;;; var1 should remain the SAME value after you've counted the bits.

	mov ax, TYPE var1		; Get TYPE of var1 (QWORD)
	mov bx, SIZEOF var1		; Get SIZE of var1
	mul bx					; calculate bitlength

; COPY result back to AX
	shl		eax, 16			
	shrd	eax, edx, 16	
	movzx	ecx, ax				; copy bit length into ecx as counter for the following loop
	mov		bx , 0				; counter for 1
	mov		edx , 0				; counter for 0
	mov		eax, DWORD PTR var1
BITCOUNT:
	rol		eax, 1
	jc		foundOne
	foundZero:
		inc	dx
		jmp continue
	foundOne:
		inc bx
	continue:
		loop BITCOUNT

mov		ecx, edx		; copy result of 0's bits to ecx

; Display result the numer of 1's bit
mov		edx, OFFSET oneStr
call	writeString
movzx	eax, bx
call	writeDec

call crlf
; Display result the numer of 0's bit
mov		edx, OFFSET zeroStr
call	writeString
mov		eax, ecx
call	writeDec

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Question 4. (3pts) Given an array  arr  as defined in .data, and ebx is initialized below.
;;; Using ebx (not the array name), add ONE instruction to reverse the MSB of the last 2 elements of arr.  
;;; Reverse means 0 to 1 or 1 to 0.  Your code should work with any value in the last 2 elements,
;;; not just the sample values above.

	mov ebx, OFFSET arr
	XOR WORD PTR [ebx +4], 8000h
	XOR WORD PTR [ebx +6], 8000h

exit	
main ENDP

END main

COMMENT !
Sample output for the given data values above:
	EBX is divisible by 4
	Number of 0's: 5
	Number of 1's: 59

You should definitely test with other data values.
I will not test your program with the given values.
!