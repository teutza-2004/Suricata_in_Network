; subtask 2 - bsearch

%define INT_SIZE 0x4

section .text
    global binary_search
    ;; no extern functions allowed

binary_search:
    ;; create the new stack frame
    enter 0, 0

    ;; save the preserved registers
    push esi
    push edi
    push ebx

    ;; recursive bsearch implementation goes here
    ; sirul de numere
    mov esi, ecx
    ; elementul cautat (needle)
    mov edi, edx
    ; index-ul de start
    mov ebx, [ebp + 8]
    ; indexul de final
    mov edx, [ebp + 12]
    ; pun -1 in eax
    mov eax, -1

    cmp ebx, edx
    jg bs_fin

    ; calculez index-ul mijlocului in ecx
    mov ecx, ebx
    add ecx, edx
    shr ecx, 0x1

    cmp [esi + ecx * INT_SIZE], edi
    jz ret_value
    cmp [esi + ecx * INT_SIZE], edi
    jl second_half

first_half:
    dec ecx
    push ecx
    push ebx
    mov ecx, esi
    mov edx, edi
    call binary_search
    pop ebx
    pop ecx
    inc ecx
    jmp bs_fin

second_half:
    push edx
    inc ecx
    push ecx
    mov ecx, esi
    mov edx, edi
    call binary_search
    pop ecx
    dec ecx
    pop edx
    jmp bs_fin

ret_value:
    mov eax, ecx
bs_fin:
    ;; restore the preserved registers
    pop ebx
    pop edi
    pop esi
    leave
    ret
