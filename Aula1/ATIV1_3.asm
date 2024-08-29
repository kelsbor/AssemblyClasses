Title Vai-volta
.model SMALL
.DATA
    pergunta db "Digite um caractere: $"
    echo db 10,13,"O caractere digitado foi: $"
.CODE
MAIN PROC
    ;permite o acesso das variáveis em .data
    mov ax, @DATA
    mov ds, ax

    ;exibe a mensagem 'pergunta' em dx, através da função 9 do int 21h.
    mov ah, 9
    lea dx, pergunta
    int 21H

    ;le o caracter digitado pelo usuário usando a função 1.
    mov ah, 1
    int 21H

    ;move o caracter do registro Al para bl.
    mov bl, AL
    
    ;exibe a mensagem de retorno
    mov ah, 9
    lea dx, echo
    int 21h

    ;retorna o caracter armazenado em bl, através da função 2.
    mov ah, 2
    mov dl, bl
    int 21h

    ;finaliza o programa, 4ch no registro ah.
    mov ah, 4Ch
    int 21h

    ;line feed (10) e carriage return (13) colocados direto na string 
MAIN ENDP
END MAIN
