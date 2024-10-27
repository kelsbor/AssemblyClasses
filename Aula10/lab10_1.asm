title MATRIZ4X4

zerar MACRO reg
    xor reg,reg
ENDM

.model small
.DATA
    MATRIZ4X4   DB 1,2,3,4
                DB 4,3,2,1
                DB 5,6,7,8
                DB 8,7,6,5
.code
imprimir PROC
    mov ah, 2
    zerar bx
    zerar si

    printar:
        cmp bx,4
        je pular
        mov dl, MATRIZ4X4[bx + si]
        or dl, 30h
        int 21h
        inc bx
        jmp printar

    pular:
        cmp si,12
        je fim
        mov dl, 10
        int 21h
        add si,4
        zerar bx
        jmp printar

    fim:
        mov ah, 4CH
        int 21h
imprimir ENDP


main PROC
    mov ax, @DATA
    mov ds, ax

    call imprimir
main ENDP
end main

