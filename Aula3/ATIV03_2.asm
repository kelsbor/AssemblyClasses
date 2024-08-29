title numero-letra-naosei
.model small
.stack 100h
.data 
    msg1 db "Digite um caractere: $"
    num db 10,13,"O caractere digitado e um numero.$"
    letra db 10,13,"O caractere digitado e uma letra.$"
    desconhecido db 10,13,"O caractere digitado e desconhecido.$"

.code
main proc
    ;inicializar segmento de dados
    mov ax, @data
    mov ds, ax

    ;printar a msg1 com função 9
    mov ah, 9
    mov dx, offset msg1
    int 21h

    ;armazenar caractere digitado em al
    mov ah, 1
    int 21h

    ;move o caracter de al para bl
    mov bl, al
    
    ;compara o valor entre bl e 30h
    cmp bl,30h
    ;se ele for menor que 30h (onde iniciam os numeros) será desconhecido.
    jb DESCONHECE

    ;comparar o valor com 39h(onde acabam os numeros)
    cmp bl, 39h
    ;se for igual ou menor que 39h será número.
    jbe NUMERO

    ;compara o valor com 41h (onde começam letras maiusculas).
    cmp bl, 41h
    ;se for menor que 41h, serão caracteres desconhecidos.
    jb DESCONHECE

    ;compara bl com 5Ah (onde terminam as letras)
    cmp bl, 5Bh
    ;se for menor ou igual, serão letras maiusculas.
    jbe LETRAS

    ;compara bl com 61h (onde temos letras minusculas)
    cmp bl, 61h
    ;se for menor, serão caracteres desconhecidos.
    jb DESCONHECE

    ;compara bl com 7Ah (onde terminam as letras minusculas)
    cmp bl, 7Ah
    ;se for menor ou igual, serão letras
    jbe LETRAS
    
    ;compara bl com 7Ah
    cmp bl, 7Ah
    ;se for maior os caracteres serão desconhecidos.
    ja DESCONHECE

    DESCONHECE:
        ;printa o string desconhecido e pula para a LABEL FIM
        mov ah, 9
        lea dx, desconhecido
        int 21h
        jmp FIM

    NUMERO:
        ;printa o string num e pula para a LABEL FIM
        mov ah, 9
        lea dx, num
        int 21h
        jmp FIM

    LETRAS:
        ;printa o string letra e pula para a LABEL FIM
        mov ah, 9 
        mov dx, offset letra
        int 21h
        jmp FIM

    FIM:
        ;termina o programa
        mov ah, 4Ch
        int 21h
main endp
END main

