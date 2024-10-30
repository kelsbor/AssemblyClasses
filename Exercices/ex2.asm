title ler diagonal da matrix
.model small
.stack 0100h
.data
    matriz db 1,2,3,4
           db 9,8,7,6
           db 5,4,3,2
           db 1,2,3,4
.code
;description
main PROC
    mov ax, @data
    mov ds, ax

    call printdiag

    mov ah, 4CH
    int 21h
main ENDP

;description
printdiag PROC
    xor bx, bx ; Zera bx, indicador de coluna
    xor si, si ; Zera si, indicador de linhas
    xor dx, dx ; Armazenamento da soma
    mov cx, 4  ; Quatro repetições
    mov ah, 2  ; Printa os caracteres

    linha:
        mov dl, matriz[bx + si]
        or dl,30h
        int 21h
        inc bx
        add si, 4
        loop linha
    ret
printdiag ENDP
end main