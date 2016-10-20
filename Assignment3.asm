TITLE Assignment3

COMMENT !															; Q1: Comment
NAME: DAT THANH NGUYEN
DATE: 10/12/2016
COURSE: CIS 21JA - FALL 2016
!

INCLUDE Irvine32.inc												; Q2: IO Library Routines

; .constant definition 
	WEEKS_PER_YEAR = 52
	DAYS_PER_WEEK = 5												; Q3: Create a constant called DAYS_PER_WEEK
	DAYS_PER_YEAR = WEEKS_PER_YEAR*DAYS_PER_WEEK					; Q4: Create a constant called DAYS_PER_YEAR by using the DAYS_OER_WEEK constant in an integer expression constant

.data
	bigData QWORD	1234567890abcdefh								; same bigData value as last lab
	arrData SBYTE	?,?,-25d,0Ch,00001101b							; Q5: Declare an array of 25 signed BYTE								
			SBYTE	?,?,?,?,?
			SBYTE	?,?,?,?,?
			SBYTE	?,?,?,?,?

	output	BYTE	"Output is ",0									; Q6: Define a string
	prompt	BYTE	"Please enter a possitive number: ", 0			; Q7: Define a prompt

.code
; ----------Code Segment Starting from here-----

main PROC ; Start main routine
																	; Q8: print DAYS_per_YEARS
	mov  eax, DAYS_PER_YEAR					;
	mov  edx, OFFSET output											;		Store the address of "output" into EDX
	call writeString												;		Read the address stored in EDX and print the value in that address [this case is "output is"]
	call writeDec													;		REead the data stores in EAX [unsigned int]

	call crlf
																	; Q9: ask user to enter a number
	mov  edx, OFFSET prompt											;		Store the address of PROMPT into EDX
	call writeString												;		Read and display the value in address stored in EDX 
	call readDec													; Q10 : Read input [stored in EAX]

																	; Q11 : Display input
	mov  edx, OFFSET output											;		Store the address of "output" into EDX
	call writeString												;		read the address stored in EDX and print the value in that address
	call writeDec													;		Read current value stored in EAX
	
	call crLf
																	; Q12: print 3rd element of array ( -25d )
	neg  eax														;		convert 0 -> 1 using negation
	mov  al, arrData[2]												;		stored in "al" is same size as arr[2]
	call writeString												;		edx is still storing the address "output"
	call writeInt													;		display value in eax [al is a part of EAX]


	exit

main ENDP ; End main routine
END main; 



























;;;;; Q14. At the end of the source file, without using semicolons (;), add a comment block
;;;;;      to show how bigData appears in memory (should be the same 8 hexadecimal values as in lab 2), 
;;;;;      and explain why it looks different than the actual value 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Here's what the all data definitions look like on my computer:
COMMENT !

ADDRESSES							     DATA
	**lower address**		**higher address**
		   ||------->----->------>--||
0x004068C0  ef cd ab 90 78 56 34 12 00 00 e7 0c 0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4f 75 74 70  ïÍ«.xV4...ç.................Outp
0x004068E0  75 74 20 69 73 20 00 50 6c 65 61 73 65 20 65 6e 74 65 72 20 61 20 70 6f 73 73 69 74 69 76 65 20  ut is .Please enter a possitive 
0x00406900  6e 75 6d 62 65 72 3a 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  number: ........................

In memory, data is stored in little Endian order, which mean LSB (on the right) is stored at lower address by chunks (32-bit) 4 bytes

DATA 12 34 56 78 90 ab cd ef

Little endian
ef cd ab 90 78 56 34 12

Note: in big Endian (in register), data is stored the same direction as order of original data 
!