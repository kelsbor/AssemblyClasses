title Saída-Entrada em qualquer base

zerar MACRO reg
    xor reg,reg
ENDM

imprimir_string MACRO string
    mov ah, 9
    lea dx, string
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
    msg_numero db 10,13,"Digite o numero: ",10,13,"$"

    base_entrada db ?
    base_saida db ?
    total db 0
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
        xor bx, bx
        imprimir_string msg_numero
        entrada_binario:
            ler_caracter
            and al, 0Fh
            cmp al, 13
                je final1
            shl bx, 1
            or  bl, al
            jmp entrada_binario

        final1:
        jmp final

    e_hexadecimal:
        xor bx, bx
        imprimir_string msg_numero
        entrada_hexadecimal:
            ler_caracter
            and al, 0Fh
            cmp al, 13
            je final2
            cmp al, 'h'
            je final2
            shl bx, 4
            or  bl, al
            jmp entrada_hexadecimal

        final2:
        jmp final

    e_decimal:
        mov cl,10
        xor bx,bx
        imprimir_string msg_numero

        ler_caracter
        cmp al, '-'
        je negativo

            entrada_decimal:
                ler_caracter
                cmp al, 13
                je final
                xor ah,ah
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
    ret
saida ENDP

main PROC
    mov ax, @data
    mov ds, ax

    call ler_variaveis
    call entrada
    ;call saida
 
    mov ah,4ch
    int 21h
main ENDP
end main
