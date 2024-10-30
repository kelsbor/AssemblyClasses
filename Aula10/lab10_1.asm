title MATRIZ4X4
; macro para zerar o registrador
zerar MACRO reg
          xor reg,reg
ENDM

.model small
.DATA
    ; Matriz 4X4 pre-definida

    MATRIZ4X4 DB 1,2,3,4
              DB 4,3,2,1
              DB 5,6,7,8
              DB 8,7,6,5
.code
    ; Procedimento realiza a impressao da matriz em linhas e colunas.
imprimir PROC
             mov   ah, 2                     ; Função para printar caracteres
             zerar bx                        ; Zera bx, indicador das colunas da matriz.
             zerar si                        ; Zera si, indicador das linhas da matriz.

    printar: 
             cmp   bx,4                      ; Compara bx com 4, para verificar se deve pular de linha.
             je    pular
             mov   dl, MATRIZ4X4[bx + si]    ; Move o elemento da matriz para dl
             or    dl, 30h                   ; Transforma dl em caracter numerico
             int   21h                       ; Printa dl
             inc   bx                        ; Proxima coluna
             jmp   printar

    pular:   
             cmp   si,12                     ; Verfica se está na ultima linha. Se sim, finaliza o programa.
             je    fim
             mov   dl, 10                    ; Pula uma linha.
             int   21h
             add   si,4                      ; Soma si para apontar para a proxima linha.
             zerar bx                        ; Reinicia a coluna
             jmp   printar

    fim:     
             mov   ah, 4CH                   ; Finaliza o programa
             int   21h
imprimir ENDP


main PROC
             mov   ax, @DATA                 ; Inicializa segmento de dados
             mov   ds, ax

             call  imprimir                  ; Chama o procedimento
main ENDP
end main

