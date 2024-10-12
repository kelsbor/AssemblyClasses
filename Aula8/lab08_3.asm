title entrada hexadecimal
.model small
.code
main PROC
           mov ah, 1      ; função ler caracter
           xor bx, bx     ; zera bx
           mov cx, 4      ; contador com valor de 4, já que estamos lidando com hexadecimal isso seria equivalente aos 16 bits.

    input: 
           int 21h        ; recebe o caracter em al
           cmp al, 13     ;verifica se é CR para finalizar o programa
           je  output

           dec cx         ; decrementa o valor do contador.
           cmp cx, 0      ; verifica se é 0 para terminar o programa.
           je  output

           cmp al, 39h    ; verifica se o caracter é um numero, se está abaixo de 39h ('9')
           jbe numero
           
           sub al, 55     ; transforma a Letra em valor numerico
           shl bx, 4      ; desloca bx para armazenar o valor em hexadecimal
           or  bl, al     ; soma o valor de al com bl,
           jmp input

    numero:
           and al, 0Fh    ; transforma o caracter no valor numerico
           shl bx, 4      ; desloca bx em 4 bits para armazenar o valor em hexadecimal.
           or  bl, al     ; adiciona o valor em bl
           jmp input
    
    output:
           mov ah, 4ch    ; finaliza o programa
           int 21h

main ENDP
end main