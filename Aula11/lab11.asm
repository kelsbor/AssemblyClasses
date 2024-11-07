title Saída-Entrada em qualquer base
; Consertar entrada decimal e saída decimal

; Macro para zerar registrador
zerar MACRO reg
    xor reg,reg
ENDM

; Macro para imprimir string
imprimir_string MACRO string
    mov ah, 9
    lea dx, string
    int 21h
ENDM

; Macro para imprimir caracter
imprimir_caracter MACRO caracter
    mov ah, 2
    mov dl, caracter
    int 21h
ENDM

; Macro para função de ler caracter
ler_caracter MACRO
    mov ah, 1
    int 21h
ENDM

.model small
.stack 0100h
.data
    ; Mensagens do programa
    msg_entrada db "Digite a base de entrada do numero: (1) Binario / (2) Hexadecimal / (3) Decimal",10,13,"$"
    msg_saida db 10,13,"Digite a base de saida do numero: (1) Binario / (2) Hexadecimal / (3) Decimal",10,13,"$"
    msg_decimal db 10,13, "Digite primeiro o sinal (+ ou -) e depois o numero: ",10,13,"$"
    msg_numero db 10,13,"Digite o numero: ",10,13,"$"
    msg_hexadecimal db 10,13,"Digite as letras em maiusculo!",10,13,"$"
    msg_resultado db 10,13, "O resultado da conversao e: ",10,13,"$"

    ; Variaveis do programa
    base_entrada db ?
    base_saida db ?
    total_dec dw ?
    num_negativo db ?
.code

; Procedimento responsavel por ler as variaveis que serao utilizadas: Entrada, saida.
ler_variaveis PROC
    
    ; Requisita qual entrada o usuario deseja e move para variavel
    imprimir_string msg_entrada
    ler_caracter
    and al, 0Fh
    mov base_entrada, al

    ; Requisita qual saida o usuario deseja e move para variavel
    imprimir_string msg_saida
    ler_caracter
    and al, 0Fh
    mov base_saida, al

ret
ler_variaveis ENDP


entrada PROC
    ; Verifica qual foi a base escolhida pelo usuario e redireciona a execução
    cmp base_entrada, 1
    je e_binario

    cmp base_entrada, 2
    je e_hexadecimal

    cmp base_entrada, 3
    je e_decimal

    ; Entrada em binario e armazena o numero em bx
    e_binario:
        zerar bx
        zerar cx
        imprimir_string msg_numero
        entrada_binario:
            ler_caracter
            and al, 0Fh  ; Transforma o caracter em numero
            cmp al, 13     ; Se for CR finaliza
                je final1
            shl bx, 1    ; Desloca bx para armazena ou 1 ou 0
            or  bl, al
            inc cx      
            jmp entrada_binario

        final1:
        jmp final

    ; Entrada em hexadecimal e armazena em bx
    e_hexadecimal:
        zerar bx
        mov cx, 4   ; Repete para os 4 caracteres inseridos
        imprimir_string msg_hexadecimal
        imprimir_string msg_numero
        entrada_hexadecimal:
            ler_caracter
            cmp al, 13      ; Se for CR finaliza
            je final2

            cmp al, 39h     ; Verifica se o caracter é letra ou numero
            jb menor_que_10
            
            sub al, 55      ; Se for letra, converte para o numero correspondente
            shl bx, 4       ; Desloca em 4 bits bx e armazena o valor
            or  bl, al  

            diminui_h:  
                dec cx      ; Verifica a contagem, se for 0 finaliza.
                cmp cx, 0
                je final2
                jmp entrada_hexadecimal

            menor_que_10:
            and al, 0Fh     ; Converte para numero 
            shl bx, 4       ; Se for letra, converte para o numero correspondente    
            or  bl, al      ; Desloca em 4 bits bx e armazena o valor
            jmp diminui_h


        final2:
        jmp final

    ; Realiza entrada em decimal
    e_decimal:
        zerar bx  ; Registrador de armazenamento
        imprimir_string msg_decimal
        imprimir_string msg_numero   

        ; Verifica se o caracter e negativo ou nao
        ler_caracter
        cmp al, '-' 
        je negativo

            entrada_decimal:
                ler_caracter
                cmp al, 13  ; Compara caracter com CR
                je final3
                and ax, 0Fh ; Transforma em numero binario
                push ax     ; salva o valor binario
                mov ax, 10  ; ax multiplica bx (total), resultado em ax
                mul bx
                pop bx      ; valor binario em bx
                add bx, ax  ; valor binario + total em ax = bx
                jmp entrada_decimal

        negativo:
            ; Indica que o caracter e negativo
            mov num_negativo, 1
            jmp entrada_decimal

    final3:
        ; Verifica se e negativo
        cmp num_negativo, 1
        jne final
        
        negar:
            neg bx  ; Realiza o complemento de 2 do numero (Torna negativo)

    final:
    ret
entrada ENDP

saida PROC
    ; Verifica qual saida foi escolhida pelo usuario
    cmp base_saida, 1
    je s_binario

    cmp base_saida, 2
    je s_hexadecimal

    cmp base_saida, 3   
    je s_decimal

    ; Saida em binario
    s_binario:
        mov cx, 16 ; Repete para os 16 bits
        imprimir_string msg_resultado
        saida_binario:
            ; Desloca o bx para verificar o carry bit, se for 1 printa '1', se 0 printa '0'
            rol bx, 1      
            jc um
            imprimir_caracter '0'
            decrementab:
                ; Decrementa cx
                dec cx
                cmp cx, 0
                je encerra1
                jmp saida_binario
            um:
                imprimir_caracter '1'
                jmp decrementab
    encerra1:
        jmp encerra
    
    ; Saida hexadecimal
    s_hexadecimal:
        imprimir_string msg_resultado
        
        mov cx, 4   ; Repete para os 4 numeros hexadecimais
         
        zerar dx    ; Zera dx
        mov ah, 2

        saida_hexadecimal:
            mov dl, bh  
            shr dl, 4   ; Pega o nibble
            cmp dl, 10  ; Verifica se é maior ou menor que 10. Se sim, printa Letra. Caso contraio, numero.
            jb numero_hexa
            add dl, 37h  ; Transforma em caracter letra
            int 21h

            decrementah:
                shl bx, 4   ; Desloca bx em 4 bits para esquerda para pegar o proximo nibble
                dec cx      ; Decrementa e se for zero finaliza
                cmp cx, 0   
                je encerra
                jmp saida_hexadecimal
            numero_hexa:
                add dl, 30h    ; Transforma em caracter numerico
                int 21h
                jmp decrementah
    
    ; Saida Decimal
    s_decimal:
        imprimir_string msg_resultado
        ; Zera os registradores e move bx para ax. E usa bx como divisor (10)
        zerar ax
        mov ax,bx
        mov bx, 10
        zerar cx
        zerar dx
        zerar si
        zerar di
        
        ; Verifica se o numero é negativo
        test ax,ax     ; 
        jns positive    ; Se a Signal Flag for zero pula para positivo

        ; Trata quando o numero e negativo
        neg ax       ; Nega bx para transformar em positivo e printar
        push ax      ; Salva ax
        imprimir_caracter '-'
        pop ax

        positive:
            cmp ax,0        ; Se o quociente for 0 termina o programa
            je exibir_decimal
            zerar dx        ; Zera o valor de dx para evitar interferencias.
            div bx          ; Divide ax. Quociente em ax, resto em dx.
            push dx         ; Salva o resto.
            inc cx          
            zerar dx        ; Zera dx para realizar a proxima divisao.
            jmp positive
        
        exibir_decimal:
            pop dx          ; Retorna o resto salvo na ordem inversa, compondo assim o numero em decimal.
            add dx, 30h     ; Transforma em caracter numerico
            imprimir_caracter dl
            loop exibir_decimal
    
    encerra:
    ret
saida ENDP

main PROC
    ; Inicializa o segmento de dados
    mov ax, @data
    mov ds, ax

    ; Chama os procedimentos de leitura, entrada e saida.
    call ler_variaveis
    call entrada
    call saida
    
    ; Finaliza o programa
    mov ah,4ch
    int 21h
main ENDP
end main
