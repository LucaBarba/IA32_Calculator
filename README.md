# IA32_Calculator

Autores:
| Nome                    | Matrícula  |
|-------------------------|------------|
| Luca Delpino Barbabella | 180125559  |
| Lucca Beserra Huguet    | 160013259  |


32-bit and 16-bit versions of a simple calculator done in assembly IA32. Capable of detecting overflow in multiplication and exponentiation.


## 1. 32-bit version
Inside the 32bit folder, execute the following commands:

### 1.1 Assembling 32b
> nasm -f elf -o CALCULADORA_32.o CALCULADORA_32.asm

### 1.2 Linking 32b
> ld -m elf_i386 -o CALCULADORA_32 CALCULADORA_32.o

### 1.3 Executing 32b
> ./CALCULADORA_32

## 2. 16-bit version
Inside the 16bit folder, execute the following commands:

### 2.1 Assembling 16b
> nasm -f elf -o CALCULADORA_16.o CALCULADORA_16.asm

### 2.2 Linking 16b
> ld -m elf_i386 -o CALCULADORA_16 CALCULADORA_16.o

### 2.3 Executing 16b
> ./CALCULADORA_16
