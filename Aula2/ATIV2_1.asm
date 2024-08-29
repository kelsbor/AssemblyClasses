title Minusculo-Maisculo
.model small 
.data
    msg1 db "Digite uma letra minuscula: $"
    msg2 db 10,13,"A letra maiuscula correspondente eh: $"
.code
main PROC
    ;inicializa a seção de dados em ds
    mov Ax, @data
    mov ds, Ax

    ;Função 9 (int 21h) - exibe a mensagem 1
    mov ah, 9
    lea dx, msg1
    int 21h

    ;Função 1 (int 21h) - le um caracter e armazena em al
    mov ah, 1
    int 21h

    ;Move o valor do registro al para bl
    mov bl, al

    ;Subtrai 20h de bl, que será correspondente ao caracter maisculo desejado
    sub bl, 20h

    ;Função 9 (int 21h) - Exibe a mensagem 2
    mov ah, 9
    lea dx, msg2
    int 21h

    ;Função 2 (int 21h) - Printa o caracter armazenado em bl
    mov ah, 2
    mov dl, bl
    int 21h

    ;Funçaõ 4Ch - Finaliza o programa
    mov ah, 4ch
    int 21h
main ENDP
end main