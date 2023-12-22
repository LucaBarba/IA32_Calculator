;read the two operands used in the selected operation, printing the required prompts
%macro read_operands 2
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
    mov %2,eax

    pop %1

%endmacro

%macro print_result_msg 0

    push result_msg_size
    push result_msg
    call print_string

%endmacro

%macro new_line_macro 0

    push new_line_size
    push new_line

    call print_string

%endmacro



section .data

negativo db '-'
len_negativo EQU $-negativo

welcome_msg db 'Bem-vindo. Digite seu nome:',0dh,0ah
welcome_msg_size EQU $-welcome_msg

hello_msg_1 db 'Hola, '
hello_msg_1_size EQU $-hello_msg_1

hello_msg_2 db ', bem-vindo ao programa de CALC IA-32',0dh,0ah
hello_msg_2_size EQU $-hello_msg_2

precision_msg db 'Vai trabalhar com 16 ou 32 bits (digite 0 para 16, e 1 para 32):',0dh,0ah
precision_msg_size EQU $-precision_msg

menu_msg_1 db 'ESCOLHA UMA OPÇÃO:',0dh,0ah
menu_msg_1_size EQU $-menu_msg_1

menu_msg_2 db '- 1: SOMA',0dh,0ah
menu_msg_2_size EQU $-menu_msg_2

menu_msg_3 db '- 2: SUBTRACAO',0dh,0ah
menu_msg_3_size EQU $-menu_msg_3

menu_msg_4 db '- 3: MULTIPLICACAO',0dh,0ah
menu_msg_4_size EQU $-menu_msg_4

menu_msg_5 db '- 4: DIVISAO',0dh,0ah
menu_msg_5_size EQU $-menu_msg_5

menu_msg_6 db '- 5: EXPONENCIACAO',0dh,0ah
menu_msg_6_size EQU $-menu_msg_6

menu_msg_7 db '- 6: MOD',0dh,0ah
menu_msg_7_size EQU $-menu_msg_7

menu_msg_8 db '- 7: SAIR',0dh,0ah
menu_msg_8_size EQU $-menu_msg_8

op1_msg db 'Digite primeiro operador:',0dh,0ah
op1_msg_size EQU $-op1_msg

op2_msg db 'Digite segundo operador:',0dh,0ah
op2_msg_size EQU $-op2_msg

result_msg db 'O resultado eh: ',0dh,0ah
result_msg_size EQU $-result_msg

new_line db 0dh, 0ah
new_line_size EQU $-new_line

minus db '-'
minus_size EQU $-minus

section .bss

user_name resb 30   ;max de 30 caracteres para nome
precision resb 1
menu_option resd 1

section .text
global _start:

_start:

;print welcome
mov eax,4
mov ebx,1
mov ecx,welcome_msg
mov edx,welcome_msg_size
int 80h

;take user's name
mov eax,30
push eax
push user_name
call read_string

;print helllo message
mov eax,4
mov ebx,1
mov ecx,hello_msg_1
mov edx,hello_msg_1_size
int 80h

;print user's name
mov eax,4
mov ebx,1
mov ecx,user_name
sub edx,edx
find_length:                ;find length of user's name
    cmp byte [ecx + edx], 0 ; check for null terminator
    je  print_username
    inc edx
    jmp find_length
print_username:
    sub edx,1   ;removes \n to print correctly
    int 80h

;print helllo message
mov eax,4
mov ebx,1
mov ecx,hello_msg_2
mov edx,hello_msg_2_size
int 80h



thirty_two_bits_mode:



    ;prints menu message
    call print_menu
    
    call read_number_32
    ; GetLInt eax         ; APLICAR FUNCAO DESENVOLVIDA PRA PEGAR INTEIRO
    mov dword [menu_option],eax

    ;calls appropriate function
    mov eax,1
    cmp eax,[menu_option]               ;menu_option atualmente eh WORD MAS ESTAMOS TRATANDO COMO BYTE
    je SUM_32

    mov eax,2
    cmp eax,[menu_option]
    je SUB_32

    mov eax,3
    cmp eax,[menu_option]
    je MUL_32

    mov eax,4
    cmp eax,[menu_option]
    je DIV_32

    mov eax,5
    cmp eax,[menu_option]
    je EXP_32

    mov eax,6
    cmp eax,[menu_option]
    je MOD_32

    mov eax,7
    cmp eax,[menu_option]
    je CLOSE

    jmp thirty_two_bits_mode

CLOSE:

    mov eax,1
    mov ebx,0
    int 80h



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




read_number_32:

    enter 2,0  ;reserves 1 byte for reading characters, and 1 byte for a flag (in case of negative number, set to 1)

    mov ebx,0   ;stores result
    push ebx

    lea ecx,[EBP]
    sub ecx,2
    mov byte[ecx],'0'

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

        pop ebx
        imul ebx,ebx,10

        add ebx,[eax]

        push ebx
            
        ; inc esi

        jmp loop_read_int


    finish_integer_conversion:

        check_negative:

            pop ebx
            
            lea ecx,[EBP]
            sub ecx,2

            cmp byte[ecx],'1'
            jne no_negation

            not ebx                 ; Negate the result for negative numbers
            add ebx,1

        no_negation:
            mov eax, ebx            ; Move the result to EAX


    leave
    ret




print_number_32:

    enter 11, 0

    mov eax, [ebp+8]    ;loads input into eax

    ; teste if negative
    test eax, eax
    jns setup_int_print_loop
        not eax
        add eax, 1

        ; prints '-'
        push minus_size
        push minus
        call print_string

        setup_int_print_loop:

            ; initialize iterator
            mov esi, 1
        
        loop_convert_int:

            ; gets the remainder from the division of the orinigal value by 10
            ; eax = Numerator
            mov edx,0           ; Clear the high 32 bits of the dividend (initialize remainder to 0)
            mov ebx,10          ; Denominator
            div ebx             ; EAX = EAX / EBX (quotient), EDX = EAX % EBX (remainder)
            ; edx gets value%10

            ; converts to ASCII
            add edx,0x30

            inc esi
            ; salvar o dígito na memória
            lea ebx,[ebp]
            sub ebx,esi
            mov [ebx], dl
        
            cmp eax, 0
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
    ret 4


print_menu:

    pusha

    push menu_msg_1_size
    push menu_msg_1
    call print_string

    push menu_msg_2_size
    push menu_msg_2
    call print_string

    push menu_msg_3_size
    push menu_msg_3
    call print_string

    push menu_msg_4_size
    push menu_msg_4
    call print_string

    push menu_msg_5_size
    push menu_msg_5
    call print_string

    push menu_msg_6_size
    push menu_msg_6
    call print_string

    push menu_msg_7_size
    push menu_msg_7
    call print_string

    push menu_msg_8_size
    push menu_msg_8
    call print_string


    popa

    ret


SUM_32:

    read_operands eax,ebx       ; macro used for reading two inputs (eax and ebx in this case)
    add eax,ebx
    
    print_result_msg            ; macro used for printing the "heres's the result" message

    push eax                    ; pushing integer to be printed
    call print_number_32

    new_line_macro              ; macro for printing newline

    jmp thirty_two_bits_mode    ; returns to menu

SUB_32:




    jmp thirty_two_bits_mode

MUL_32:




    jmp thirty_two_bits_mode

DIV_32:




    jmp thirty_two_bits_mode

EXP_32:




    jmp thirty_two_bits_mode

MOD_32:




    jmp thirty_two_bits_mode
