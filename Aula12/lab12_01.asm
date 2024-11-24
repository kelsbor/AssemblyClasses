title manipulação de string

string_print MACRO string
    lea dx, string
    mov ah, 9
    int 21h
ENDM

.model small
.stack 0100h 
.data
    ; Mensagens de exibição
    string_type db 10,13,'Digite uma string de no maximo 100 caracteres: $'
    string_typed db 10,13,'String digitada: ',10,13, '$'
    string_copy db 10,10,13,'Copia da string: ',10,13, '$'
    string_cmp db 10,10,13,'A string digitada seria igual a armazenada? ',10,13, '$'
    string_a db 10,10,13,'Quantidade de caracteres (a): ',10,13, '$'
    equal db 'Sim, eh igual.$',10,13
    n_equal db 'Nao, eh diferente.$',10,13

    ; Variáveis
    string db 100 dup(?) ; armazena o input
    stringcopy db 100 dup(?) ; armazena a copia da string
    stringcmp db 'Frase super secreta' ; string armazenada
    s_length db ? ; comprimento do vetor (string)
    

.code   
; Le um vetor de caracteres, armazena em 'string' e printa na tela
read_vector PROC
    cld
    lea di, string  ; Define a string como destino
    ReadStore:
        ; Le um caractere, verifica CR e armazena no vetor
        mov ah, 1
        int 21h
        cmp al, 13
        je EndReadStore
        stosb ; Caracter em Al, armazena em string
        inc s_length ; Incrementa o comprimento
        jmp ReadStore
    EndReadStore:
    ; Printa a string digitada
    string_print string_typed
    lea si, string
    call print_vector
    ret
ENDP

; Printa um vetor de caracteres na tela. Endereço do vetor armazenado em SI
print_vector PROC
    cld
    mov cl, s_length ; Comprimento da string
    mov ah, 2

    print:
        lodsb   ; Carrega o caracter em al
        mov dl, al ; Move para dl e imprime de acordo com o comprimento
        int 21h
        loop print
    ret
ENDP

; Copia a string armazenada em 'string' para 'stringcopy'
copy_vector PROC
    cld
    lea si, string  ; Fonte na string digitada
    lea di, stringcopy ; Copia em stringcopy
    mov cl, s_length ; Comprimento da string
    rep movsb        ; Copia para stringcopy
    ret
ENDP

; Compara a string digitada com 'stringcmp'
cmp_vector PROC
    cld
    lea si, string ; Fonte na string digitada
    lea di, stringcmp ; Destino na string armazenada
    mov cl, s_length ; Comprimento da string

    repe cmpsb ; Repete enquanto for igual
    jnz not_equal
    lea dx, equal
    jmp prnt    ; Se for igual até o fim, printa equal

    not_equal:
        lea dx, n_equal ; Caso encontre uma diferença printa n_equal
    prnt:
        mov ah, 9
        int 21h
    ret
ENDP

; Varre o vetor 'string' e identifica quantas letras 'a' existem
scan_vector PROC
    cld
    mov al, 'a' ; Letra 'a' que sera procurada
    mov cl, s_length ; Comprimento do vetor
    lea di, string  ; Destino onde sera scaneado

    scan:
        scasb
        jnz pass ; Se nao for 'a', pula para proxima iteracao
        inc bx ; Se for 'a', incrementa bx
        pass:
        loop scan
    
    ; Printa o valor de bx (quantidade de 'a')
    mov dx,bx
    or dl, 30h
    mov ah, 2
    int 21h
    ret
ENDP

main PROC
    mov ax, @data
    mov ds, ax
    mov es, ax
    
    ; Le a string digitada 
    string_print string_type
    call read_vector

    ; Copia a string e printa a 'stringcopy'
    string_print string_copy
    call copy_vector
    lea si, stringcopy
    call print_vector

    ; Compara a string digitada com 'stringcmp'
    string_print string_cmp
    call cmp_vector

    ; Contagem de 'a' na string
    string_print string_a
    call scan_vector

    ; Finaliza o programa
    mov ah, 4ch
    int 21h
main ENDP
end main