section .text
    global MUL_16

MUL_16:

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

    imul ax,bx
    jo overflow_16_mul
    jmp print_result_mul_16

    overflow_16_mul:
        push overflow_msg_size
        push overflow_msg
        call print_string
        mov eax,1   ; used for checking if overflow occurred
        ret


    print_result_mul_16:

        call print_result_msg            ; macro used for printing the "heres's the result" message

        push ax                    ; pushing integer to be printed
        call print_number_16

        call new_line_func              ; macro for printing newline
        mov eax,0   ; used for checking if overflow occurred

        ret
