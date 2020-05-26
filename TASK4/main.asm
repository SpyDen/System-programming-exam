global _start ; Program start
	_start:
section .data ; Section of initializated data
	green_color db 0x1b, '[32m' ; The string that can change the text color to green
	len_green_color equ $ - green_color ; The lenth of this string
	
	red_color db 0x1b, '[31m' ; The string that can change text color to red (used if user will enter incorrect data)
	len_red_color equ $ - red_color ; The lenth of this string

	help db 'In this program you can read data from a file and change its encoding.', 0xa
	len_help equ $ - help

	msg db 'Please, enter the path to the file: '
	len_msg equ $ - msg

	warning db 'Sorry, but file was not opened! Enter correct path!', 0xa
	len_warning equ $ - warning

	read_info db 'There are read information from the file: '
	len_read_info equ $ - read_info

	endl db 0xa ; \n

	shift db 'Choose what do you want to do with encoding:', 0xa
	len_shift equ $ - shift

	addition db '1. To add entered value.', 0xa
	len_addition equ $ - addition

	substraction db '2. To substract entered value', 0xa
	len_substraction equ $ - substraction

	mes_choice db 'Your choice is: '
	len_mes_choice equ $ - mes_choice

	error db 'You have entered incorrect data! Enter properly!', 0xa
	len_error equ $ - error

	msg_enter_code db 'Please, enter a code that will shift information (use number [1; 126]): '
	len_enter_code equ $ - msg_enter_code

	mes_result db 'There are result of encoding read string from the file: ', 0xa
	len_result equ $ - mes_result

	number dd 0

	ten db 0, 1, 10, 100

	integer dw 0


section .bss ; Section of uninitializated data
	file_descriptor resb 1
	file_path resb 100
	info resb 100
	choice resb 2
	code resb 4
	char resb 1

section .text ; Section of code
		mov edx, len_green_color
		mov ecx, green_color
		call print

		mov edx, len_help
		mov ecx, help
		call print

	enter_path:
		mov edx, len_msg
		mov ecx, msg
		call print

		mov edx, 100
		mov ecx, file_path
		call scan

		mov ecx, -1
	again:
		inc ecx
		cmp [file_path + ecx], byte 0xa
			jne again
		mov [file_path + ecx], byte 0

		mov eax, 5
		mov ebx, file_path
		mov ecx, 0
		mov edx, 0777
		int 0x80

		mov [file_descriptor], eax
		cmp eax, 0
			jg file_is_open

		mov edx, len_red_color
		mov ecx, red_color
		call print

		mov edx, len_warning
		mov ecx, warning
		call print

		mov edx, len_green_color
		mov ecx, green_color
		call print

		jmp enter_path

	file_is_open:
		mov edx, 100
		mov ecx, info
		mov ebx, [file_descriptor]
		mov eax, 3
   		int 0x80
    
   		; Закрываем файл
   		mov eax, 6
   		mov ebx, [file_descriptor]
   		int  0x80    

   		mov edx, len_read_info
   		mov ecx, read_info
   		call print
	
   		; Выводим данные из буфера info 
   		mov edx, 100
		mov ecx, info
   		mov ebx, 1
   		mov eax, 4
   		int 0x80

   		mov edx, 1
   		mov ecx, endl
   		call print



   	make_choice:
   		mov edx, 1
   		mov ecx, endl
   		call print

   		mov edx, len_shift
   		mov ecx, shift
   		call print

   		mov edx, len_addition
   		mov ecx, addition
   		call print

   		mov edx, len_substraction
   		mov ecx, substraction
   		call print

   		mov edx, len_mes_choice
   		mov ecx, mes_choice
   		call print

   		mov edx, 2
   		mov ecx, choice
   		call scan

   		cmp [choice], byte 49
   			je endl_choice
   		cmp [choice], byte 50
   			je endl_choice

   		mov edx, len_red_color
   		mov ecx, red_color
   		call print

   		mov edx, len_error
   		mov ecx, error
   		call print

   		mov edx, len_green_color
   		mov ecx, green_color
   		call print

   		cmp [choice + 1], byte 0xa
   			je make_choice
   		call clean_stdin
   		jmp make_choice

   	endl_choice:
   		cmp [choice + 1], byte 0xa
   			je done_choice

   		call clean_stdin

   		mov edx, len_red_color
   		mov ecx, red_color
   		call print

   		mov edx, len_error
   		mov ecx, error
   		call print

   		mov edx, len_green_color
   		mov ecx, green_color
   		call print

   		jmp make_choice

   	done_choice:
   		mov [number], dword 0
   		mov edx, len_enter_code
   		mov ecx, msg_enter_code
   		call print

   		mov edx, 4
   		mov ecx, code
   		call scan

   		cmp [code], byte 0xa
   			je bad
   		cmp [code], byte 49
   			jl check_str
   		cmp [code], byte 57
   			jg check_str

   		mov esi, code
   		inc dword [number]
   	next_digit:
   		inc esi
   		cmp [esi], byte 0xa
   			je done_code
   		cmp [esi], byte 48
   			jl check_str
   		cmp [esi], byte 57
   			jg check_str
   		inc dword [number]
   		cmp [number], dword 4
   			jl next_digit
   		call clean_stdin
   		jmp bad

   	done_code:
   		mov [integer], word 0
   		mov esi, code
   		add esi, [number]
   		mov edi, ten

   	cycle:
   		dec esi
   		inc edi

   		sub [esi], byte 48
   		mov al, [esi]
   		mov bl, [edi]
   		mul bl

   		add [integer], ax
   		
   		dec dword [number]
   		cmp [number], dword 0
   			jne cycle

   		cmp [integer], word 126
   			jg bad






   		mov esi, info
   		cmp [choice], byte 49
   			jne substr

   		mov al, byte [integer]
    addit:
   		cmp [esi], byte 0
   			jne not_endline
   		jmp result
   	not_endline:
   		mov bl, [esi]
   		add bl, al
   		cmp bx, word 127
   			jg greater

   		mov [esi], bl
   		inc esi
   		jmp addit
   		
   	greater:
   		sub bl, byte 128
   		mov [esi], bl
   		inc esi
   		jmp addit


   	substr:
   		cmp [esi], byte 0
   			jne not_sub_end
   		jmp result

   	not_sub_end:
   		mov bl, [esi]
   		sub bl, al
   		cmp bx, word 127
   			jg less

   		mov [esi], bl
   		inc esi
   		jmp substr
   		
   	less:
   		sub bl, byte 128
   		mov [esi], bl
   		inc esi
   		jmp substr

   	result:
   		mov edx, len_result
   		mov ecx, mes_result
   		call print

   		mov edx, 100
   		mov ecx, info
   		call print

   		mov edx, 1
   		mov ecx, endl
   		call print

   	exit:
		mov ebx, 0
		mov eax, 1
		int 0x80

	check_str:
		cmp [code + 1], byte 0xa
			je bad
		cmp [code + 2], byte 0xa
			je bad
		cmp [code + 3], byte 0xa
			je bad
		call clean_stdin
		jmp bad

	bad:
		mov edx, len_red_color
		mov ecx, red_color
		call print

		mov edx, len_error
		mov ecx, error
		call print

		mov edx, len_green_color
		mov ecx, green_color
		call print
		jmp done_choice

	print:
		mov ebx, 0
		mov eax, 4
		int 0x80
		ret

	scan:
		mov ebx, 1
		mov eax, 3
		int 0x80
		ret

	clean_stdin:
   		mov edx, 1
   		mov ecx, char
   		call scan
   		cmp [char], byte 0xa
   			jne clean_stdin
   		ret
