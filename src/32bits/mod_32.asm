section .text
    global MOD_32

MOD_32:

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


    ; eax = Numerator
    mov edx,0           ; Clear the high 32 bits of the dividend (initialize remainder to 0)
    ; ebx = Denominator
    div ebx             ; EAX = EAX / EBX (quotient), EDX = EAX % EBX (remainder)
    ; edx gets Numerator % Denominator
    mov eax,edx

    call print_result_msg            ; macro used for printing the "heres's the result" message

    push eax                    ; pushing integer to be printed
    call print_number_32

    call new_line_macro              ; macro for printing newline

    ret
