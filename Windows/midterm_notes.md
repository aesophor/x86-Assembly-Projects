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

