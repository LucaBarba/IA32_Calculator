section .text
    global DIV_16

DIV_16:

        push op1_msg_size
        push op1_msg
        call print_string

        ;read integer 16 bits (return value in eax)
        call read_number_16
        ;push eax (store first operand value)
        ; PutLInt eax
        push ax

        push op2_msg_size
        push op2_msg
        call print_string

        ;read integer 16 bits (return value in eax)
        call read_number_16
        ; PutLInt eax
        mov bx,ax

        pop ax

    ; add eax,ebx

    ; eax = Numerator
    mov dx,0           ; Clear the high 32 bits of the dividend (initialize remainder to 0)
    ; ebx = Denominator
    idiv bx             ; EAX = EAX / EBX (quotient), EDX = EAX % EBX (remainder)
    ; edx gets Numerator % Denominator

    

    call print_result_msg            ; macro used for printing the "heres's the result" message

    push ax                    ; pushing integer to be printed
    call print_number_16

    call new_line_func              ; macro for printing newline

    ret
