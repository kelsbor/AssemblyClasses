title numero
.model small
.stack 100h
.data
    msg1 db "Digite um caractere: $"
    sim db 10,13, "O caractere digitado e um numero. $"
    nao db 10,13, "O caractere digitado nao e um numero. $"

.code
MAIN proc
    ;permitir acesso às variaveis em .data
    mov ax, @data
    mov ds, ax

    ;exibir na tela a string msg1
    mov ah, 9
    lea dx, msg1
    int 21h

    ;le o caracter do teclado e salva no registrador al
    mov ah, 1
    int 21h

    ;copia o caracter para bl
    mov bl, al

    ;compara o valor de bl com 48 (ASCII do caracter '0')
    cmp bl, 48     

    ;se for menor que 48('0')... (jb) jump below
    jb NAOENUMERO
    
    ;compara se o valor de bl com 57.
    cmp bl, 57

    ;se for maior que 57('9')... (ja) jump above
    ja NAOENUMERO

    ;se passou pelos condicionais anteriores, então exibe que é numero
    mov ah, 9
    lea dx, sim
    int 21h

    ;salta para o fim
    jmp FIM

    ;Label de Não é número
    NAOENUMERO:
        ;mostra a mensagem de que não é número
        mov ah, 9
        lea dx, nao
        int 21h

    ;Label do FIM
    FIM:
        ;encerra o programa
        mov ah, 4Ch
        int 21h

MAIN endp
END MAIN

;Salto incondicional é apenas JMP
;Salto condicional usa CMP antes e depois j