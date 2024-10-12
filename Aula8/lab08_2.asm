title saida binário
.model small
.code
main proc
               mov bx, 2348      ; bx armazena o valor que será exibido
               mov ah, 2         ; função para printar caracteres
               mov cx, 16        ; contador em 16 para rotacionar pelos 16 bits do registrador.

    rotacao:   
               ROL bx, 1         ; rotaciona bx em 1 bit.
               jc  um            ; se o carry bit for 1, printa 1.
        
               mov dl, '0'       ; caso contrário, printa '0'
               int 21h

    decrementa:
               dec cx            ;decrementa o contador
               cmp cx, 0         ; verifica se é zero. Se sim, finaliza o programa, caso contrario continua.
               je  fim
               jmp rotacao
        
    um:        
               mov dl, '1'       ; printa o caracter '1'
               int 21h
               jmp decrementa

    fim:       
               mov ah, 4ch       ; finaliza o programa
               int 21h
main ENDP
end main