title Invertendo um Vetor Qualquer!
.model SMALL
.stack 100h
.DATA                                                                
    MSG   db 'Digite qualquer caracter a ser colocado no vetor (maximo 50): ',10,13,'$'
    MSG2  db 10,13,'Ordem inversa do vetor: ',10,13,'$'
    VETOR db 50 DUP(?)     ; Vetor com 30 elementos
    VLEN dw ?              ; Salva o comprimento do vetor
.code

    ;Recebe os valores digitados pelo usuário e coloca-os no VETOR.
ler PROC
             mov  ah, 9            ; Printa a mensagem para o usuário requisitando os valores
             lea  dx, MSG
             int  21h
             
             xor di, di            ; Zera DI
             mov  ah, 1            ; Recebe os caracteres em AL
    LerVetor:
             int  21h
             cmp  al, 13           ; Verifica se ENTER foi pressionado e encerra o vetor
             je   retorno

             mov  VETOR[di], al    ; Move o caracter para uma posição no vetor indicada por DI
             inc  di               ; Proxima posição no VETOR
             jmp  LerVetor
    retorno: 
             ret
ler ENDP

    ; Procedimento inverte os numeros do vetor
    ; Entrada: Utiliza BX e SI apontando para elementos do vetor.
    ; A quantidade de repetições será dada em função de DI que indica quantos elementos tem o vetor.
    ; Isso também dependera se o vetor tem quantidade impar ou par de elementos.
    ; Saída: Inverte o VETOR.

inverter PROC
             xor bx,bx            ; Zera bx, começa pelo primeiro elemento
             mov [VLEN], di         ; Salva o valor de DI na variavel.

             mov  si, di           ; DI representa a quantidade de elementos do vetor.
             dec  si               ; Diminuimos 1 para apontar para que SI aponte para o ultimo elemento do vetor.

             shr  di,1             ; Divide DI por 2 com shift para direita.

             mov  cx, di           ; A metade (quociente) representa a quantidade de inversões necessárias.
                                    ; A quantidade de inversões está em CX, o contador para o loop.
    troca:   
             mov  dh, VETOR[bx]    ; O codigo inverte o conteúdo do vetor
             xchg dh, VETOR[si]    ; entre o primeiro e ultimo elemento.
             mov  VETOR[bx], dh
             inc  BX               ; Inverte os outros elementos, aumentando BX e decrementando SI
             dec  si
             loop troca            ; Repete a lógica até o meio do vetor, o quarto elemento no caso. Por isso, cx = 4
             ret

inverter ENDP


    ; O procedimento printa os elementos de um vetor na ordem crescente.
    ; Entrada: Tem como entrada bx como registrador de base e CX como contador do numero de elementos.
    ; Saída: Printa os elementos do vetor.

printar PROC
             mov  ah, 9            ; Printa a mensagem indicando a ordem inversa do vetor.
             lea  dx, MSG2
             int  21h

             mov  ah, 2
             xor  bx,bx            ; Zera bx, como registrador de base
             
             mov  cx, [VLEN]           ; Retoma a quantidade de elementos no Contador
    
    print:   
             mov  dl, VETOR[bx]    ; Move o elemento do vetor apontado por bx para dl
             inc  BX               ; Incrementa bx, apontando para o proximo elemento
             int  21h              ; Printa o numero
             loop print            ; Repete pelos elementos do vetor
             ret
printar ENDP

main PROC
             mov  ax, @DATA        ; Inicializa segmento de dados
             mov  ds, ax
                                   
             call ler              ; Chama os procedimentos
             call inverter
             call printar

             mov  ah, 4CH          ; Finaliza o programa
             int  21h
main ENDP
end main

