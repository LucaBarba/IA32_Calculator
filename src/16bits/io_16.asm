section .text





read_operands:

    push op1_msg_size
    push op1_msg
    call print_string

    ;read integer 16 bits (return value in eax)
    call read_number_16
    ;push eax (store first operand value)
    ; PutLInt eax
    push eax

    push op2_msg_size
    push op2_msg
    call print_string

    ;read integer 16 bits (return value in eax)
    call read_number_16
    ; PutLInt eax
    mov ebx,eax

    pop eax

ret

print_result_msg:

    push result_msg_size
    push result_msg
    call print_string

ret

new_line_macro:

    push new_line_size
    push new_line

    call print_string

ret






read_string:

    enter 0,0
    pusha

    mov eax, 3
    mov ebx, 0
    mov ecx, [EBP+8]
    mov edx, [EBP+12]
    int 80h

    popa
    leave

    ret 8

; push first the size, then the address
print_string:


    enter 0,0
    pusha

    mov eax,4
    mov ebx,1
    mov ecx,[EBP+8]
    mov edx,[EBP+12]
    int 80h

    popa
    leave

    ret 8   ;unstack input parameters




read_number_16:

    enter 2,0  ;reserves 1 byte for reading characters, and 1 byte for a flag (in case of negative number, set to 1)

    mov bx,0   ;stores result
    push bx

    lea ecx,[EBP]
    sub ecx,2
    mov byte[ecx],'0'   ; sets negative flag to 0

    ;reads one byte at a time
    loop_read_int:

        lea ecx,[EBP]
        sub ecx,1
        ; mov ecx, byte [EBP-esi]

        mov eax, 3        ; System call number for read
        mov ebx, 0        ; File descriptor for standard input
        mov edx, 1        ; Number of bytes to read
        int 80h

        cmp byte [ecx],10
        je finish_integer_conversion

        ; Check for negative sign
        cmp byte [ecx], '-'
        je treat_negative                ;if negattive number, go to next character

        jmp str_to_int_twos_complement  ;else, transform to integer

    treat_negative:

        push ecx

        lea ecx,[EBP]
        sub ecx,2
        mov byte[ecx],'1'

        pop ecx

        jmp loop_read_int


    str_to_int_twos_complement:

        lea eax,[EBP]
        sub eax,1
        sub byte [eax],0x30

        pop bx
        imul bx,bx,10

        add bx,[eax]

        push bx
            
        ; inc esi

        jmp loop_read_int


    finish_integer_conversion:

        check_negative:

            pop bx
            
            lea ecx,[EBP]
            sub ecx,2

            cmp byte[ecx],'1'
            jne no_negation

            not bx                 ; Negate the result for negative numbers
            add bx,1

        no_negation:
            mov ax, bx            ; Move the result to EAX


    leave
    ret

section .text


print_number_16:

    enter 11, 0

    mov ax, [ebp+8]    ;loads input into eax

    ; teste if negative
    test ax, ax
    jns setup_int_print_loop
        not ax
        add ax, 1

        ; prints '-'
        push minus_size
        push minus
        call print_string

        setup_int_print_loop:

            ; initialize iterator
            mov esi, 0
        
        loop_convert_int:

            ; gets the remainder from the division of the orinigal value by 10
            ; eax = Numerator
            mov dx,0           ; Clear the high 16 bits of the dividend (initialize remainder to 0)
            mov bx,10          ; Denominator
            div bx             ; EAX = EAX / EBX (quotient), EDX = EAX % EBX (remainder)
            ; edx gets value%10

            ; converts to ASCII
            add dx,0x30

            inc esi
            ; salvar o dígito na memória
            lea ebx,[ebp]
            sub ebx,esi
            mov [ebx], dl
        
            cmp ax, 0
            jne loop_convert_int
        
        loop_print_int:

            lea ebx, [ebp]
            sub ebx, esi
            lea eax, [ebx]
            push 1
            push eax
            call print_string
            dec esi
            cmp esi, 0
            jne loop_print_int

    leave
    ret 2
