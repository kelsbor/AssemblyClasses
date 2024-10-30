title soma de matrizes
.model small
.stack 0100h
.DATA
    matriz db 4 dup(0)
           db 4 dup(0)
           db 4 dup(0)
           db 4 dup(0)
    msg1   db 'Digite um vetor com 16 elementos:',10,13,'$'
    msg2   db 10,13,'A matriz resultante eh: ',10,13,'$'
    msg3   db 10,13,'Soma dos elementos da matriz: $',10,13,'$'
.code

    ;Recebe os valores digitados pelo usuario e coloca na matriz em sequencia.
lerm PROC
              mov  ah, 9
              mov  dx, offset msg1
              int  21h

              mov  cx, 16                 ; Quantidade de elementos da matriz
              mov  ah, 1                  ; Recebe os caracteres em al
              lea  bx, matriz

    ler:      
              int  21h                    ; Recebe caracter em al
              mov  [bx], al               ; Move os caracteres para a matriz
              inc  bx
              loop ler
              ret
lerm ENDP

    ;Printa os elementos para usuario em forma de matriz 4X4
    ;Utiliza bx como indicador de coluna e si como indicador de linha.
printar PROC
              mov  ah, 9                  ; Printa a segunda mensagem
              lea  dx, msg2
              int  21h

              mov  ah, 2                  ; Função para printar caracteres
              xor  bx, bx                 ; Zera bx e si
              xor  si, si
              mov  cx, 16                 ; Repete 16 vezes para os 16 elementos da matriz.

    print:    
              cmp  bx,4                   ; Verifica se bx é 4, para que "salte" para a proxima linha da matriz
              je   linha
              mov  dl, matriz[bx + si]    ; Move o elemento da matriz para dl
              int  21h                    ; Printa o caracter
              inc  bx                     ; vai para a proxima coluna
              dec  cx                     ; Diminui o contador
              jnz  print
              jmp  printado
    linha:    
              add  si,4                   ; Pula para proxima linha
              xor  bx,bx                  ; zera bx para reiniciar a posição da coluna
              mov  dl, 10                 ; Printa um CR para que os caracteres fiquem na linha de baixo.
              int  21h
              jmp  print
    printado: 
              ret
printar ENDP

    ; Soma os elementos da matriz e devolve o resultado.
    ; Utiliza dx como armazenamento da soma da matriz
somar PROC
              mov  ah,9                   ; Printa a terceira mensagem
              lea  dx, msg3
              int  21h

              xor  bx, bx                 ; zera bx, serve como base do vetor
              mov  cx, 16                 ; Quantidade de elementos da matriz a serem somados
              xor  dx,dx                  ; Zera dx, onde é armazenada a soma
              lea  bx, matriz

    somando:  
              mov  al,[bx]
              and  al, 0Fh                ; Transforma o caracter numerico em numero.
              add  dl, al                 ; Soma o resultado em dl
              inc  bx
              loop somando
    
              call saidec
              ret
somar ENDP

    ; Printa o correspondente em decimal de um registrador. Isso através de divisões sucessivas.
    ; Toma como entrada o registrador dx.
saidec PROC
              xor  ax,ax                  ; limpa ax onde armazena resto e quociente.
              mov  al,dl                  ; move o valor que será dividido.
              xor  cx,cx                  ; Contador de elementos na pilha
              mov  bl,10                  ; O divisor é 10.

    conversao:
              cmp  al,0
              je   saida
              div  bl                     ; divide a entrada por 10.
              push ax                     ; Salva o resto e quociente na pilha
              inc  cx                     ; incrementa o contador
              xor  ah,ah                  ; limpa o resto, deixando o quociente para a proxima divisao
              jmp  conversao
    saida:    
              mov  ah,2                   ; Função printar caracter
    decimal:  
              pop  dx                     ; Retoma o ultimo resto e quociente. DX = dh - resto, dl - quociente.
              xchg dh,dl                  ; Passa o valor do resto para dl para que seja printado.
              or   dl,30h                 ; Transforma em caracter numerico
              int  21h
              loop decimal
              ret
saidec ENDP
main PROC
              mov  ax, @DATA              ; Inicializa Segmento de dados
              mov  ds, ax
    
    ; Chama os procedimentos em ordem.
              call lerm
              call printar
              call somar

              mov  ah, 4CH                ; Finaliza o programa
              int  21h
main ENDP
end main
