TITLE Branching (Loop, If)

COMMENT !
Name : Dat Thanh Nguyen
CIS 21JA - Fall 206
Homework: #5
!

INCLUDE Irvine32.inc


.data
first_prompt		db   "Enter a first hex number:",0
second_prompt		db	 "Enter a second hex number:",0
ask_to_continue		db	 "Convert again? ['y' to continue]", 0
prompt				dd   OFFSET first_prompt, OFFSET second_prompt

err_msg_input		db "Please only enter 16-bit hex value", 0
result				db "The result is:", 0
invalid_result		db "Invalid result. [ Overflow detected. Result is greater than signed 16-bit]", 0

output				BYTE " ",?,?,?,?,0				; I put " " at first element because when looping 
													; ecx = 4 means 5th element of output.
													; If I place 1st element empty, call WriteString will not work (00 condition)
													
.code
main PROC

; MAIN LOOP
	loop_start:
			mov		ecx, 0							; clear counter / this will be used to stop read input (ECX <=1)
			mov		bx, 0
			jmp		readInput						; skip the display error message

		displayInputError:							; This block is ONLY triggered by validateInput:	
			mov		edx, OFFSET err_msg_input		; Otherwise, it will be skipped while outer loop is running
			call	writeString
			call	crlf

		readInput:
			cmp		ecx, 1							
			ja		displayResult					; PRINT result if main looop has interated two times
			mov		edx, prompt[ecx*4]				; display first_prompt and second_prompt, respectively 
			call	writeString
			call	readHex							; store hex input in AX
			jmp		validateInput					; validate Input. If failed, user has to re-enter the number

		displayResult:
			mov		ax,  bx							; Move stored the sum result from bx to ax
			mov		edx, OFFSET result
			call	writeString
  ; LOOP: EXTRACT HEX TO STRING
			mov		ecx, 4							;IMPORTANT: counter for HEX to String array ; LOOP 4 times
			mov		bx, 16
		convertHEXtoString: 
				cwd
				mov		dx, 0						; if I do not use this, It would give me weird result (cwd)--> FFF
				idiv	bx							; Get remainder to store.
				cmp		dx, 9						; Compare if output = a number or a letter (A..F)
				ja		extractLetter				; IF-ELSE control flows
			 extractNumber:
			   add		dl, 48d
			   jmp		AddtoString

			 extractLetter:							; a sub-routine of Convert Hex to String
				add		dl, 55d						; add 48 to convert dec to letter in ANSCII table
			 
		AddtoString:								; a sub-routine of Convert to Hex to String
			mov		output[ecx], dl					; save a char (0..9 or A..F) into output array
			loop	convertHEXtoSTRING
   ;END EXTRACTION
			mov		edx, OFFSET output				; DISPLAY result of coverting HEX to STRING
			call	writeString		
			call	crlf
			
	askToContinue:
			mov		edx, OFFSET ask_to_continue		; 3*4 means that EIP will point to the address of 3rd element of prompt
			call	writeString
			call	readChar
			call	crlf
			mov		dl, 'y'
			cmp		al, dl
			je		loop_start				
	loop_end:
			exit
; END MAIN LOOP 

; Theses below sub-routines are used within the main loop
	overFlowDetected:
			mov		edx, OFFSET invalid_result
			call	writeString
			call	crlf
			jmp		askToContinue

	validateInput:									;Test overflow: input should be in 16-bit signed number
			cmp		eax, 0FFFFh						; maximum possbile 16-bit number : 0xFFFFh
			jg		displayInputError				; if overflow / jump back to displayError
			inc		ecx
			jmp		addInput						; after validation, jump back to check input

	addInput:
			add		bx, ax							; save output in BX
			jc		overFlowDetected				; using CF instead of OF 
			jmp		readInput


main ENDP
END main
