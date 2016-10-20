TITLE  Assignment 4: Calculate time duration

COMMENT !
; Name:  Dat Thanh Nguyen
; Date:  6:05 PM 10/19/2016
Description goes here****
!
		


INCLUDE Irvine32.inc

; .constant definition
	MINUTES_PER_HOUR = 60														; Q1a. constant for the number of minutes in an hour

.data
	start_time_prompt BYTE "Please enter starting time (hhmm): "				; Q1b. A string for user to enter starting time
	end_time_prompt   BYTE "Please enter ending time (hhmm):"					; Q1c.

.code
; ----------Code Segment Starting from here-----

main PROC ; Start main routine

; Get user input
	mov		edx, OFFSET start_time_prompt										;Q1b. Display prompt for user to enter START time
	call	writeString															;     Print start_time_prompt to screen (accessing to edx)
	call	readDec																;     Retrive userinput and store in [EAX]

	mov     edx,0
	movzx	ecx, MINUTES_PER_HOUR
	div		ecx		
																; store result: quotient (eax) and remainder(edx)
	; store start time in ebx
	mov		edx, OFFSET end_time_prompt											;Q1c. Display prompt for user to enter END time
	call	writeString															;     Print end_time_prompt to screen (accessing to edx)
	call	readDec		
															;     Retrive userinput and store in [EAX]
	; store end time in ecx
	; Calculate duration using ecx and ebx

	; Make sure using constant and format data
	; Display output

	call crlf

	exit	

main ENDP	; End main routine
END main;


