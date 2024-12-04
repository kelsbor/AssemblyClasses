title rotating-vector
.model small
.stack 0100h
.data
    array db 1,2,3,4,5
    rot_array db 5 dup(?)
.code
;description
main PROC
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; Procedure that rotates the array
    mov bx, 2
    rotate_loop:
        cmp bx, 0
        je finish
        call rotate
        dec bx
        jmp rotate_loop
    finish:

    call printarray
    mov ah, 4ch
    int 21h
main ENDP

; Rotate array, number of rotations in cx
rotate PROC
    cld
    mov cx, 4
    lea si, array
    lea di, rot_array + 1

    mov al, array[4]
    rep movsb
    mov rot_array[0], al

    call copyarray
    ret
rotate ENDP

; Print an array
printarray PROC
    cld
    lea si, rot_array
    mov cl, 5

    mov ah, 2
    print:
        lodsb
        or al, 30h
        mov dl, al
        int 21h
        loop print
    ret
printarray ENDP

copyarray PROC
    cld
    mov cx, 5
    lea si, rot_array
    lea di, array
    rep movsb
    ret
copyarray ENDP
END main