TITLE  Assignment 4: Calculate time duration

COMMENT !
; Name:  Dat Thanh Nguyen
; Date:  6:05 PM 10/19/2016
Description goes here****
!
		


INCLUDE Irvine32.inc

; .constant definition
	MINUTES_PER_HOUR = 60											; Q1a. constant for the number of minutes in an hour

.data
	start_prompt BYTE "Please enter starting time (hhmm): ",0		; Q1b. A string for asking user to enter starting time
	end_prompt   BYTE "Please enter ending time (hhmm):", 0			; Q1c. A string for asking user to enter ending time
	hour		 BYTE " hr ", 0
	minute		 BYTE " min ",0

.code
; ----------Code Segment Starting from here-----

main PROC ; Start main routine
;-------------------------------------------------------------------
; Solving Stratergy:
	;Data
;		Constant			: stored in ESI
;		100 (for division)	: stored in CX
	;Result
;		Starting Time		: stored in BX
;		Ending Time			: stored in CX
;		Duration			: stored in CX -  eventually copied back to EAX
;  ;Display:
;		when moving data into eax, must using movsx to keep the sign
;----------------------------------------------------------------------
	mov		ecx, 0
	        ;;;;;;;;;; don't zero out registers unless you need the value 0

	mov		cx, 100d												;		Assign 100 to register [CH} in order to separate hour and minutes 
	mov     esi, MINUTES_PER_HOUR									;		Assign MIN_PER_HOUR to register [CL]

; Get START TIME

	mov		edx, OFFSET start_prompt								;Q1b. Display prompt for user to enter START time
	call	writeString												;     Print start_time_prompt to screen (accessing to edx)
	call	readDec													;     Retrive userinput and store in [EAX]

	mov     edx,0
	div		cx														;		Divide ax/ch : store result: quotient (eax) and remainder(edx)(0130 / 100 ---> al :0001,)
	mov		bx, dx													;		Store remainder in CX 
	mul		esi														;		multiply al with cl
		;;;;;;; if your data are words, you should use: mul si
		;;;;;;; so that everything is a word

	add		ax,bx													;		add dx to ax (dx is remainder from the division on line 32)
	mov		ebx,eax													;		Store "start time" in [EBX]

;Get END TIME
	
	mov		edx, OFFSET end_prompt									;Q1c. Display prompt for user to enter END time
	call	writeString												;     Print end_time_prompt to screen (accessing to edx)
	call	readDec													;     Retrive userinput and store in [EAX]

	mov		edx, 0
	div		cx
	mov		cx,dx													;	  Store the remainder in [CX]
	mul		esi
		;;;;;;;;;; mul si

	add		ax, cx
	mov		ecx,eax	
												
; CALCULATE DURATION

		;;;;;;;;; lab requirement: don't use dword data   -1/2pt
	sub		ecx,ebx													;Q1D. Calculate duration using ecx and ebx
	movsx	eax, cx													;		Move result  back to eax for division
	cdq																;		Notify this is signed divison
	idiv	esi														;		EAX / ESI
	mov		bx, dx

; Print OUTPUT
																	;Q1E Display output
	call crlf

	call writeInt
	mov  edx, OFFSET hour
	call writeString

	movsx  eax, bx
	call writeInt
	mov  edx, OFFSET minute
	call writeString
	
	exit	
main ENDP	; End main routine
END main;
							
							;;;;;;;; great documentation and thorough explanation for part 2

COMMENT !
Question 2 (5pts)
************************************
CASE 1
*************************************
   	mov al, 10h 
	add al, 74h     
	; a. ZF = 0 SF = 1  CF = 1  OF = 0
	;			AL : 0001 0000
	;			(+): 0111 0100
	;			---------------
	;				 1000 0100
	;
	; b. explanation for CF: 0 because there is no carry out of MSB
	;    explanation for OF: (carry in MSB) XOR (carry out MSB) : 1 XOR 0 = 1
************************************
CASE 2
*************************************
	sub al, 0Fh     

	; a. ZF = 0  SF = 0  CF = 0 OF = 1
	;			AL	  1000 0100
	;			(-)   0000 1111 
	; 2's Complement Method ((!000 1111) + (0000 0001) = 1111 0001)
	;			AL	  1000 0100
	;			(+)   1111 0001		
	;           ---------------
	;			  (1) 0111 0101
	; b. explanation for CF: 0 because there is carry out (1)
	;    explanation for OF: (carry Out) XOR (carry IN) = (1) XOR (0) = 1

!