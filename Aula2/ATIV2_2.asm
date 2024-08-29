title
.model small
.data
    msg db 'Digite um numero: $'
    msg1 db 10,13,'Digite outro numero: $'
    msg2 db 10,13,'A soma dos numeros eh: $'
.code 
main PROC
    ;inicializa o segmento de dados
    mov ax, @data
    mov ds, ax

    ;Função 9 (int 21h) - Printa a primeira mensagem
    mov ah, 9 
    mov dx, offset msg
    int 21h

    ;Função 1 (int 21h) - Le um caracter e armazena o caracter em al
    mov ah, 1
    int 21h

    ;move o valor digitado do registro al para bl
    mov bl, al

    ;Retiramos 30h do caracter para que tenha seu valor numérico.
    sub bl, 30h

    ;Função 9 (int 21h) - Exibe a segunda mensagem
    mov ah, 9 
    lea dx, msg1
    int 21h

    ;Função 1 (int 21h) - Armazena o segundo caracter em al
    mov ah, 1
    int 21h

    ;move o valor do segundo caracter para cl.
    mov cl, al
    
    ;Retiramos 30h do caracter para que tenha seu valor numerico.
    sub cl, 30h

    ;Soma o valor dos dois numeros
    add cl,bl
    
    ;Somamos 30h para que corresponda ao caracter somado.
    add cl, 30h

    ;Função 9 (int 21h) - Printa a msg2
    mov ah, 9
    mov dx, offset msg2
    int 21h

    ;Função 2 - Printa o caracter armazenado em cl
    mov ah, 2
    mov dl, cl
    int 21h

    ;Finaliza o programa
    mov ah, 4ch
    int 21h
main ENDP
end main
