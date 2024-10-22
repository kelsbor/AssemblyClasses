title Invertendo um Vetor
.model SMALL
.DATA
    VETOR db 4,3,2,7,8,9,1    ; Vetor de sete elementos
.code

    ; Procedimento inverte os numeros do vetor
    ; Entrada: Utiliza BX e SI apontando para elementos do vetor.
    ; CX indica quantas vezes repetimos a inversão (Até o elemento central)
    ; Saída: Inverte o VETOR.

inverter PROC
             xor  bx,bx            ; zera bx, começa pelo primeiro elemento
             mov  si, 6            ; aponta para o ultimo elemento do vetor
             mov  cx, 4
    troca:   
             mov  dh, VETOR[bx]    ; o codigo inverte o conteúdo do vetor
             mov  dl, VETOR[si]    ; entre o primeiro e ultimo elemento.
             mov  VETOR[bx], dl
             mov  VETOR[si], dh
             inc  BX               ; inverte os outros elementos, aumentando BX e decrementando SI
             dec  si
             loop troca            ; repete a lógica até o meio do vetor, o quarto elemento no caso. Por isso, cx = 4
             ret

inverter ENDP

    ; O procedimento printa os elementos de um vetor na ordem crescente.
    ; Entrada: Tem como entrada bx como registrador de base e CX como contador do numero de elementos.
    ; Saída: Printa os elementos do vetor.

printar PROC
             xor  bx,bx            ; zera bx
             mov  cx, 7            ; contador com a quantidade de elementos no vetor
    
    print:   
             mov  dl, VETOR[bx]    ; move o elemento do vetor apontado por bx para dl
             inc  BX               ; incrementa bx, apontando para o proximo elemento
             or   dl, 30h          ; numero para caracter numerico
             int  21h              ; printa o numero
             loop print            ; repete pelos elementos do vetor
             ret
printar ENDP

main PROC
             mov  ax, @DATA        ; inicializa segmento de dados
             mov  ds, ax

             mov  ah, 2            ; função printar caracter
    
             call inverter         ; Chama os procedimentos
             call printar

             mov  ah, 4CH          ; finaliza o programa
             int  21h
main ENDP
end main

