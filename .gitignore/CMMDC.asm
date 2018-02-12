%include "io.inc"
extern puts

section .data
    %include "input.inc"
    errorprint: db "Baza incorecta",0
    
section .text
global CMAIN
CMAIN:
    mov ebp, esp        ; for correct debugging
    
    mov eax, dword[numar]; copy the number in eax
    mov ebx, dword[baza] ; copy the base in eax

    cmp ebx, 2          ; if base < 2 go to error_print
    jl error_print

    cmp ebx, 16         ; if base > 16 go to error_print
    jg error_print
    
    mov ecx, 0          ; counter = 0
    
transform:
    mov edx, 0          ; clean edx
    inc ecx             ; increment the counter
    
    mov ebx, dword[baza]; copy the base
    div ebx             
    
    push edx            ; push into a stack the remainder
    
    cmp ax, 0           ; compare the quotient with zero
    jne transform

print_transform:
    pop edx             ; pop the remainder
    dec ecx
    
    cmp dx, 10          ; if remainder > 10 go to print_hex
    jge print_hex
    
    PRINT_UDEC 2, dx    ; print if 0 <= dx < 10

    cmp ecx, 0
    jne print_transform ; loop until counter == 0
    je finish           ; jump to finish if counter == 0

print_hex:
    add dx, 87          ; ASCII conversion 
                        ; example 87 + 11 = 97 -> 'a'
    
    PRINT_CHAR dx
    cmp ecx, 0          
    je finish           ; if counter == 0 go to finish
    jmp print_transform ; return to print_transform loop
    
error_print:
    lea ebx, [errorprint]
    push ebx            
    call puts           ; prints the error
    pop ebx

finish:
    xor eax, eax        ; end
    ret