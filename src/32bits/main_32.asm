%include 'sum_32.asm'
%include 'sub_32.asm'
%include 'mul_32.asm'
%include 'div_32.asm'
%include 'exp_32.asm'
%include 'mod_32.asm'
%include 'IO.asm'

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

overflow_msg db 'OCORREU OVERFLOW',0dh,0ah
overflow_msg_size EQU $-overflow_msg

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
    mov dword [menu_option],eax

    ;calls appropriate function
    op1:
    mov eax,1
    cmp eax,[menu_option]
    jne op2
    call SUM_32
    jmp thirty_two_bits_mode

    op2:
    mov eax,2
    cmp eax,[menu_option]
    jne op3
    call SUB_32
    jmp thirty_two_bits_mode

    op3:
    mov eax,3
    cmp eax,[menu_option]
    jne op4
    call MUL_32
    ; check for overflow
    cmp eax,1
    ; if it didn't happen, continue execution
    jne thirty_two_bits_mode
    ; if overflow happened, close program
    jmp CLOSE

    op4:
    mov eax,4
    cmp eax,[menu_option]
    jne op5
    call DIV_32
    jmp thirty_two_bits_mode

    op5:
    mov eax,5
    cmp eax,[menu_option]
    jne op6
    call EXP_32
    ; check for overflow
    cmp eax,1
    ; if it didn't happen, continue execution
    jne thirty_two_bits_mode
    ; if overflow happened, close program
    jmp CLOSE

    op6:
    mov eax,6
    cmp eax,[menu_option]
    jne op7
    call MOD_32
    jmp thirty_two_bits_mode

    op7:
    mov eax,7
    cmp eax,[menu_option]
    je CLOSE
    jmp thirty_two_bits_mode


CLOSE:

    mov eax,1
    mov ebx,0
    int 80h





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

