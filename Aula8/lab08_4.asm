title saida hexadecimal
.model small
.code
main proc
               mov bx, 9b3h      ; armazena o número em bx
               mov ah, 2         ; função para printar os caracteres
               mov cx, 4         ; contador em 4 para rotacionarmos pelos 2 bytes

    printar:   
               mov dl, bh        ; move a primeira parte para dl
               shr dl, 4         ; desloca o byte para direita, restando o nibble que terá o valor entre 0 e 15
               cmp dl, 10        ; dessa forma, comparamos com 10 para verificar se iremos printar um numero ou uma letra.
               jb  numero
               add dl, 37h       ; converte o numero para caracter Letra
               int 21h           ; printa

    decrementa:
               shl bx,4          ; movemos bx para printarmos o proximo nibble
               dec cx            ; realizamos a contagem
               cmp cx,0          ; se cx for zero finalizamos o programa
               je  fim
               jmp printar       ; retorna o ciclo

    numero:    
               or  dl, 30h       ; converte o numero para caracter numérico
               int 21h           ; printa
               jmp decrementa    ; realiza a contagem
    
    fim:       
               mov dl, 'h'       ; printa o h no final, simbolizando que se trata de um hexademinal
               int 21h
               mov ah, 4ch       ; finaliza o programa
               int 21h
main ENDP
end main