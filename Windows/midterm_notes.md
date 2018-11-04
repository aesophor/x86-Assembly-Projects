## x86 Assembly Midterm Notes

### 3.1 Section Review (p. 95)
1. Using the value -35, write it as an integer literal in decimal, hexadecimal, octal and binary formats that are consistent with MASM syntax.
2.  Is A5h a valid hexadecimal literal? **No. A leading 0 is required (A hexadecimal literal beginning with a letter must have a leading zero to prevent the assembler from interpreting it as an identifier.)**
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
```
mov dest, src
mov ds, ax    ; modify a segment reg: OK
mov ip, ax    ; modify the instruction pointer: ERROR
```
1. What are the three basic types of operands? **Register / Immediate / Memory**
2. The destination operand of a MOV instruction cannot be a segment register? **false**
3. In a MOV instruction, the second operand is known as the destination operand. **false**
4. The EIP register cannot be the destination operand of a MOV instruction. **true (EIP is read only, i.e., cannot be modified directly by a user.)**
5. In the operand notation used by Intel, what does reg/mem32 indicate? **a 32-bit register or memory operand**
6. In the operand notation used by Intel, what does imm16 indicate? **a 16-bit immediate operand**

### 4.2 Section Review (p. 144)
```
CF -> Set to 1 when last arithmetic operation exceeds its Unsigned range.
OF -> 正正得負 or 負負得正
SF -> If MSB = 1, then SF = 1
```
```
.data
val1 BYTE  10h
val2 WORD  8000h
val3 DWORD 0FFFFh
val4 WORD  7FFFh
```
1. Write an instruction that increments val2. **inc val2**
2. Write an instruction that subtracts val3 from EAX. **sub eax, val3**
3. Write instructions that subtract val4 from val2.
**mov ax, val4**
**sub val2, ax**
4. If val2 is incremented by 1 using the ADD instruction, what will be the values of the Carry and Sign flags? **1000b 0x0 0x0 0001; CF = 0; SF = 1** Note: 8h = 1000b.
5. If val4 is incremented by 1 using the ADD instruction, what will be the values of the Overflow and Sign flags? **1000b 0x0 0x0 0x0; OF = 1; SF = 1**
6. Where indicated, write down the values of the Carry, Sign, Zero and Overflow flags after each instruction has executed (question a, b, c are inter-independent):
```
mov ax, 7ff0h   ; 0111 1111 1111 0000
add al, 10h     ; a. CF = 1 ; SF = 0 ; ZF = 1 ; OF = 0
add ah, 1       ; b. CF = 0; SF = 1; ZF = 0; OF = 1
add ax, 2       ; c. CF = 0; SF = 1; ZF = 0; OF = 0

a. mov ax, 7ff0h   ; 0111 1111 1111 0000
                             + 0001 0000
                             -----------
                             1 0000 0000 (正+負，故OF = 0; Unsigned爆開，CF = 0)
```
* Further Reading: [carry flag vs overflow flag](https://stackoverflow.com/questions/8496185/assembly-carry-flag-vs-overflow-flag#13424707)

### 4.3 Section Review (p. 149)
```
OFFSET -> &
PTR -> override || explicitly specify the following operand's size.
TYPE -> get the following operand's size in bytes. (e.g., BYTE = 1, WORD = 2, DWORD = 4, QWORD = 8)
LENGTHOF -> number of elements in an array.
SIZEOF -> number of bytes of an array.
```
1. The OFFSET operator always returns a 16-bit value. **false**
2. The PTR operator returns the 32-bit address of a variable. **false (PTR is used to override the declared size of an operand.)**
3. The TYPE operator returns a value of 4 for doubleword operands. **true**
4. The LENGTHOF operator returns the number of bytes in an operand. **false (LENGTHOF counts the number of elements in an array.)**
5. The SIZEOF operator returns the number of bytes in an operand. **true (= LENGTHOF * TYPE)**

### 4.4 Section Review (p. 154)
1. Any 32-bit general-purpose register can be used as an indirect operand. **true**
2. The EBX register is usually reserved for addressing the stack. **false (It is EBP and ESP that are reserved for addressing the stack.)**
3. The following instruction is invalid : `inc [esi]`. **true (PTR directive is required. see p. 150)**
4. The following is an indexed operand: `array[esi]`. **true**
5. Please refer to the textbook.
6. Please refer to the textbook.

### 4.5 Section Review (p. 160)
1. A JMP instruction can only jump to a label inside the current procedure. **~~false~~ true**
2. JMP is a conditional transfer instruction. **false**
3. If ECX is initialized to zero before beginning a loop, how many times will the LOOP instruction repeat? (Suppose ECX won't be modified within the loop.) **0**
4. The LOOP instruction first checks to see whether ECX is not equal to zero; then LOOP decrements ECX and jumps to the destination label. **false (decrement ECX and then check.)**
5. The LOOP instruction does the following: It decrements ECX; then, if ECX is not equal to zero, LOOP jumps to the destination label. **true**
6. In real-address mode, which register is used as the counter by LOOP instruction? **CX**
7. In real-address mode, which register is used as the counter by the LOOPD instruction? **ECX**
8. The target of a LOOP instruction must be within 256 bytes of the current location. **false (-128~127 bytes)**
9. **The program won't stop! loop L1 will decrement ECX first, making it's value FFFFFFFFh.**
10. 
```
    mov eax, 0
    mov ecx, 10
L1:
    push ecx            ; save outer loop count
    mov eax, 3
    mov ecx, 5
L2:
    add eax, 5
    loop L2
    pop ecx             ; restore outer loop count
    loop L1             ; dec ecx, jne L1.
```

### 4.6 Section Review (p. 163)
1. Moving a constant value of 0FFh to the RAX register clears bits 8 through 63. **true**
2. A 32-bit constant may be moved to a 64-bit register, but 64-bit constants are not permitted. **false (You can't mov 64-bit data into a 64-bit reg, you're kidding me, right?)**

### 5.1 Section Review (p. 177)
1. Which register (in 32-bit mode) manages the stack? **esp**
2. How is the runtime stack different from the stack abstract data type? **The runtime stack is managed directly by the CPU. It holds the return addresses of called procedures.**
3. Why is the stack called a LIFO structure? **Because it's Last In First Out. The last value pushed on the stack is the first value popped out from the stack.**
4. When a 32-bit value is pushed on the stack, what happens to ESP? **ESP decremented by 4**
5. Local variables in procedures are created on the stack. **true**
6. The PUSH instruction cannot have an immediate operand. **false**

### 5.2 Section Review (p. 185)
