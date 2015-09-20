TITLE PrimeTime   (Program4.asm)

; Name: Colleen Minor 
;Email: minorc@onid.oregonstate.edu
; CS271-400 / Assignment 4                                           Date: 2/15/2015
; Description: Program instructs user to enter the number of primes to be displayed
;and prompts them to enter a number, n, between 1 and 200. It the verifies that n is
;between 1 and 200. It then cacluates and displays all primes up-to and including tne nth prime.
;It displays 10 primes per line with 3 spaces between numbers.

INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data
 upperLimit equ 200               ;maximum number user can choose
 lowerLimit equ 1                 ;minimum number user can choose
 userChoice SDWORD ?       ;integert to be entered by user
 one SDWORD 1                     
 zero SDWORD 0
 numerator SDWORD 2               ;integer to be tested for primeness.
 denominator SDWORD 2             ;integer that numerator is to be divided by during testing.
 tenCount SDWORD 0                ;integer to keep track of whether it is time for a new line.


.code
main PROC
       call introduction
       call getUserData
       call showPrimes
       call fareWell

	;introduction
		;Procedure to greet the user. 
		;receives: None
		;returns: Output text in console window
		;preconditions:  None
		;registers changed: efl
		introduction PROC
              mWrite "Welcome to PRIME TIME by Colleen."
              call Crlf
              mWrite "This program display between 1 and 200 prime numbers."
              ret
       introduction ENDP

;getUserData
	;Procedure to receive the number of prime numbers user would like displayed
	;and display an error messege if it receives input <1 or >200. 
	;receives: userChoice is a global variable.
	;returns: userChoice = console window input.
	;preconditions:  
	;registers changed: eax
       getUserData PROC
              call Crlf
              mWrite "Enter the number of primes to display [1 .. 200]:  "
              call readInt
              mov userChoice, eax
              call validate
              ret
	
		;validate
			;Procedure to confirm that the user entered input >= 1 and <= 200/
			;receives: upperLimit and lowerLimit are symbolic constants. 
			;returns: Either userChoice = console window input or and error messege and repeated request.
			;preconditions: 
			;registers changed: eax, esp
            validate PROC
                     cmp eax, upperLimit
                     jg errorLoop
                     cmp eax, lowerLimit
                     jl errorLoop
                     ret
                     errorLoop:
                           mov eax, 0
                           mov userChoice, eax
                           call Crlf
                           mWrite "Sorry, number must be between 1 and 200. Please try again."
                           call Crlf
                           call getUserData
              validate ENDP
              getUserData ENDP

		;showPrimes
			;Procedure to calculate and print the userChoice number (n) of prime numbers. 
			;receives: userChoice, tenCount, numerator, and denominator are global variables 
			;returns: numerator = nth prime number. 
			;preconditions:  userChoice >= 0 
			;registers changed: eax, ecx, edx
            showPrimes PROC
					;printingPrimes is the counter loop that runs the user-specified number of times, 
					;printing a prime once per iteration.
                     mov ecx, userChoice               
                     printingPrimes:
                           mov eax, numerator
                           call writeDec
                           mwrite "   "
                           call isPrime
                           INC tenCount
                           cmp tenCount, 10
                           je newLine
                           jmp endLoop
                           newLine:
                                  mov eax, 0
                                  mov tenCount, 0
                                  call Crlf
                           endLoop:
              loop printingPrimes

				;isPrime
					;isPrime increments the numerator and then tests it for primeness until a prime number is found.
					;A prime number is determined by dividing it by numbers 2 through (numerator) without having a remainder of 0
					;until it is being divided by itself.
					;receives: numerator and denominator are global variables 
					;returns: numerator = next primer number after the received numerator. 
					;preconditions:  numerator is a positive number, and should be the most recently used prime number. 
					;registers changed: eax, edx 
                    isPrime PROC
                           mov eax, 2                        ;Begin the test with a denominator of 2
                           mov denominator, eax
                           INC numerator
                           testForPrime:         
                                  mov eax, denominator
                    mul one
                    mov eax, numerator
                    div denominator
                    cmp edx, zero
                    jne remainderFound  
                    jmp isPrime                 ;Number not a prime. Test a higher numerator.                                                                                       
                           remainderFound:
                                  INC denominator
                                  mov eax, numerator
                                  cmp eax, denominator
                                  jne testForPrime     ;If the denominator is still less than the numerator, test out newly incremented denominator in testForPrime.
                                  ret                  ;Else, return with the prime number now in numerator.
                     isPrime ENDP
              showPrimes ENDP

	;fareWell
		;Procedure to display goodbye messege to user.
		;receives: 
		;returns: Goodbye messege into console output window.
		;preconditions: 
		;registers changed: 
        fareWell PROC
                     call Crlf
                     mWrite "Thank you for using PRIME TIME! Have a lovely day!"
                     call Crlf
        fareWell ENDP
        exit
main ENDP
END main
