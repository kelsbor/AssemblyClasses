title counting Letter A
.model small
.data
    vetor db 20 dup(?)
.code
;description
main PROC
    mov ax, @data
    mov ds, ax

    call lerv
    call contar

    mov ah, 4ch
    int 21h
main ENDP

;description
lerv PROC
    xor bx,bx
    mov ah, 1

    ler:
        int 21h
        cmp al, 13
        je final
        mov vetor[bx], al
        inc bx
        jmp ler
        final:
    ret
lerv ENDP

;description
contar PROC
    mov cx,bx
    xor bx,bx
    xor dx,dx
    mov ah, 2

    contando:
        cmp vetor[bx], 'a'
        je adiciona
        inc bx
        jmp retorno
    adiciona:
        inc dh
        inc bx
    retorno:
        loop contando
        
        mov dl, dh
        or dl, 30h
        int 21h
    ret
contar ENDP
end main