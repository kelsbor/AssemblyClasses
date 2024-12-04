title verify number
.model small
.stack 0100h
.data
    numeros db 1,20,7,94,14,23,15,16,10,19

.code

;description
main PROC
    mov ax, @data
    mov ds, ax
    mov es, ax

    call verify15

    mov ah, 4ch
    int 21h
main ENDP

verify15 PROC
    xor dl, dl
    mov cx, 10
    mov bl, 15 ; numero a ser comparado
    lea si, numeros
    cld

    verify:
        lodsb
        cmp al, bl
        jbe lower
        inc dl
        lower:
        loop verify
    
    mov ah, 2
    or dl, 30h
    int 21h
    ret
ENDP

END main
