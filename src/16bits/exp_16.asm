section .text
    global EXP_16

EXP_16:

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

    cmp bx,0
    jne test_one_16
    mov eax,1
    jmp print_result_exp_16


    test_one_16:
    cmp bx,1
    je print_result_exp_16

    non_zero_exp:

        mov cx,bx
        dec cx
        mov bx, ax
        loop_exp_16:

            imul ax,bx
            jo overflow_16_exp

        loop loop_exp_16
        jmp print_result_exp_16

    overflow_16_exp:
        push overflow_msg_size
        push overflow_msg
        call print_string
        mov eax,1   ; used for checking if overflow occurred
        ret


    print_result_exp_16:

        call print_result_msg            ; macro used for printing the "heres's the result" message

        push ax                    ; pushing integer to be printed
        call print_number_16

        call new_line_macro              ; macro for printing newline
        mov eax,0   ; used for checking if overflow occurred

        ret
