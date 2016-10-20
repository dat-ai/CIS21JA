TITLE Assignment 2 Lab				

; The purpose of this lab is to introduce debugging features of the IDE 
; and reinforce concepts of modules 1 and 2
; By successfully finishing this lab you will learn basic debugging 
; skills that will help you debug your labs later in the quarter.


;;;;;; STEP 1: How to document all your programs in this class			
; Name: <Enter your full name here>
; Date: <Enter date here>

INCLUDE Irvine32.inc

.data
bigData QWORD 1357902468abcdefh

.code
main PROC
	mov eax, -1		

;;;;;; STEP 2: set a breakpoint at the mov instruction below and run to the breakpoint.

	mov ah, 100b	;   AX = 
	add ah, 2		;   AH = 
	inc al			;   AL =
	xor eax, eax    ;   EAX = 

;;;;;; STEP 3: for each instruction, run the instruction and then fill in the register value
;;;;;;         immediately after the instruction runs.
;;;;;;         Don't run all 4 instructions and then fill in the values.
;;;;;;         Use the correct number of hex digits for the size of the register.


;    bigData in memory = 

;;;;;; STEP 4: fill in what bigData looks like in memory
;;;;;;         Hint: bigData is a quadword, so how many bytes of data in memory should you copy in?


	call crlf
	exit	
main ENDP

END main