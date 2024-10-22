TITLE Manipulação de Vetores usando BX
.MODEL SMALL
.DATA
    VETOR DB 1, 1, 1, 2, 2, 2
.CODE
MAIN PROC
          mov  AX, @DATA    ; inicializa o segmento de dados
          mov  DS,AX

          mov  CX,6         ; contador com valor 6
          lea  SI, VETOR    ; aponta para o primeiro endereço do VETOR no registrador SI
          mov  AH, 02       ; função para printar caracter
    
    VOLTA:
          mov  DL, [SI]     ; move para dl, o conteudo do primeiro endereço do VETOR
          inc  SI           ; incrementa bx para apontar o próximo endereço.
          add  DL, 30H      ; transforma o número em caractere
          
          int  21H          ; printa o caracter em dl
          loop VOLTA        ; repete 6 vezes

          mov  AH,4CH
          int  21H          ; finalização do programa
MAIN ENDP
END MAIN
