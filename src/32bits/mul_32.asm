section .text
    global MUL_32

MUL_32:

        push op1_msg_size
        push op1_msg
        call print_string

        ;read integer 32 bits (return value in eax)
        call read_number_32
        ;push eax (store first operand value)
        ; PutLInt eax
        push eax

        push op2_msg_size
        push op2_msg
        call print_string

        ;read integer 32 bits (return value in eax)
        call read_number_32
        ; PutLInt eax
        mov ebx,eax

        pop eax

    imul eax,ebx
    jo overflow_32_mul
    jmp print_result_mul_32

    overflow_32_mul:
        push overflow_msg_size
        push overflow_msg
        call print_string
        mov eax,1   ; used for checking if overflow occurred
        ret


    print_result_mul_32:

        call print_result_msg            ; macro used for printing the "heres's the result" message

        push eax                    ; pushing integer to be printed
        call print_number_32

        call new_line_macro              ; macro for printing newline
        mov eax,0

        ret
