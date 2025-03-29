; Interpret as 32 bits code
[bits 32]

%include "../include/io.mac"

section .text
; int check_parantheses(char *str)
global check_parantheses
check_parantheses:
    push ebp
    mov ebp, esp

    ; stringul
    mov esi, [ebp + 8]
    ; valoarea de return
    xor eax, eax
    ; iterator prin sir
    xor ecx, ecx

string_loop:
    ; verific daca este paranteza deschisa
    cmp byte [esi + ecx], '('
    jz push_parantheses
    cmp byte [esi + ecx], '['
    jz push_parantheses
    cmp byte [esi + ecx], '{'
    jz push_parantheses

    ; verific daca este paranteza inchisa
    cmp byte [esi + ecx], ')'
    jz pop_parantheses
    cmp byte [esi + ecx], ']'
    jz pop_parantheses
    cmp byte [esi + ecx], '}'
    jz pop_parantheses

push_parantheses:
    ; daca este deschisa o adaug la stiva
    push dword [esi + ecx]
    jmp next_step

pop_parantheses:
    ; daca este inchisa extrag din stiva si compar cele doua paranteze
    pop edx
    cmp dl, '['
    jz double_inc
    cmp dl, '{'
    jz double_inc
    jmp cmp_parantheses

double_inc:
    ; intre {}, [] exista un caracter ascii
    inc dl

cmp_parantheses:
    ; paranteza deschisa o fac inchisa
    inc dl
    ; compar paranteza curenta cu cea scoasa din stiva
    cmp [esi + ecx], dl
    ; daca nu sunt egale ies din repetitiva si schimb valoarea de return
    jnz return_false

next_step:
    inc ecx
    ; verific daca am ajuns la final de sir
    cmp byte [esi + ecx], 0
    jnz string_loop
    ; verific daca stiva mai are paranteze adaugate
    cmp esp, ebp
    jnz return_false
    jmp return_true

return_false:
    inc eax
    ; golesc stiva de eventuale paranteze care inca mai sunt
    mov esp, ebp

return_true:
    leave
    ret
