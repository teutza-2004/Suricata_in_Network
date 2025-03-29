%include "../include/io.mac"

%define INT_SIZE 0x4

; The `expand` function returns an address to the following type of data
; structure.
struc neighbours_t
    .num_neighs resd 1  ; The number of neighbours returned.
    .neighs resd 1      ; Address of the vector containing the `num_neighs` neighbours.
                        ; A neighbour is represented by an unsigned int (dword).
endstruc

section .bss
; Vector for keeping track of visited nodes.
visited resd 10000
global visited

section .data
; Format string for printf.
fmt_str db "%u", 10, 0

section .text
global dfs
extern printf

; C function signiture:
;   void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node))
; where:
; - node -> the id of the source node for dfs.
; - expand -> pointer to a function that takes a node id and returns a structure
; populated with the neighbours of the node (see struc neighbours_t above).
; 
; note: uint32_t is an unsigned int, stored on 4 bytes (dword).
dfs:
    push ebp
    mov ebp, esp

    ; TODO: Implement the depth first search algorith, using the `expand`
    ; function to get the neighbours. When a node is visited, print it by
    ; calling `printf` with the format string in section .data.

    push ebp
    push edi
    push esi

    ; nodul de start
    mov ebx, [ebp + 8]
    ; adresa functiei
    mov edi, [ebp + 12]

    ; verific daca nodul este vizitat
    cmp dword [visited + ebx * INT_SIZE], 0x1
    jz dfs_fin

    ; marchez nodul ca vizitat + afisare
    mov dword [visited + ebx * INT_SIZE], 0x1
    push ebx
    push fmt_str
    call printf
    pop eax
    pop ebx

    ; structura de vecini (eax)
    push ebx
    call edi
    pop ebx

    ; nr de vecini
    mov ecx, [eax + neighbours_t.num_neighs]
    cmp ecx, 0x0
    jz dfs_fin
    ; vectorul de vecini
    mov esi, [eax + neighbours_t.neighs]
    ; iterator prin sir
    xor edx, edx

for_neighs:
    ; salvez indexul de iteratie si nr de noduri adiacente
    push ecx
    push edx
    push edi
    push dword [esi + edx * INT_SIZE]
    call dfs
    pop eax
    pop edi
    ; restaurez nr de noduri si indexul de iteratie
    pop edx
    pop ecx
    inc edx
    cmp edx, ecx
    jnz for_neighs

dfs_fin:
    pop esi
    pop edi
    pop ebx
    leave
    ret
