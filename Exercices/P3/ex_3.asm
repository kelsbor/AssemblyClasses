title matrix-transpose 2x2
.model small
.stack 0100h
.data
    matrix db 1,2
           db 5,6
.code

main PROC
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; call procedures 
    call transpose
    call print_matrix
    mov ah, 4ch 
    int 21h
main ENDP

transpose PROC
    xor si,si
    xor di,di
    mov cx, 2
    ; change positions of matrix
    transpose_loop:
    mov bl, matrix[di]
    xchg bl, matrix[si]
    mov matrix[di], bl
    add si, 2
    inc di
    loop transpose_loop
    ret
ENDP

; print the numbers in the matrix
print_matrix PROC
    xor bx,bx
    cld
    lea si, matrix
    mov cx, 4
    mov ah, 2
    print_loop:
    lodsb
    or al, 30h
    mov dl, al
    int 21h
    inc bx
    cmp bx, 2
    jne pass
    mov dl, 10
    int 21h
    pass:
    loop print_loop
    ret
ENDP

END main