title ler diagonal da matrix
.model small
.stack 0100h
.data
    matriz db 1,2,3
           db 9,9,7
           db 5,4,9
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
    mov cx, 3  ; Tres repetições
    
    linha:
        add dl, matriz[bx + si]
        inc bx
        add si, 3
        loop linha

    mov bl,10
    xor ax,ax
    mov al,dl
    conversao:
        cmp al,0
        je printa
        div bl
        push ax
        inc cx
        xor ah,ah
        jmp conversao
    
    printa:
        mov ah,2
        desempilha:
            pop dx
            xchg dl,dh
            or dl,30h
            int 21h
            loop desempilha
    ret
printdiag ENDP
end main