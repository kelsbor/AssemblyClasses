title entrada binário
.model small
.code
main PROC
           mov  ah, 1      ; função ler caracter
           xor  bx, bx     ; zera bx
           mov  cx, 16     ; contador com valor de 16 para deslocar no máximo 16 bits.

    input: 
           int  21h        ; le o caracter
           cmp  al, 13     ;verifica se é CR e finaliza o programa
           je   output
           and  al, 0Fh    ; converte caracter para valor numérico
           shl  bx, 1      ;desloca bx para esquerda em 1 bit
           or   bl, al     ; adiciona o valor
           loop input

    output:
           mov  ah, 4ch    ;finaliza o programa
           int  21h

main ENDP
end main