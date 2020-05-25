TITLE Project #5     (Program#5.asm)

;------------------------------------------------------------------------------------------------------------------------------------------------;
; Author: Brandon Schultz																														 ;
; Last Modified: 5-24-20																														 ;
; OSU email address:				   schulbra@oregonstate.edu																					 ;
; Course number/section:			   CS 271 400 Spring 2020																					 ;
; Project Number: Five                 Due Date: 5-24-20																						 ;
; Description:																																	 ;
; Contains MASM program that:																													 ;
;	-Generates 200 random numbers in the range [LO= 10 HI = 29], displays the original list, sorts the											 ;
;	list, displays the median value, displays the list sorted in ascending order, then displays the												 ;
;	number of instances of each generated value.																								 ;
;------------------------------------------------------------------------------------------------------------------------------------------------;

INCLUDE Irvine32.inc

;------------------------------------------------------------------------------------------------------------------------------------------------;
; Constant vals:                                                                                                                                 
;  -Array Size will always = 200
;  -200 elements contained by array will be random values in the range [LO= 10 HI = 29].
;  -Array's contents are displayed 20 elements/line.
;------------------------------------------------------------------------------------------------------------------------------------------------;
ARRAY_SIZE =		200
RANGE_LO =			10
RANGE_HI =			29
COUNT_LIST_SIZE =	20

;------------------------------------------------------------------------------------------------------------------------------------------------;
; Offsets utilized by procedures to access stack parameters
;  -Additional informaiton is provided in comments for individual PROCs below.
;------------------------------------------------------------------------------------------------------------------------------------------------;
PARAMETER_1 EQU [ebp + 8]
PARAMETER_2 EQU [ebp + 12]
PARAMETER_3 EQU [ebp + 16]
PARAMETER_4 EQU [ebp + 20]
PARAMETER_5 EQU [ebp + 24]
PARAMETER_6 EQU [ebp + 28]
PARAM_7 EQU [ebp + 32]

; Variable definitions:
.data
displayboardTOP		BYTE	  "|------------------------------------------------------------------------------------| ", 0
programmerName		BYTE      "|Brandon Schultz                                                                     | ", 0
programIntro		BYTE	  "|Program #5 - Sorting an Array Composed of 200 Elements                              | ", 0                        
ec_prompt			BYTE      "|**ec: No attempt made                                                               | ", 0
displayboardBOT		BYTE	  "|------------------------------------------------------------------------------------| ", 0
directionsPrompt	BYTE	  "Generates + displays 200 random numbers in range of [LO= 10 HI = 29] ", 0
medianStringPrompt  BYTE	  "List Median Value: ", 0
beforeSortPrompt	BYTE	  "Your unsorted random numbers: ", 0
afterSortPrompt		BYTE	  "Your sorted random numbers: ", 0
numOfEachValPormpt	BYTE	  "Frequency of generated values (Left Most= 10 | Right Most = 29):  ", 0
playAgainPrompt	    BYTE	  "1 = End Program | 2 = Generate Another Array ", 0
farewellPrompt		BYTE	  "Thanks for playing! ", 0
;blankSpace			BYTE	  "   ", 0
array				DWORD	  ARRAY_SIZE DUP(?)
numCounts			DWORD	  20 DUP(?)
endVal				DWORD	  1	  ; Used to terminate program or keep it running. 1=quit, all other keys = generate array

.code
main PROC

	; Irvine's random funciton for generation of 200 elements in the range [LO= 10 HI = 29].
	call		Randomize
	; Displays Boarder for top/bottom of assignment info template.
	; Displays program title, programmer name, extra credit status and instructions.
	push		OFFSET directionsPrompt
	push		OFFSET displayboardBOT
	push		OFFSET ec_prompt
	push		OFFSET programIntro
	push		OFFSET programmerName
	push		OFFSET displayboardTOP
	call		introProcedure

 ;------------------------------------------------------------------------------------------------------------------------------------------------;
 ; Main loop used to call various procedures for running program.
 ;  -Array is initially filled with integers in the range [LO= 10 HI = 29] via "addArrayItemsProcedure".
 ;	-Array's contents are displayed in two formats...
 ;		-Unorganized via "showListProcedure"	|	Organized in ascending order via "organizeListItemsProcedure" 
 ;		-and displayed via "showListProcedure"
 ;  -Median Value is found, then displayed using "showMedianValProcedure"
 ;  -Occurence of each value of elements is counted, then displayed using "countntListItemsProcedure" and "showListProcedure" procedures.
 ;  -User can then choose to quit program, or generate another 200 element containing array via thwe farewell procedure.
 ;------------------------------------------------------------------------------------------------------------------------------------------------;
 PROGRAM_LOOP:
	push		ARRAY_SIZE
	push		RANGE_HI
	push		RANGE_LO
	push		OFFSET array
	call		addArrayItemsProcedure
	push		OFFSET beforeSortPrompt
	push		ARRAY_SIZE
	push		OFFSET array
	call		showListProcedure
	push		ARRAY_SIZE
	push		OFFSET array
	call		organizeListItemsProcedure
	push		OFFSET medianStringPrompt
	push		ARRAY_SIZE
	push		OFFSET array
	call		showMedianValProcedure
	push		OFFSET afterSortPrompt
	push		ARRAY_SIZE
	push		OFFSET array
	call		showListProcedure
	push		RANGE_LO
	push		OFFSET numCounts
	push		ARRAY_SIZE
	push		OFFSET array
	call		countntListItemsProcedure
	push		OFFSET numOfEachValPormpt
	push		COUNT_LIST_SIZE
	push		OFFSET numCounts
	call		showListProcedure
	push		OFFSET playAgainPrompt
	call		endProgramProcedure
	mov			endVal, eax
	cmp			endVal, 1
	jne			PROGRAM_LOOP
	push		OFFSET farewellPrompt
	call		farewell
	exit							

main ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------;
; Procedures:
;  - Resources referenced when writing:
;	https://c9x.me/x86/html/file_module_x86_id_280.html
;	https://www.csie.ntu.edu.tw/~cyy/courses/assembly/10fall/lectures/handouts/lec15_x86procedure_4up.pdf
;	
;------------------------------------------------------------------------------------------------------------------------------------------------;

;------------------------------------------------------------------------------------------------------------------------------------------------;
; Prints intro text/prompts.
;  PARAMETER_1 OFFSET displayboardTOP
;  PARAMETER_2 OFFSET programmerName
;  PARAMETER_3 OFFSET programIntro
;  PARAMETER_4 OFFSET ec_prompt
;  PARAMETER_5 OFFSET displayboardBOT
;  PARAMETER_6 OFFSET directionsPrompt
;  -edx reg altered
;------------------------------------------------------------------------------------------------------------------------------------------------;
introProcedure PROC

	push		ebp
	mov			ebp, esp
	call		CrLf
	mov			edx, PARAMETER_1
	call		WriteString
	call		CrLf
	mov			edx, PARAMETER_2
	call		WriteString
	call		CrLf
	mov			edx, PARAMETER_3
	call		WriteString
	call		CrLf
	mov			edx, PARAMETER_4
	call		WriteString
	call		CrLf
	mov			edx, PARAMETER_5
	call		WriteString
	call		CrLf
	call		CrLf
	mov			edx, PARAMETER_6
	call		WriteString
	call		CrLf
	pop			ebp
	ret			6 * TYPE PARAMETER_1

introProcedure ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------;
; Assigns values in the range [LO= 10 HI = 29] to array's elements then fills array with said elements.
;  PARAMETER_1 OFFSET array
;  PARAMETER_2 OFFSET RANGE_LO
;  PARAMETER_3 OFFSET RANGE_HI
;  PARAMETER_4 OFFSET ARRAY_SIZE
;  PARAMETER_5 OFFSET -
;  PARAMETER_6 OFFSET -
;  -ecx, eax and esi regs altered
;------------------------------------------------------------------------------------------------------------------------------------------------;
addArrayItemsProcedure PROC

	push		ebp
	mov			ebp, esp
	mov			esi, PARAMETER_1
	mov			ecx, PARAMETER_4

arrayFill:
	mov			eax, PARAMETER_3
	sub			eax, PARAMETER_2
	inc			eax
	call		RandomRange
	add			eax, PARAMETER_2
	mov			[esi], eax
	add			esi, TYPE DWORD
	loop		arrayFill
	pop			ebp
	ret			4 * TYPE PARAMETER_1

addArrayItemsProcedure ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------;
; Displays array contents to user. Contains methods for assigning 20 items/row, 2 spaces between each item.
;  PARAMETER_1 OFFSET array
;  PARAMETER_2 OFFSET arraySize
;  PARAMETER_3 OFFSET beforeSortPrompt/afterSortPrompt/numOfEachValPormpt
;  PARAMETER_4 OFFSET -
;  PARAMETER_5 OFFSET - 
;  PARAMETER_6 OFFSET -
;  -ecx, eax, ebx, edx and esi regs altered
;------------------------------------------------------------------------------------------------------------------------------------------------;
showListProcedure PROC

	push		ebp
	mov			ebp, esp
	mov			esi, PARAMETER_1
	mov			ecx, PARAMETER_2
	mov			ebx, 1
	call		CrLf
	; displays unorganized array prompt.
	mov			edx, PARAMETER_3
	call		WriteString
	call		CrLf
 ; Prints initial row of elements. Loop ends when 20 element shave been added.
 DisplayRow:
	mov			eax, [esi]
	call		WriteDec
	mov			al, ' '
	call		WriteChar
	call		WriteChar
	cmp			ebx, 20
	je			newRowMarker
	inc			ebx
  ; Counter.
  DisplayRow2:
	add			esi, TYPE DWORD
	loop		DisplayRow
	jmp			endRowDisplay
 ; Adds a new row after 20 elements have been added.
 newRowMarker:
	call		CrLf
	mov			ebx, 1
	jmp			DisplayRow2
 ; Array has been filled, quit procedure.
 endRowDisplay:
	call		CrLf
	pop			ebp
	ret			3 * TYPE PARAMETER_1

showListProcedure ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------;
; Sorts array contents in ascending order.
;  PARAMETER_1 OFFSET array
;  PARAMETER_2 OFFSET arraySize
;  PARAMETER_3 OFFSET -
;  PARAMETER_4 OFFSET -
;  PARAMETER_5 OFFSET - 
;  PARAMETER_6 OFFSET -
;  -ecx, eax, and esi regs altered
;------------------------------------------------------------------------------------------------------------------------------------------------;
organizeListItemsProcedure PROC

	push		ebp
	mov			ebp, esp
	mov			ecx, PARAMETER_2
	dec			ecx
 ; Loop used to maintain a place holder-like array for swapping of elements on stack.
 outerLoopBegin:
	push		ecx
	mov			esi, PARAMETER_1
 ; Actively compares and swaps elements.
 innerLoopSwap:
	mov			eax, [esi]
	cmp			[esi + TYPE DWORD], eax
	jg			incrementEle
	add			esi, TYPE DWORD
	push		esi
	sub			esi, TYPE DWORD
	push		esi
	call		exchangeElements
 ; Used to increment loops, esi reg.
 incrementEle:
	add			esi, TYPE DWORD
	loop		innerLoopSwap
	pop			ecx
	loop		outerLoopBegin
	pop			ebp
	ret			2 * TYPE PARAMETER_1

organizeListItemsProcedure ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------;
; Sorts array contents in ascending order by referencing median value(s).
;  PARAMETER_1 OFFSET median val #1 //eax
;  PARAMETER_2 OFFSET median val #2 //ebx
;  PARAMETER_3 OFFSET -
;  PARAMETER_4 OFFSET -
;  PARAMETER_5 OFFSET - 
;  PARAMETER_6 OFFSET -
;  -eax,ebx and edx regs altered
;------------------------------------------------------------------------------------------------------------------------------------------------;
exchangeElements PROC

	push		ebp
	mov			ebp, esp
	pushad
	mov			eax, [PARAMETER_1]
	mov			ebx, [PARAMETER_2]
	mov			edx, [eax]
	mov			eax, [ebx]
	mov			ebx, edx
	mov			[esi], eax
	mov			[esi + TYPE DWORD], ebx
	popad
	pop			ebp
	ret			2 * TYPE DWORD

exchangeElements ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------;
; Sorts array contents in ascending order by referencing median value(s).
;  PARAMETER_1 OFFSET array
;  PARAMETER_2 OFFSET arraySize
;  PARAMETER_3 OFFSET medianStringPrompt
;  PARAMETER_4 OFFSET -
;  PARAMETER_5 OFFSET - 
;  PARAMETER_6 OFFSET -
;  -eax,ebx and edx regs altered
;------------------------------------------------------------------------------------------------------------------------------------------------;
showMedianValProcedure PROC
	push		ebp
	mov			ebp, esp
	mov			edx, PARAMETER_3
	call		WriteString
	mov			edx, 0
	mov			eax, [PARAMETER_2]
	mov			ebx, 2
	div			ebx
	cmp			edx, 0
 ; Calculates median value after index of middle values is obtained.
 medianValCaulculation:
	mov			eax, PARAMETER_1
	add			eax, 99 * TYPE DWORD
	mov			ebx, [eax]
	add			eax, TYPE DWORD
	mov			eax, [eax]
	add			eax, ebx
	mov			ebx, 2
	div			ebx
	add			eax, edx
	call		WriteDec
	jmp			quitMedianProcedure
 ; Ends "showMedianValProcedure"
 quitMedianProcedure:
	pop			ebp
	ret			3 * TYPE PARAMETER_1

showMedianValProcedure ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------;
; Counts and displays how frequently each number in range [LO= 10 HI = 29] appears as an element in generated array.
;  -"findNums_StartLoop" is used to scan array for values in range of 10-29, starting at lowest value (10).
;  -" checkNums_CountLoop" scans array for current value to be added to count list. If a number is found program jumps to 
;  "checkNums_NumberFound" where whole array is parsed for value that is currently being totaled.
;  -"checkNums_NumberFound" counts occurence of each value in array until entire 200 element-containing array has been scanned for said value.
;  -"findNums_ContinueLoop" adds total of each value counted to the count list, then increments previously searched for value by one.
;	-The incremented number is then subjected to the process outlined above until the High Val, 29 is reached. At which point the array containing
;	counted items is completely full and the countList proc can conclude.
;  PARAMETER_1 OFFSET array
;  PARAMETER_2 OFFSET arraySize
;  PARAMETER_3 OFFSET numCounts
;  PARAMETER_4 OFFSET RANGE_LO
;  PARAMETER_5 OFFSET - 
;  PARAMETER_6 OFFSET -
;  -eax,ebx,ecx,esi,edi and edx regs altered
;------------------------------------------------------------------------------------------------------------------------------------------------;
countntListItemsProcedure PROC

	push		ebp
	mov			ebp, esp
	mov			ebx, PARAMETER_4
	mov			edi, [PARAMETER_3]

 findNums_StartLoop:
	mov			esi, [PARAMETER_1]
	mov			ecx, PARAMETER_2
	mov			eax, 0

 checkNums_CountLoop:
	cmp			ebx, [esi]
	je			checkNums_NumberFound
	add			esi, TYPE DWORD
	loop		checkNums_CountLoop
	jmp			findNums_ContinueLoop

 checkNums_NumberFound:
	inc			eax
	add			esi, TYPE DWORD
	loop		checkNums_CountLoop
	jmp			findNums_ContinueLoop

 ;Lines 402-405 used to add frequency of occurence/value to count list.
 ;Lines 406-409 increment previously counted value through 29.
 findNums_ContinueLoop:		
	mov			[edi], eax
	add			edi, TYPE DWORD
	inc			ebx
	cmp			ebx, 30
	je			countListItemsEND
	jmp			findNums_StartLoop

 ; Count list is complete, values 10-29 scanned for and counted.
 countListItemsEND:
	pop			ebp
	ret			4 * TYPE PARAMETER_1

countntListItemsProcedure ENDP

; Quit program.
endProgramProcedure PROC

	push		ebp
	mov			ebp, esp
	mov			edx, PARAMETER_1
	call		WriteString
	call		ReadInt
	pop			ebp
	ret			1 * TYPE PARAMETER_1

endProgramProcedure ENDP

; Farewell message after ending program.
farewell PROC															
	call		CrLf
	push		ebp
	mov			ebp, esp
	mov			edx, PARAMETER_1
	call		WriteString
	call		CrLf
	pop			ebp
	ret			1 * TYPE PARAMETER_1

farewell ENDP

END main
