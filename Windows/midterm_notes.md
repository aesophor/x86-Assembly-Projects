## x86 Assembly Midterm Notes

### 3.1 Section Review (p. 95)
1. Using the value -35, write it as an integer literal in decimal, hexadecimal, octal and binary formats that are consistent with MASM syntax.
2.  Is A5h a valid hexadecimal literal? **No. A leading 0 is required**
3. Does the multiplication operator (*) has a higher precedence than the division operator (/) in integer expressions? **No. Same.**
4. Create a single integer expression that uses all the operators from Section 3.1.2. Calculate the value of the expression. **30 mod (3 * 4) + (3 - 1) / 2**
5. Write the real number -6.2 x 10^4 as a real number literal using MASM syntax. **-6.2E + 04**
6. Must string literals be enclosed in single quotes? **No**
7. Reserved words can be instruction mnemonics, attributes, operators, predefined symbols, and **directives**.
8. What is the maximum length of an identifier? **247**

### 3.2 Section Review (p. 102)
```
.386
.model flat,stdcall
.stack 4096

INCLUDE Irvine32.inc
ExitProcess PROTO, dwExitCode:DWORD

.data
    ; declare variables here

.code
main PROC
    ; write your code here
    INVOKE ExitProcess,0
main ENDP

; (additional procedures here)
END main
```
1. What is the meaning of the INCLUDE directive? **To include a library**
2. What does the .CODE directive identify?
3. What are the names of the two (primary) segments in an asm program? **Code and Data**
4. Which register holds the sum? **eax/rax are usually used as accumulator**
5. Which statement halts the program? **invoke ExitProcess, 0**

### 3.3 Section Review (p. 105)
![Imgur](https://i.imgur.com/3bi2QbY.png)
1. What types of files are produced by the assembler? **Object file; List file**
2. What types of files are produced by the linker? **Executable file; Map file**
3. The linker extracts assembled procedures from the link library and inserts them in the executable program. **true**
4. When a program's source code is modified, it must be assembled and linked again before it can be executed with the changes. **true**
5. Which OS component reads and executes programs? **loader**

* Further reading : [Static vs Dynamic Linking](http://www.cs-fundamentals.com/tech-interview/c/difference-between-static-and-dynamic-linking.php)

### 3.4 Section Review (p. 115)
| Type | Reserved Bits | Reserved Byte(s) | Note |
| --- | --- | --- | --- |
| (S) BYTE | (Signed) Unsigned 8 | 1 | |
| (S) WORD | (Signed) Unsigned 16 | 2 | 1 WORD = 2 BYTES|
| (S) DWORD | (Signed) Unsigned 32 | 4 | Double WORD (2 * 2 = 4) |
| (S) QWORD | (Signed) Unsigned 64 | 8 | Quad Word (4 * 2 = 8) |

Declare an uninitialized data for the following:
1. a 16-bit singed integer. **var1 SWORD ?**
2. an 8-bit unsigned integer. **var2  BYTE ?**
3. an 8-bit signed integer. **var3  SBYTE ?**
4. a 64-bit integer. **var4 QWORD ?**
5. Which data type can hold a 32-bit signed integer? **SDWORD**

### 3.5 Section Review (p. 120)
```
msg TEXTEQU <Some text> ; Text assigned to symbol  
string TEXTEQU msg ; Text macro assigned to symbol  
msg TEXTEQU <Some other text> ; New text assigned to symbol  
value TEXTEQU %(3 + num) ; Text representation of resolved
```
```
; Example 1
var1 EQU 10 * 10    ; 100
var2 EQU <10 * 10>  ; "10 * 10"
var3 %(10 * 10)     ; "100"

; Example 2
rowSize = 5
count TEXTEQU %(rowSize * 2)        ; Calculate value in %() and convert to text.
move TEXTEQU <mov>                  ; Will replace "move" with "mov" afterward.
setupAL TEXTEQU <move al, count>    ; setupAL TEXTEQU <mov>
setupAL                             ; See below.

;
setupAL
= move al, count
= mov al, 10
```
1. Declare a symbolic constant using the equal-sign directive that contains the ASCII code (08h) for the Backspace key. **BACKSPACE = 08h**
2. Declare a symbolic constant named SecondsInDay using the equal-sign directive and assign it an arithmetic expression that calculates the number of seconds in a 24-hour period. **SecondsInDay = 60 * 60 * 24**
3. Write a statement that causes the assembler to calculate the number of bytes in the following array, and assign the value to a symbolic constant named ArraySize: 
`myArray WORD 20 DUP(?)` **ArraySize = ($ - myArray)**
4. Show how to calculate the number of elements in the following array, and assign the value to a symbolic constant named ArraySize:
`myArray DWORD 30 DUP(?)` **ArraySize = ($ - myArray) / TYPE myArray**
5. Use a TEXTEQU expression to redefine "proc" as "procedure". **procedure TEXTEQU \<proc\>**
6. Use TEXTEQU to create a symbol named `Sample` for a string constant, and then use the symbol when defining a string variable named `myString`.
**Sample TEXTEQU \<"lolcat", 0\>**
**myString BYTE Sample**
7. Use TEXTEQU to assign the symbol SetupESI to the following line of code:
`mov esi, OFFSET myArray` **SetupESI TEXTEQU \<mov esi, OFFSET myArray\>**

### 4.1 Section Review (p. 136)
1. What are the three basic types of operands? **Register / Immediate / Memory**
2. The destination operand of a MOV instruction cannot be a segment register?
