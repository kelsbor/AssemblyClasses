title max-min array
.model small
.stack 0100h
.data
    list dw 5,2,3,4,5,1,7,8,9,4
    max db 'Maximum value: ',10,13,'$'
    min db 10,13,'Minimum value: ',10,13,'$'
.code
; Find the maximum and mininum value of list array 
main PROC
    mov ax, @data
    mov ds, ax
    mov es, ax

    mov ah, 9
    lea dx, max
    int 21h
    call minimum
    mov ah, 9
    lea dx, min
    int 21h
    call maximum
    mov ah, 4ch
    int 21h
main ENDP

; Search for the lowest value in an array
; Uses cx as counter and dx to store the mininum number 
minimum PROC
    mov cx, 9
    cld
    lea si, list
    lodsw
    mov dx,ax ; save the first value in dx

    searchmin:
        lodsw
        cmp ax, dx
        jge greater
        mov dx, ax
        greater:
        loop searchmin

    or dx, 30h
    mov ah, 2
    int 21h
    ret
ENDP

; Search for the highest value in an array
maximum PROC
    cld
    mov cx, 9 
    lea si, list
    lodsw
    mov dx, ax ; save the first value in dx

    ; loop throught the array comparing the elements to find the highest
    searchmax:
        lodsw
        cmp ax, dx
        jle less    ; jump if the number is lower than the actual highest
        mov dx, ax
        less:
        loop searchmax
    
    or dx, 30h
    mov ah, 2
    int 21h
    ret
maximum ENDP
END main
