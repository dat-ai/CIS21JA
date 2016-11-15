TITLE Module 7 Exercise

INCLUDE Irvine32.inc

.stack		;;;;; is this needed? 
;No, Irvine Library alreay declared stack 4096 by default

.data
n1 BYTE 3
n2 BYTE 4
prod WORD ?

productStr BYTE "product is ", 0
n2Str BYTE "n2 is ", 0

.code
main PROC

;;;;; part 1   parameter passing through registers

mov al, 5
mov bl, 3
call mul1	; multiply and display to screen
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
	mul bl
	mov edx, OFFSET productStr
	call WriteString

	; clear out eax 
	and eax, 0000ffffh
	call WriteInt
	ret

mul1 ENDP



; mul2 multiplies 2 bytes
; input: n1, n2
; output: on stack
mul2 PROC	

mul2 ENDP


; calc runs:
;      prod = prod * n1 + n2  
;      n2 = n2 - 1
; input: n1, n2, prod
; output: none
calc PROC

calc ENDP


END main

