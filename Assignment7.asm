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


TITLE Module 7 Exercise

INCLUDE Irvine32.inc

.data

	num1			WORD	0F123h
	num2			WORD	0E456h

	first_prompt	BYTE	"Enter a first hex number:",0
	second_prompt	BYTE	"Enter a second hex number:",0
	prompt			DWORD    OFFSET first_prompt, OFFSET second_prompt


.code
main PROC

;Step 1 : Get user's input using Stack Frame
	mov		edx, prompt
	push	edx	
	push	OFFSET num1			; address of num1
	push	OFFSET num2			; address of num2
	call	getInput

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
												; Save register's data
												;Aternative : pushad
	push	eax
	push	ebx
	push	ecx
	push	edx
										
												; STACK FRAME in Memory
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
	mov		ecx, 0
		
		mov		ebx, 04h				; multiplier to iterate array of inputstring
	DISPLAY:
		cmp		ecx, 2
		je		FINISHED

		mov		eax, [ebp+16]
		mul		bl
		mov		edx, [ebp+16]					; display first_prompt and second_prompt, respectively 
												; by iterate through array of inputstring
		mov		eax, ecx
		mul		bl
		add		edx, eax
		call	writeString
		call	readHex							; store hex input in AX
												; There is no validation here since input is guranteed to be a hex value within 16 bits
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

COMMENT !
2.	Write the getInput procedure.  This procedure:
	a.	Prompts the user and reads in 2 hexadecimal values, and stores them in num1 and num2.
	b.	Works with 3 parameters on the stack:  address of the input prompt string address, address of num1, address of num2.
	c.	You don't have to check for invalid input values. The input is guaranteed to be a hex value within 16 bits.
!

END main