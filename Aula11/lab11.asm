title Saída-Entrada em qualquer base
; Consertar entrada decimal e saída decimal

zerar MACRO reg
    xor reg,reg
ENDM

imprimir_string MACRO string
    mov ah, 9
    lea dx, string
    int 21h
ENDM

imprimir_caracter MACRO caracter
    mov ah, 2
    mov dl, caracter
    int 21h
ENDM

ler_caracter MACRO
    mov ah, 1
    int 21h
ENDM



.model small
.data
    msg_base db "Digite a base de entrada do numero: (1) Binario / (2) Hexadecimal / (3) Decimal",10,13,"$"
    msg_saida db 10,13,"Digite a base de saida do numero: (1) Binario / (2) Hexadecimal / (3) Decimal",10,13,"$"
    msg_decimal db 10,13, "Digite primeiro o sinal (+ ou -) e depois o numero: ",10,13,"$"
    msg_numero db 10,13,"Digite o numero: ",10,13,"$"
    msg_hexadecimal db 10,13,"Digite as letras em maiusculo!",10,13,"$"
    msg_resultado db 10,13, "O resultado da conversao e: ",10,13,"$"

    base_entrada db ?
    base_saida db ?
    comprimento_numero dw ?
.code


ler_variaveis PROC

    imprimir_string msg_base
    ler_caracter
    and al, 0Fh
    mov base_entrada, al

    imprimir_string msg_saida
    ler_caracter
    and al, 0Fh
    mov base_saida, al

ret
ler_variaveis ENDP


entrada PROC
    cmp base_entrada, 1
    je e_binario

    cmp base_entrada, 2
    je e_hexadecimal

    cmp base_entrada, 3
    je e_decimal

    e_binario:
        zerar bx
        zerar cx
        imprimir_string msg_numero
        entrada_binario:
            ler_caracter
            and al, 0Fh
            cmp al, 13
                je final1
            shl bx, 1
            or  bl, al
            inc cx
            jmp entrada_binario

        final1:
        jmp final

    e_hexadecimal:
        zerar bx
        mov cx, 4
        imprimir_string msg_hexadecimal
        imprimir_string msg_numero
        entrada_hexadecimal:
            ler_caracter
            cmp al, 13
            je final2

            cmp al, 39h
            jb menor_que_10
            
            sub al, 55
            shl bx, 4
            or  bl, al

            diminui_h:
                dec cx
                cmp cx, 0
                je final2
                jmp entrada_hexadecimal

            menor_que_10:
            and al, 0Fh
            shl bx, 4
            or  bl, al
            jmp diminui_h


        final2:
        jmp final

    e_decimal:
        mov cl,10
        zerar bx
        imprimir_string msg_decimal
        imprimir_string msg_numero

        ler_caracter
        cmp al, '-'
        je negativo

            entrada_decimal:
                ler_caracter
                cmp al, 13
                je final
                zerar ah
                and al, 0Fh
                xchg bl,al
                imul cl
                xchg bl,al
                add bl,al
                jmp entrada_decimal

        negativo:
            mov si, 1
            jmp entrada_decimal

    final3:
        cmp si, 1
        jne final
        
        negar:
            neg bx

    final:
    ret
entrada ENDP

saida PROC
    cmp base_saida, 1
    je s_binario

    cmp base_saida, 2
    je s_hexadecimal

    cmp base_saida, 3   
    je s_decimal

    s_binario:
        mov cx, 16
        imprimir_string msg_resultado
        saida_binario:
            rol bx, 1
            jc um
            imprimir_caracter '0'
            decrementab:
                dec cx
                cmp cx, 0
                je encerra
                jmp saida_binario
            um:
                imprimir_caracter '1'
                jmp decrementab
    
    s_hexadecimal:
        imprimir_string msg_resultado
        
        mov cx, 4
        mov ah, 2
        zerar dx

        saida_hexadecimal:
            mov dl, bh
            shr dl, 4
            cmp dl, 10
            jb numero_hexa
            add dl, 37h
            int 21h

            decrementah:
                shl bx, 4
                dec cx
                cmp cx, 0
                je encerra
                jmp saida_hexadecimal
            numero_hexa:
                add dl, 30h
                int 21h
                jmp decrementah
                
    s_decimal:
        imprimir_string msg_resultado
        mov ax,bx
        mov bx, 10
        zerar cx
        zerar dx
        
        ; Check if the number in BX is negative
        test ax,ax     ; Perform bitwise AND with itself to set flags
        jns positive    ; If the sign flag is not set, jump to positive

        ; Handle negative case
        neg ax       ; Negate BX to make it positive if needed
        imprimir_caracter '-'

        positive:
            cmp ax,0
            je exibir_decimal
            div bx
            push dx
            inc cx
            jmp positive
        
        exibir_decimal:
            pop dx
            add dx, 30h
            imprimir_caracter dl
            loop exibir_decimal
    
    encerra:
    ret
saida ENDP

main PROC
    mov ax, @data
    mov ds, ax

    call ler_variaveis
    call entrada
    call saida
 
    mov ah,4ch
    int 21h
main ENDP
end main
