TITLE Module 7 Exercise

INCLUDE Irvine32.inc

.data
	num1			WORD	0F123h
	num2			WORD	0E456h

	first_prompt	BYTE	"Enter a first hex number:",0
	second_prompt	BYTE	"Enter a second hex number:",0
	continue		BYTE	"Would you like to continue? (y): ", 0
	sum_prompt		BYTE	"The sum result is: ",0
	result			BYTE	?,?,?,?,0
	invalid_result	BYTE	"Invalid result. [ Overflow detected. Result is greater than signed 16-bit]", 0
	prompt			DWORD    OFFSET first_prompt, OFFSET second_prompt
.code

main PROC

mainLoop:
;GetInput Procedure -------------- Pass by Reference
	push	OFFSET prompt		; address of prompt
	push	OFFSET num1			; address of num1
	push	OFFSET num2			; address of num2
	call	getInput

;Add Procedure ------------------- Pass by Value
	movzx	eax, num1
	push	eax
	movzx	eax, num2
	push	eax
	call	addInput	
				
	test	cl, 1
	jnz		InvalidResult

ValidResult:
	push	eax						; pass the sum result to stack by value
	push	OFFSET result			; pass by reference
									; convert Procedure 
	call	convertHexString	

	mov		edx, OFFSET sum_prompt	; Display the result
	call	writeString
	mov		edx, OFFSET result
	call	writeString

	call	crlf
	jmp		AskContinue

InvalidResult:
	mov		edx, OFFSET invalid_result
	call	writeString
	call	crlf

AskContinue:
	mov		edx, OFFSET continue		
	call	writeString
	call	readChar					
	call	writeChar					; echo user input
	call	crlf
	call	crlf
	mov		dl, 'y'						;if (al == 'y') or (al == 'Y')
	cmp		al, dl
	je		mainLoop
	mov		dl,'Y'
	cmp		al, dl
	je		mainLoop


exit
main ENDP


;------------GET INPUT PROCEDURE --------------------
getInput PROC
;	Get user input and store into data num1 and num2
;		Input: addr(inputstring), addr(num1), addr(num2)
;		Ouput: nothing
;----------------------------------------------------
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	push	edx

	mov		ecx, 0
DISPLAY:
	cmp		ecx, 2
	je		FINISHED

	mov		eax, [ebp+16]					; save address of inputstring to edx 
	lea		eax, [eax + ecx*4]				; dereference [edx]
	mov		edx, [eax]						
	call	writeString						
	call	readHex							; store hex input in AX
											; There is no validation here since input is guranteed to be a hex value within 16 bits

	mov		edx, [ebp+12]					; 
	lea		edx, [edx + ecx*2]				; 
	mov		WORD PTR [edx], ax				; dereference [edx]

	inc		ecx
	jmp		DISPLAY

FINISHED:
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	pop		ebp
	ret		12
getInput ENDP

;----------------------ADD PROCEDURE ----------------------------
addInput PROC
;	add two user input number
;		Input: value num1, value num2
;		Ouput: eax : sum value
;			   cx  : flag for calculation (1 means invalid sumation)
;-------------------------------------------------------------------
	push	ebp
	mov		ebp, esp
	push	ebx
	push	edx

	mov		ax, [ebp+8]
	mov		bx, [ebp+12]
	add		ax, bx
	jno		finished
overFlowDetected:
	mov		cx, 0
	inc		cx				; if ecx = 1 mean overflow is detected""
finished:
	pop		edx
	pop		ebx
	pop		ebp
	ret		8
addInput ENDP


;----------------------CONVERT PROCEDURE -----------------
convertHexString PROC
;	convert a value to string
;		Input: a register
;		Ouput: string
;
;--------------------------------------------------------
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	mov		ecx, 4								; counter for loop			
	mov		bx, 16								; divisor for HEX

convertHEXtoString: 
	mov		dx, 0					
	idiv	bx								; Get remainder to store.
	cmp		dx, 9							; Compare if output = a number or a letter (A..F)
	ja		extractLetter					; IF-ELSE control flows

  extractNumber:
	add		dl, 48d
	jmp		AddtoString

  extractLetter:							; a sub-routine of Convert Hex to String
	add		dl, 55d						; add 48 to convert dec to letter in ANSCII table
			 
  AddtoString:							; a sub-routine of Convert to Hex to String
	mov		esi, [ebp + 8]
	mov		BYTE PTR[esi + ecx - 1], dl		; save a char (0..9 or A..F) into output array

	loop convertHEXtoSTRING

finished:
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	pop		ebp
	ret		8
convertHexString ENDP


END main


COMMENT !
===========CONSOLE OUTPUT====================

Enter a first hex number:0000
Enter a second hex number:0000
The sum result is: 0000
Would you like to continue? (y): y

Enter a first hex number:7AAAA
Enter a second hex number:FFFF
The sum result is: AAA9
Would you like to continue? (y): y

Enter a first hex number:FFFF
Enter a second hex number:FFFF
The sum result is: FFFE
Would you like to continue? (y): y

Enter a first hex number:FFFF
Enter a second hex number:1
The sum result is: 0000
Would you like to continue? (y): n

!























; STACK FRAME of GetInput
;---------------------
; address of inputstring	-----[ebp + 16]
; address of n1				-----[ebp + 12]
; address of n2 			-----[ebp + 8]
; RET address				-----[ebp + 4]
; ebp						-----[ebp]
; value of eax				-----[ebp - 4]
; value of ebx				-----[ebp - 8]
; value of ecx				-----[ebp - 12]
; value of edx				-----[ebp - 16]  <------- ESP points here

; STACK FRAME of addInput
;---------------------
; value of n1				-----[ebp + 12]
; value of n2 				-----[ebp + 8]
; RET address				-----[ebp + 4]
; ebp						-----[ebp]
; value of eax				-----[ebp - 4]
; value of ebx				-----[ebp - 8]
; value of ecx				-----[ebp - 12]
; value of edx				-----[ebp - 16]  <------- ESP points here


; STACK FRAME of ConverHEXString
;---------------------
; address of output			-----[ebp + 12]
; value of Sum				-----[ebp + 8]
; RET address				-----[ebp + 4]
; ebp						-----[ebp]
; value of eax				-----[ebp - 4]
; value of ebx				-----[ebp - 8]
; value of ecx				-----[ebp - 12]
; value of edx				-----[ebp - 16]  <------- ESP points here

COMMENT !
1.	Define 2 WORD size variables called num1 and num2 in the .data section. These are the 2 signed hexadecimal numbers. 
2.	Write the getInput procedure.  This procedure:
	a.	Prompts the user and reads in 2 hexadecimal values, and stores them in num1 and num2.
	b.	Works with 3 parameters on the stack:  address of the input prompt string address, address of num1, address of num2.
	c.	You don't have to check for invalid input values. The input is guaranteed to be a hex value within 16 bits.

3.	Write the add procedure. This procedure:
	a.	Adds the 2 values and check whether the sum is valid.
	b.	Works with 2 input parameters in registers:  the 2 input values to be added.
	c.	Stores the sum in a register, and indicates whether the sum is valid in another register.

4.	Write the convert procedure. This procedure:
	a.	converts the sum into 4 characters and stores them in an output string .
	b.	Works with 2 input parameters on the stack:  the sum and the address of the output string.

5.	Rewrite part of main so that it will do the following steps:
	a.	Call the getInput procedure, passing through the stack the 3 input arguments
			By the time the procedure returns, the user input should be in num1 and num2 variables.
	b.	Call the add procedure, passing through registers the 2 input arguments
			By the time the procedure returns, the sum should be in one register, and the boolean indicating the sum is valid or not should be in another register.
	c.	Check the boolean to see if the sum is valid
			- if not valid, print an error message then go to step d (same as in assignment 5)
			- if valid, call the convert procedure, passing through the stack the 2 input arguments
	  By the time the procedure returns, the output string should be completely filled and ready to print. 
         main prints the output string with a text explanation (same as in assignment 5)
	d.	Ask the user whether to continue, accept  'y' or 'Y' to continue, end if any other character.


The program output should be the same as with assignment 5. The only difference is that there is no invalid input number.


Additional requirements
-	Document your program to get full credit.
-	The add procedure should use 16-bit registers only. 
-	Use writeString to print the result. Using writeHex means an automatic 5 point deduction.
-	Each procedure should receive input data through the stack or through register as specified.
-	Except for main, the other 3 procedures cannot access data directly by using the variable names. 
This includes names of strings that are printed.  All input data used by these procedures must be passed in.
-	Each procedure should have its own stack frame. And the stack frame should be cleared out completely when the procedure call is completed.
-	When ready to upload, make sure the filename is assignment7.asm
!
