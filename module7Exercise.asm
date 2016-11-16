TITLE Module 7 Exercise

INCLUDE Irvine32.inc

.stack		;;;;; is this needed? 
;No, Irvine Library alreay declared stack 4096 by default


;--------------- DISPLAY A MESSSAGE--------------------------
;
;	Print a message to console
;		input:  a string, unsigned integer
;		output: messsage on screen : "string + unsigned data"
;-------------------------------------------------------------
mPrint MACRO buffer, value
	push	eax							; Save register values
	push	edx
	
	call	crlf						; Print message
	mov		edx, OFFSET buffer
	call	writeString

	movzx	eax, value					; Print unsigned value
	call	writeDec

	pop		edx							; Restore register values
	pop		eax
ENDM


.data
	n1	 BYTE 3
	n2	 BYTE 4
	prod WORD ?

	productStr	BYTE	"product is ", 0
	n2Str		BYTE	"n2 is ", 0

.code
main PROC

;;;;; part 1   parameter passing through registers
	mov		al, 5
	mov		bl, 3
	call	mul1

;;;;; part 2   parameter passing through the stack: pass by value
	sub		esp, 4					; Save stack space for result
	movzx	eax, n1					; Pass value of N1 to stack frame
	push	eax
	movzx	eax, n2					; Pass value of N2 to stack frame
	push	eax						
	call	mul2					; call Procedures mul2

	movzx	ebx, BYTE PTR [esp]
	mPrint	productStr, bl

;;;;; part 3   parameter passing through the stack: pass by address or by reference

	; result from mul2 is pointed by ESP now. No need to save space for result
	push	OFFSET n1
	push	OFFSET n2
	call	calc

	movzx	ebx, BYTE PTR [esp]
	mPrint	productStr, bl
	mPrint	n2Str, n2

exit
main ENDP


;-----------PROCEDURE FOR PART 1 --------------------
mul1 PROC
;	Multiply data from two registers
;
;	Input:  al and bl registers
;	Output: display product on screen and 
;			result stored in ax
;-----------------------------------------------------
	mul		bl
	mov		edx, OFFSET productStr
	call	WriteString

	; clear out first 16-bit of eax 
	and		eax, 0000ffffh
	call	WriteInt

	ret

mul1 ENDP


;-----------PROCEDURE FOR PART 2 --------------------
mul2 PROC	
;	 mul2 multiplies 2 bytes
;		input: n1, n2
;		output: on stack
;-----------------------------------------------------
	push	ebp
	mov		ebp, esp						; save ret address
	push	eax								; save registers' values for restoring
	push	ebx

																					; Before calculation: STACK FRAME in Memory
																					;---------------------
																					; space for result   		-----[ebp + 16]
																					; n1 : 3					-----[ebp + 12]
																					; n2 : 4					-----[ebp + 8]
																					; RET address				-----[ebp + 4]
																					; ebp						-----[ebp]
																					; value of eax				-----[ebp - 4]
																					; value of ebx				-----[ebp - 8] <------- ESP points here
											
	mov eax, [ebp + 12]						; copy N1 by de-referecing address [ebp+12] to EAX
	mov ebx, [ebp + 8]						; copy N2 to EBX
	mul ebx									; multiply EBX*EAX
	mov	[ebp + 16], eax						; saved result to 

											; clear stackframe using stdcall
	pop	ebx									; 1. Restore all register's values
	pop eax
											; 2. Pop off all local variables from stack, if neccessary. [esp + SIZEOF(Variables)]
	pop ebp
	ret 8									; 3. call RET num to clear input parameters
											
																					; After calculation: STACK FRAME in Memory
																					;---------------------
																					; result(12)				-----   <------- ESP points here
																					; n1 : 3					-----  cleared
																					; n2 : 4					-----  cleared
																					; RET address				-----  cleared
mul2 ENDP


;; EXTRA CREDIT DONE ;;
;-----------PROCEDURE FOR PART 3 --------------------
calc PROC
;	calc runs:
;      prod = prod * n1 + n2  
;			n2 = n2 - 1
;	input: n1, n2, prod
;	output: none
;----------------------------------------------------
	push	ebp
	mov		ebp, esp
	sub		esp, 4							; local variable
	push	eax
	push	ebx
	push	edx
																					; Before calculation: STACK FRAME in Memory
																					;---------------------
																					; PROD from mul2(12)		-----[ebp + 16]
																					; address of n1				-----[ebp + 12]
																					; address of n2 			-----[ebp + 8]
																					; RET address				-----[ebp + 4]
																					; ebp						-----[ebp]
																					; local variable			-----[ebp - 4]
																					; value of eax				-----[ebp - 8]
																					; value of ebx				-----[ebp - 12]
																					; value of edx				-----[ebp - 16]  <------- ESP points here

	sub		esp, 4							; save space for result of calculation
	mov		eax, [ebp + 16]					; Pass value of PROD to stack frame
	push	eax

	mov		eax, [ebp + 12]					; Pass value of N1 to stack frame
	movzx	eax, BYTE PTR[eax]
	push	eax				
	
	call	mul2							; call Procedures mul2 ( MULTIPLY PROD*N1) = 12*3
	mov		eax, [esp]						; save the result to eax
	mov		[ebp - 4], eax					; copy value of esp to ebp

																					; After calculation mul2: STACK FRAME in Memory
																					;---------------------
																					; PROD from mul2(12)		-----[ebp + 16]
																					; address of n1				-----[ebp + 12]
																					; address of n2 			-----[ebp + 8]
																					; RET address				-----[ebp + 4]
																					; ebp						-----[ebp]
																					; PROD value[local]			-----[ebp - 4]
																					; value of eax				-----[ebp - 8]
																					; value of ebx				-----[ebp - 12]
																					; value of edx				-----[ebp - 16] 
																					; space for result of mul2	-----[ebp - 20] <------- ESP points here

	add		esp, 4							; Since I sub esp 4 at line 163,
											;	 I have to add 4 to get correct ESP address for further calculation
											; Add N2 to PROD
	mov		edx, [ebp + 8]
	movzx	ebx, BYTE PTR [edx]				; save the value of N1 to ebx
	add		eax, ebx
	mov		[ebp + 16], eax					; Save the prod
	sub		BYTE PTR [edx], 1				; Subtract N2 by 1 

											; clear STD process										
	pop		edx								; 1. Restore register values
	pop		ebx
	pop		eax									
	add		esp, 4							; 2. clear local var by adding 1 BYTE to ESP (since there is only 1 local var)
	pop		ebp								; 3. clear EBP
	ret		8
																					; After calculation calc: STACK FRAME in Memory
																					;---------------------
																					; PROD from mul2(40)		-----[ebp + 16]	<-------------- ESP should point here
																					; address of n1				-----[ebp + 12]	------cleared
																					; address of n2 			-----[ebp + 8]	------cleared
																					; RET address				-----[ebp + 4]	------cleared
																					; ebp						-----[ebp]		------cleared

calc ENDP


END main



; a. write the mul1 procedure that accepts 2 input through registers
;    and returns the product through a register
; b. call the mul1 procedure, passing in the values in al and bl
; c. print the product and text explanation (use the productStr above for the text)




;;;;; part 2   parameter passing through the stack: pass by value

; a. write the mul2 procedure that accepts 2 input through the stack
;    and returns the product through the stack
; b. call mul2 to do:  prod = n1 * n2
; c. define a macro that accepts a string and an unsigned value
; d. invoke the macro with the productStr (defined above) to print on a separate line: product is ---




;;;;; part 3   parameter passing through the stack: pass by address or by reference
; a. write the calc procedure to do the following 2 tasks 
;      prod = prod * n1 + n2  
;      n2 = n2 - 1
;   both prod and n2 will be updated
;   calculation should call mul2 to do the multiplication
; b. call calc 
; c. invoke the same macro twice and use the strings defined above to print:
;       product is ---
;       n2 is ---
