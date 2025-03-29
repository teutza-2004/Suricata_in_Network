; subtask 1 - qsort

%define INT_SIZE 0x4

section .text
    global quick_sort
    ;; no extern functions allowed

quick_sort:
    ;; create the new stack frame
    enter 0, 0

    ;; save the preserved registers
    push esi
    push edi
    push ebx

    ; sirul de numere
    mov esi, [ebp + 8]
    ; index-ul de start
    mov ebx, [ebp + 12]
    ; indexul de final
    mov edx, [ebp + 16]
    ; pivot-ul (ultimul element)
    mov eax, [esi + edx * INT_SIZE]

    ;; recursive qsort implementation goes here
    cmp ebx, edx
    jge qs_fin

    ; index pt iteratie in vector
    mov ecx, ebx
    ; index pt a pune numerele mai mici ca pivotul la inceput
    mov edi, ebx
    inc edx
vect_iter:
    cmp [esi + ecx * INT_SIZE], eax
    jle swap
    jmp next

swap:
    push dword [esi + ecx * INT_SIZE]
    push dword [esi + edi * INT_SIZE]
    pop dword [esi + ecx * INT_SIZE]
    pop dword [esi + edi * INT_SIZE]
    inc edi

next:
    inc ecx
    cmp ecx, edx
    jnz vect_iter

    dec edx
    ; index pivot
    mov ecx, edi
    dec ecx

first_half:
    push edx
    dec ecx
    push ecx
    push ebx
    push esi
    call quick_sort
    pop esi
    pop ebx
    pop ecx
    inc ecx
    pop edx

second_half:
    push ebx
    push edx
    inc ecx
    push ecx
    push esi
    call quick_sort
    pop esi
    pop ecx
    dec ecx
    pop edx
    pop ebx

qs_fin:
    ;; restore the preserved registers
    pop ebx
    pop edi
    pop esi
    leave
    ret
