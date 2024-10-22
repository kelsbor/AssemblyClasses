TITLE Manipulação de Vetores usando BX - versao 2
.MODEL SMALL
.DATA
    VETOR DB 1, 1, 1, 2, 2, 2
.CODE
MAIN PROC
          mov  AX, @DATA        ; inicializa o segmento de dados
          mov  DS,AX

          mov  CX,6             ; contador com valor 6
          mov  AH, 02           ; função para printar caracter
          xor  bx, bx
    VOLTA:
          mov  DL, VETOR[BX]    ; move para dl, o conteudo do primeiro endereço do VETOR
          inc  BX               ; incrementa bx para apontar para o proximo elemento
          add  DL, 30H          ; transforma o número em caractere
          
          int  21H              ; printa o caracter em dl
          loop VOLTA            ; repete 6 vezes

          mov  AH,4CH
          int  21H              ; finalização do programa
MAIN ENDP
END MAIN