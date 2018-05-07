; Compile:
; nasm -f win32 snakeTheGame.asm
; nlink snakeTheGame.obj -lio -lgfx -lutil -o snakeTheGame.exe

%include 'io.inc'
%include 'gfx.inc'
%include 'util.inc'

%define WIDTH  1024
%define HEIGHT 768

%define scoreX (WIDTH / 2 - 80)
%define scoreY 20

%define playX (WIDTH / 2 - 100)
%define playY 50

%define scoreBoardX (WIDTH / 2 - 270)
%define scoreBoardY 180

%define helpX (WIDTH / 2 - 100)
%define helpY 320

%define exitX (WIDTH / 2 - 105)
%define exitY 460

%define easyX (WIDTH / 2 - 100)
%define easyY 50

%define normalX (WIDTH / 2 - 165)
%define normalY 180

%define hardX (WIDTH / 2 - 100)
%define hardY 320

%define impossibleX (WIDTH / 2 - 300)
%define impossibleY 460

%define numOfScores2Display 9

global main

section .text
kiIrScore:
	push eax
	push ebx
	push ecx
	push edi

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edi, edi

	mov eax, fileName
	mov ebx, 1

	call fio_open

		mov ebx, scoreArray
		mov ecx, 4

		.ciklus:
			cmp edi, [lengthOfScoreBoard]
			je .vegeCiklus

			cmp edi, numOfScores2Display
			je .vegeCiklus

				call fio_write

				add ebx, 4
				inc edi

				jmp .ciklus

		.vegeCiklus:
	call fio_close

	pop edi
	pop ecx
	pop ebx
	pop eax

	ret

beOlvas:
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor edi, edi
	xor esi, esi

	mov eax, 4
	call mem_alloc
	mov edx, eax

		mov eax, fileName
		mov ebx, 0
		call fio_open

			mov ebx, edx
			mov ecx, 4

			.ciklus:
				call fio_read

				test edx, edx
				jz .vegeCiklus

				cmp dword[lengthOfScoreBoard], numOfScores2Display
				je .vegeCiklus

					mov edi, [ebx]
					mov [scoreArray + esi], edi

					add esi, 4
					add dword[lengthOfScoreBoard], 1

					jmp .ciklus

			.vegeCiklus:
		call fio_close

	mov eax, ebx
	call mem_free

	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

saveScore:
	push eax
	push esi

	mov esi, [lengthOfScoreBoard]
	imul esi, 4

	mov eax, [score]
	mov [scoreArray + esi], eax

	add dword[lengthOfScoreBoard], 1

	pop esi
	pop eax

	ret

displayScoreBoard:
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi

	xor eax, eax
	xor ebx, ebx
	xor ecx, eax
	xor edx, edx
	xor edi, edi
	xor esi, esi

	mov ebx, scoreX

	mov byte[blue], 0
	mov byte[green], 255
	mov byte[red], 255

	mov dword[fontSize], 4
	mov dword[charOffset], 30

	.mainLoop:
		call gfx_map
		call clearScreen

		xor edi, edi
		xor edx, edx

		mov ecx, scoreY
		add ecx, 25

		.anotherLoop:
			cmp edx, [lengthOfScoreBoard]
			je .endAnotherLoop

			cmp edx, numOfScores2Display
			je .endAnotherLoop

				inc edx

				push ebx
				push edx

					mov esi, edx

					mov edx, char_#
					call putChar

					add ebx, 5
					call displayNumber

					add ebx, 50
					mov edx, char_COLON
					call putChar

					add ebx, 10
					mov esi, [scoreArray + edi]
					call displayNumber

				pop edx
				pop ebx

			add ecx, 80

			add edi, 4
			jmp .anotherLoop

		.endAnotherLoop:
		call gfx_unmap
		call gfx_draw

		call gfx_getevent

			cmp	al, 23	; the window close button was pressed: exit
			je .endMainLoop

			cmp al, 27 ; ESC: exit
			je .endMainLoop

		jmp .mainLoop

	.endMainLoop:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

displaySignature:
	push ebx
	push ecx
	push edx
	push edi
	push esi

		mov ebx, 80
		lea ecx, [HEIGHT / 2 + 100]

		lea edi, [WIDTH / 2 - 395]
		lea esi, [HEIGHT / 2 + 200]

		mov byte[blue], 255
		mov byte[green], 153
		mov byte[red], 0

		mov dword[fontSize], 6
		mov dword[charOffset], 58

			mov edx, char_T
			call putChar

			add ebx, 40
			mov edx, char_H
			call putChar

			add ebx, 40
			mov edx, char_I
			call putChar

			add ebx, 40
			mov edx, char_S
			call putChar

			add ebx, 80
			mov edx, char_G
			call putChar

			add ebx, 40
			mov edx, char_A
			call putChar

			add ebx, 40
			mov edx, char_M
			call putChar

			add ebx, 40
			mov edx, char_E
			call putChar

			add ebx, 80
			mov edx, char_W
			call putChar

			add ebx, 40
			mov edx, char_A
			call putChar

			add ebx, 40
			mov edx, char_S
			call putChar

			add ebx, 80
			mov edx, char_M
			call putChar

			add ebx, 40
			mov edx, char_A
			call putChar

			add ebx, 40
			mov edx, char_D
			call putChar

			add ebx, 40
			mov edx, char_E
			call putChar

			add ebx, 80
			mov edx, char_B
			call putChar

			add ebx, 40
			mov edx, char_Y
			call putChar

				mov ebx, edi
				mov ecx, esi

				mov byte[blue], 0
				mov byte[green], 102
				mov byte[red], 255

				mov dword[fontSize], 10

				mov edx, char_E
				call putChar

				add ebx, 60
				mov edx, char_L
				call putChar

				add ebx, 60
				mov edx, char_I
				call putChar

				add ebx, 60
				mov edx, char_E
				call putChar

				add ebx, 60
				mov edx, char_Z
				call putChar

				add ebx, 60
				mov edx, char_E
				call putChar

				add ebx, 60
				mov edx, char_R
				call putChar

				add ebx, 100
				mov edx, char_B
				call putChar

				add ebx, 60
				mov edx, char_E
				call putChar

				add ebx, 60
				mov edx, char_C
				call putChar

				add ebx, 60
				mov edx, char_Z
				call putChar

				add ebx, 60
				mov edx, char_I
				call putChar

	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx

	ret

displayKeys:
	push ebx
	push ecx
	push edx

	mov ebx, 20
	mov ecx, 35

	mov byte[blue], 255
	mov byte[green], 255
	mov byte[red], 255

	mov dword[fontSize], 5
	mov dword[charOffset], 33

		mov edx, char_U
		call putChar

		add ebx, [charOffset]
		mov edx, char_S
		call putChar

		add ebx, [charOffset]
		mov edx, char_E
		call putChar

		add ebx, [charOffset]

		add ebx, [charOffset]
		mov edx, char_T
		call putChar

		add ebx, [charOffset]
		mov edx, char_H
		call putChar

		add ebx, [charOffset]
		mov edx, char_E
		call putChar

		add ebx, [charOffset]

		add ebx, [charOffset]
		mov edx, char_K
		call putChar

		add ebx, [charOffset]
		mov edx, char_E
		call putChar

		add ebx, [charOffset]
		mov edx, char_Y
		call putChar

		add ebx, [charOffset]
		mov edx, char_S
		call putChar

			add ebx, [charOffset]
			mov dword[charOffset], 35

			mov byte[blue], 0
			mov byte[green], 0
			mov byte[red], 255

			add ebx, [charOffset]
			mov edx, char_W
			call putChar

			add ebx, [charOffset]
			mov edx, char_A
			call putChar

			add ebx, [charOffset]
			mov edx, char_S
			call putChar

			add ebx, [charOffset]
			mov edx, char_D
			call putChar

		add ebx, [charOffset]
		mov dword[charOffset], 33

		mov byte[blue], 255
		mov byte[green], 255
		mov byte[red], 255

		add ebx, [charOffset]
		mov edx, char_O
		call putChar

		add ebx, [charOffset]
		mov edx, char_R
		call putChar

			add ebx, [charOffset]
			mov dword[charOffset], 42

			mov byte[blue], 0
			mov byte[green], 0
			mov byte[red], 255

			add ebx, [charOffset]
			mov edx, char_UpArrow
			call putChar

			add ebx, [charOffset]
			mov edx, char_LeftArrow
			call putChar

			add ebx, [charOffset]
			mov edx, char_DownArrow
			call putChar

			add ebx, [charOffset]
			mov edx, char_RightArrow
			call putChar

		add ebx, [charOffset]
		mov dword[charOffset], 33

		mov byte[blue], 255
		mov byte[green], 255
		mov byte[red], 255

		add ebx, [charOffset]
		mov edx, char_T
		call putChar

		add ebx, [charOffset]
		mov edx, char_O
		call putChar

		mov ebx, 20
		add ecx, 70

		mov edx, char_M
		call putChar

		add ebx, [charOffset]
		mov edx, char_O
		call putChar

		add ebx, [charOffset]
		mov edx, char_V
		call putChar

		add ebx, [charOffset]
		mov edx, char_E
		call putChar

		add ebx, [charOffset]

		add ebx, [charOffset]
		mov edx, char_T
		call putChar

		add ebx, [charOffset]
		mov edx, char_H
		call putChar

		add ebx, [charOffset]
		mov edx, char_E
		call putChar

		add ebx, [charOffset]

		add ebx, [charOffset]
		mov edx, char_S
		call putChar

		add ebx, [charOffset]
		mov edx, char_N
		call putChar

		add ebx, [charOffset]
		mov edx, char_A
		call putChar

		add ebx, [charOffset]
		mov edx, char_K
		call putChar

		add ebx, [charOffset]
		mov edx, char_E
		call putChar

		mov ebx, 15
		add ecx, 120

		mov edx, char_P
		call putChar

		add ebx, [charOffset]
		mov edx, char_R
		call putChar

		add ebx, [charOffset]
		mov edx, char_E
		call putChar

		add ebx, [charOffset]
		mov edx, char_S
		call putChar

		add ebx, [charOffset]
		mov edx, char_S
		call putChar

			add ebx, [charOffset]

			mov byte[blue], 0
			mov byte[green], 0
			mov byte[red], 255

			add ebx, [charOffset]
			mov edx, char_E
			call putChar

			add ebx, [charOffset]
			mov edx, char_S
			call putChar

			add ebx, [charOffset]
			mov edx, char_C
			call putChar

		add ebx, [charOffset]

		mov byte[blue], 255
		mov byte[green], 255
		mov byte[red], 255

		add ebx, [charOffset]
		mov edx, char_T
		call putChar

		add ebx, [charOffset]
		mov edx, char_O
		call putChar

		add ebx, [charOffset]

		add ebx, [charOffset]
		mov edx, char_E
		call putChar

		add ebx, [charOffset]
		mov edx, char_X
		call putChar

		add ebx, [charOffset]
		mov edx, char_I
		call putChar

		add ebx, [charOffset]
		mov edx, char_T
		call putChar

		add ebx, [charOffset]

		add ebx, [charOffset]
		mov edx, char_F
		call putChar

		add ebx, [charOffset]
		mov edx, char_R
		call putChar

		add ebx, [charOffset]
		mov edx, char_O
		call putChar

		add ebx, [charOffset]
		mov edx, char_M
		call putChar

		add ebx, [charOffset]

		add ebx, [charOffset]
		mov edx, char_M
		call putChar

		add ebx, [charOffset]
		mov edx, char_E
		call putChar

		add ebx, [charOffset]
		mov edx, char_N
		call putChar

		add ebx, [charOffset]
		mov edx, char_U
		call putChar

		add ebx, [charOffset]
		mov edx, char_S
		call putChar

	pop edx
	pop ecx
	pop ebx

	ret

displayHelp:
	push eax

	.mainLoop:
		call gfx_map
		call clearScreen

		call displayKeys
		call displaySignature

		call gfx_unmap
		call gfx_draw

		call gfx_getevent

			cmp	al, 23	; the window close button was pressed: exit
			je .endMainLoop

			cmp al, 27 ; ESC: exit
			je .endMainLoop

		jmp .mainLoop

	.endMainLoop:
	pop eax

	ret

rendEz:
	push eax
	push ebx
	push edx
	push edi
	push esi

	xor eax, eax
	xor ebx, ebx
	xor edx, edx
	xor edi, edi
	xor esi, esi

	mov edx, [lengthOfScoreBoard]
	imul edx, 4

	.ciklus1:
		cmp edi, edx
		jae .vegeCiklus1

		mov eax, [scoreArray + edi]

		mov esi, edi
		add esi, 4

		.ciklus2:
			cmp esi, edx
			jae .vegeCiklus2

			mov ebx, [scoreArray + esi]

			cmp eax, ebx
			jae .continue

			mov [scoreArray + edi], ebx
			mov [scoreArray + esi], eax

			.continue:
				add esi, 4
				jmp .ciklus2

		.vegeCiklus2:
		add edi, 4
		jmp .ciklus1

	.vegeCiklus1:
	pop esi
	pop edi
	pop edx
	pop ebx
	pop eax

	ret

putChar:
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi

	xor edi, edi
	mov esi, edx

	.ciklus1:
		cmp edi, 8
		je .vegeCiklus1

		xor edx, edx
		mov dl, [esi + edi]
		shl edx, 24

		push ebx
		push edi

		xor edi, edi

		.ciklus2:
			cmp edi, 8
			je .vegeCiklus2

			shl edx, 1
			jnc .continue

			call expandPixel

		.continue:
			add ebx, [fontSize]
			inc edi

			jmp .ciklus2

		.vegeCiklus2:
		pop edi
		pop ebx

		add ecx, [fontSize]
		inc edi

		jmp .ciklus1

	.vegeCiklus1:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

displayNumber:
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi

	xor edi, edi

	.ciklus1:
		test esi, esi
		jz .vegeCiklus1

		push eax
		push ebx
			mov eax, esi
			mov ebx, 10
			xor edx, edx
			div ebx
			mov esi, eax
		pop ebx
		pop eax

		push edx
		inc edi

		jmp .ciklus1

	.vegeCiklus1:
		test edi, edi
		jnz .ciklus2

		add ebx, [charOffset]
		mov edx, num_0
		call putChar

		jmp .vegeCiklus2

	.ciklus2:
		pop edx

		.nulla:
			test edx, edx
			jne .egy

			add ebx, [charOffset]
			mov edx, num_0
			call putChar

			jmp .continue

		.egy:
			cmp edx, 1
			jne .ketto

			add ebx, [charOffset]
			mov edx, num_1
			call putChar

			jmp .continue

		.ketto:
			cmp edx, 2
			jne .harom

			add ebx, [charOffset]
			mov edx, num_2
			call putChar

			jmp .continue

		.harom:
			cmp edx, 3
			jne .negy

			add ebx, [charOffset]
			mov edx, num_3
			call putChar

			jmp .continue

		.negy:
			cmp edx, 4
			jne .ot

			add ebx, [charOffset]
			mov edx, num_4
			call putChar

			jmp .continue

		.ot:
			cmp edx, 5
			jne .hat

			add ebx, [charOffset]
			mov edx, num_5
			call putChar

			jmp .continue

		.hat:
			cmp edx, 6
			jne .het

			add ebx, [charOffset]
			mov edx, num_6
			call putChar

			jmp .continue

		.het:
			cmp edx, 7
			jne .nyolc

			add ebx, [charOffset]
			mov edx, num_7
			call putChar

			jmp .continue

		.nyolc:
			cmp edx, 8
			jne .kilenc

			add ebx, [charOffset]
			mov edx, num_8
			call putChar

			jmp .continue

		.kilenc:
			cmp edx, 9
			jne .continue

			add ebx, [charOffset]
			mov edx, num_9
			call putChar

		.continue:
			dec edi
			jnz .ciklus2

	.vegeCiklus2:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

displayScore:
	push eax
	push ebx
	push ecx
	push edx
	push esi

	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor esi, esi

	mov byte[blue], 255
	mov byte[green], 255
	mov byte[red], 255

	mov dword[fontSize], 3
	mov dword[charOffset], 20

	mov ebx, scoreX
	mov ecx, scoreY

	mov edx, char_S
	call putChar

	add ebx, [charOffset]
	mov edx, char_C
	call putChar

	add ebx, [charOffset]
	mov edx, char_O
	call putChar

	add ebx, [charOffset]
	mov edx, char_R
	call putChar

	add ebx, [charOffset]
	mov edx, char_E
	call putChar

	add ebx, [charOffset]
	mov edx, char_COLON
	call putChar

	mov byte[blue], 0
	mov byte[green], 0
	mov byte[red], 255

	mov esi, [score]
	call displayNumber

	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

colorCoord:
	push ebx
	push ecx
	push edx

		mov bl, [blue]
		mov cl, [green]
		mov dl, [red]

		mov [eax], bl
		mov [eax + 1], cl
		mov [eax + 2], dl
		mov byte[eax + 3], 0

	pop edx
	pop ecx
	pop ebx

	ret

calculate_Coord:
	push ebx
	push ecx

		dec ecx
		imul ecx, 4
		imul ecx, WIDTH
		add eax, ecx
		imul ebx, 4
		add eax, ebx

	pop ecx
	pop ebx

	ret

expandPixel:
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi

	xor edi, edi
	xor esi, esi

	sub ebx, [fontSize]
	sub ecx, [fontSize]

	mov edx, ebx

	.ciklus1:
		cmp edi, [fontSize]
		je .vegeCiklus1

		mov ebx, edx
		inc ecx

		.ciklus2:
			cmp esi, [fontSize]
			je .vegeCiklus2

			inc ebx

			push eax
				call calculate_Coord
				call colorCoord
			pop eax

			inc esi
			jmp .ciklus2

		.vegeCiklus2:
		xor esi, esi

		inc edi
		jmp .ciklus1

.vegeCiklus1:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

placeFood:
	push eax
	push ebx
	push ecx

	mov byte[blue], 0
	mov byte[green], 0
	mov byte[red], 255

	mov ebx, [foodX]
	mov ecx, [foodY]

	push eax
		mov eax, [radius]
		mov [fontSize], eax
	pop eax

	call expandPixel

	pop ecx
	pop ebx
	pop eax

	ret

initSnake:
	push eax
	push ebx
	push ecx
	push edx
	push edi

	mov ecx, 2

	mov eax, [border_x2]
	add eax, [border_x1]
	xor edx, edx
	div ecx
	mov ebx, eax

	mov eax, [border_y2]
	add eax, [border_y1]
	xor edx, edx
	div ecx

	xchg eax, ebx

	xor ecx, ecx
	xor edi, edi

	.ciklus:
		cmp ecx, [lengthOfSnake]
		je .vegeCiklus

		mov [snakeX + edi], eax
		mov [snakeY + edi], ebx

		add eax, [radius]
		inc eax

		add edi, 4
		inc ecx

		jmp .ciklus

	.vegeCiklus:
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

drawSnake:
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi

	mov esi, [radius]
	mov dword[fontSize], esi

	mov byte[blue], 0
	mov byte[green], 0
	mov byte[red], 0

	mov ebx, [snakeX]
	mov ecx, [snakeY]
	call expandPixel

	mov bl, [snakeBlue]
	mov cl, [snakeGreen]
	mov dl, [snakeRed]

	mov byte[blue], bl
	mov byte[green], cl
	mov byte[red], dl

	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor edi, edi
	xor esi, esi

	inc edx
	add edi, 4

	.ciklus:
		cmp edx, [lengthOfSnake]
		je .ciklusVege

		mov ebx, [snakeX + edi]
		mov ecx, [snakeY + edi]

		call expandPixel

		inc edx
		add edi, 4
		
		jmp .ciklus

	.ciklusVege:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

updateSnake:
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor edi, edi
	xor esi, esi

	mov edi, [lengthOfSnake]
	dec edi
	imul edi, 4

	mov esi, edi
	sub esi, 4

	mov edx, [lengthOfSnake]
	dec edx

	.ciklus:
		cmp ecx, edx
		je .vegeCiklus

		mov eax, [snakeX + esi]
		mov ebx, [snakeY + esi]

		mov [snakeX + edi], eax
		mov [snakeY + edi], ebx

		sub edi, 4
		sub esi, 4

		inc ecx
		jmp .ciklus

	.vegeCiklus:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

clearScreen:
	push eax
	push edi
	push esi

	xor edi, edi

	.ciklus1:
		cmp edi, HEIGHT
		je .vegeCiklus1

		xor esi, esi

		.ciklus2:
			cmp esi, WIDTH
			je .vegeCiklus2

			mov byte[eax], 41
			mov byte[eax + 1], 61
			mov byte[eax + 2], 61
			mov byte[eax + 3], 0

			add eax, 4

			inc esi
			jmp .ciklus2

		.vegeCiklus2:
		inc edi
		jmp .ciklus1

	.vegeCiklus1:
	pop esi
	pop edi
	pop eax

	ret

moveHead:
	push eax
	push ebx

	xor eax, eax
	xor ebx, ebx

		mov eax, [radius]
		inc eax
		imul eax, [directionX]
		add [snakeX], eax

		mov ebx, [radius]
		inc ebx
		imul ebx, [directionY]
		add [snakeY], ebx

	pop ebx
	pop eax

	ret

insideRect:
	push edi
	push esi

	xor edi, edi
	xor esi, esi

	mov edi, eax
	sub edi, [radius]

	mov esi, edx
	sub esi, [radius]

	cmp ebx, eax
	jg .clearCarry

	cmp ebx, edi
	jl .clearCarry

	cmp ecx, edx
	jg .clearCarry

	cmp ecx, esi
	jl .clearCarry

	jmp .activateCarry

.clearCarry:
	clc
	jmp .kiLep

.activateCarry:
	stc

.kiLep:
	pop esi
	pop edi

	ret

foodEaten:
	push eax
	push ebx
	push ecx
	push edx

	xor eax, eax
	xor edx, edx

	mov eax, [foodX]
	mov edx, [foodY]

	mov ebx, [snakeX]
	mov ecx, [snakeY]
	call insideRect
	jc .kiLep

	sub ebx, [radius]
	sub ecx, [radius]
	call insideRect
	jc .kiLep

	add ebx, [radius]
	call insideRect
	jc .kiLep

	sub ebx, [radius]
	add ecx, [radius]
	call insideRect
	jc .kiLep

	clc

.kiLep:
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

coordOutOfBound:
	push ecx
	push esi

	xor esi, esi

	mov esi, [radius]

.left:
	cmp ebx, [border_x1]
	jge .right

		mov ecx, [border_x2]
		dec ecx
		dec ecx
		mov dword[snakeX], ecx

		jmp .activateCarry

.right:
	cmp ebx, [border_x2]
	jl .up

		mov ecx, [border_x1]
		add ecx, esi
		mov dword[snakeX], ecx

		jmp .activateCarry

.up:
	cmp ecx, [border_y1]
	jge .down

		mov ecx, [border_y2]
		dec ecx
		dec ecx
		mov dword[snakeY], ecx

		jmp .activateCarry

.down:
	cmp ecx, [border_y2]
	jl .clearCarry

		mov ecx, [border_y1]
		add ecx, esi
		mov dword[snakeY], ecx

		jmp .activateCarry

.clearCarry:
	clc
	jmp .kiLep

.activateCarry:
	stc

.kiLep:
	pop esi
	pop ecx

	ret

snakeOutOfBounds:
	push eax
	push ebx
	push ecx

	mov ebx, [snakeX]
	mov ecx, [snakeY]
	call coordOutOfBound
	jc .kiLep

	sub ebx, [radius]
	sub ecx, [radius]
	call coordOutOfBound
	jc .kiLep

	add ebx, [radius]
	call coordOutOfBound
	jc .kiLep

	sub ebx, [radius]
	add ecx, [radius]
	call coordOutOfBound
	jc .kiLep

	clc

.kiLep:
	pop ecx
	pop ebx
	pop eax

	ret

collisionDetection:
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor edi, edi
	xor esi, esi

	mov ebx, [snakeX]
	mov ecx, [snakeY]

	inc edi
	add esi, 4

	.ciklus:
		cmp edi, [lengthOfSnake]
		je .vegeCiklus

		mov eax, [snakeX + esi]
		mov edx, [snakeY + esi]

		call insideRect
		jc .kiLep
		
	.continue:
		inc edi
		add esi, 4

		jmp .ciklus

	.vegeCiklus:
	clc

.kiLep:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

changeColorSnake:
	push eax
	push ebx
	push edx

	xor eax, eax
	xor ebx, ebx
	xor edx, edx

	mov ebx, 256

	call rand
	xor edx, edx
	idiv ebx
	mov [snakeBlue], dl

	call rand
	xor edx, edx
	idiv ebx
	mov [snakeGreen], dl

	call rand
	xor edx, edx
	idiv ebx
	mov [snakeRed], dl

	pop edx
	pop ebx
	pop eax

	ret

handleEvents:
	push eax

	xor eax, eax

	call gfx_getevent

.moveUp:
	cmp	eax, 'w' ; w key pressed
	je .continue1

	cmp eax, 0x111 ; Up Arrow
	je .continue1

	jmp .moveDown

	.continue1:
		cmp byte[elozoLenyomottChar], 's'
		je .otherEvents

		mov dword[directionX], 0
		mov dword[directionY], -1

		mov byte[elozoLenyomottChar], 'w'

		jmp .exitFunction

.moveDown:
	cmp	eax, 's' ; s key pressed
	je .continue2

	cmp eax, 0x112 ; Down Arrow
	je .continue2

	jmp .moveLeft

	.continue2:
		cmp byte[elozoLenyomottChar], 'w'
		je .otherEvents

		mov dword[directionX], 0
		mov dword[directionY], 1

		mov byte[elozoLenyomottChar], 's'

		jmp .exitFunction

.moveLeft:
	cmp	eax, 'a' ; a key pressed
	je .continue3

	cmp eax, 0x114 ; Left Arrow
	je .continue3

	jmp .moveRight

	.continue3:
		cmp byte[elozoLenyomottChar], 'd'
		je .otherEvents

		mov dword[directionX], -1
		mov dword[directionY], 0

		mov byte[elozoLenyomottChar], 'a'

		jmp .exitFunction

.moveRight:
	cmp	eax, 'd' ; d key pressed
	je .continue4

	cmp eax, 0x113 ; Right Arrow
	je .continue4

	jmp .otherEvents

	.continue4:
		cmp byte[elozoLenyomottChar], 'a'
		je .exitFunction

		mov dword[directionX], 1
		mov dword[directionY], 0

		mov byte[elozoLenyomottChar], 'd'

		jmp .exitFunction

.otherEvents:
	cmp	al, 23	; the window close button was pressed: exit
	je .activateCarry

	cmp al, 27 ; ESC: exit
	je .activateCarry

	jmp .exitFunction

.activateCarry:
	stc

	pop eax

	ret

.exitFunction:
	clc

	pop eax

	ret

initGame_easy:
	push eax

	mov	eax, infomsg ; print some usage info
	call io_writestr
	call io_writeln

	mov dword[border_x1], 16
	mov dword[border_y1], 64

	mov dword[border_x2], 1008
	mov dword[border_y2], 736

	mov dword[lengthOfSnake], 3
	mov dword[addToLength], 2
	mov dword[addToScore], 1

	mov dword[directionX], -1
	mov dword[directionY], 0

	mov byte[elozoLenyomottChar], 'a'

	mov byte[ok], 1
	mov dword[fps], 28
	mov dword[score], 0

	mov dword[radius], 16

	call initSnake
	call generateNewFood
	call changeColorSnake

	pop eax

	ret

initGame_normal:
	push eax

	mov	eax, infomsg ; print some usage info
	call io_writestr
	call io_writeln

	mov dword[border_x1], 64
	mov dword[border_y1], 80

	mov dword[border_x2], 960
	mov dword[border_y2], 712

	mov dword[lengthOfSnake], 3
	mov dword[addToLength], 6
	mov dword[addToScore], 2

	mov dword[directionX], -1
	mov dword[directionY], 0

	mov byte[elozoLenyomottChar], 'a'

	mov byte[ok], 1
	mov dword[fps], 18
	mov dword[score], 0

	mov dword[radius], 8

	call initSnake
	call generateNewFood
	call changeColorSnake

	pop eax

	ret

initGame_hard:
	push eax

	mov	eax, infomsg ; print some usage info
	call io_writestr
	call io_writeln

	mov dword[border_x1], 132
	mov dword[border_y1], 112

	mov dword[border_x2], 892
	mov dword[border_y2], 680

	mov dword[lengthOfSnake], 3
	mov dword[addToLength], 10
	mov dword[addToScore], 4

	mov dword[directionX], -1
	mov dword[directionY], 0

	mov byte[elozoLenyomottChar], 'a'

	mov byte[ok], 1
	mov dword[fps], 6
	mov dword[score], 0

	mov dword[radius], 4

	call initSnake
	call generateNewFood
	call changeColorSnake

	pop eax

	ret

initGame_impossible:
	push eax

	mov	eax, infomsg ; print some usage info
	call io_writestr
	call io_writeln

	mov dword[border_x1], 256
	mov dword[border_y1], 150

	mov dword[border_x2], 768
	mov dword[border_y2], 620

	mov dword[lengthOfSnake], 3
	mov dword[addToLength], 20
	mov dword[addToScore], 8

	mov dword[directionX], -1
	mov dword[directionY], 0

	mov byte[elozoLenyomottChar], 'a'

	mov byte[ok], 1
	mov dword[fps], 1
	mov dword[score], 0

	mov dword[radius], 1

	call initSnake
	call generateNewFood
	call changeColorSnake

	pop eax

	ret

badCoords:
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor edi, edi
	xor esi, esi

	mov ebx, [foodX]
	mov ecx, [foodY]

	.ciklus:
		cmp edi, [lengthOfSnake]
		je .vegeCiklus

		mov eax, [snakeX + esi]
		mov edx, [snakeY + esi]

			call insideRect
			jc .kiLep

			sub ecx, [radius]
			call insideRect
			jc .kiLep

			sub ebx, [radius]
			call insideRect
			jc .kiLep

			add ecx, [radius]
			call insideRect
			jc .kiLep

			add ebx, [radius]

	.continue:
		add esi, 4
		inc edi

		jmp .ciklus

	.vegeCiklus:
	clc

.kiLep:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

randCoordBetween2Values:
	push eax
	push ebx
	push edi
	push esi

		call rand
		mov ebx, esi
		sub ebx, edi
		sub ebx, [radius]
		dec ebx
		xor edx, edx
		idiv ebx
		add edx, edi
		add edx, [radius]
		inc edx

	pop esi
	pop edi
	pop ebx
	pop eax

	ret

generateNewFood:
	push edx
	push edi
	push esi

	.general:
		mov edi, [border_x1]
		mov esi, [border_x2]
		call randCoordBetween2Values

		mov [foodX], edx


		mov edi, [border_y1]
		mov esi, [border_y2]
		call randCoordBetween2Values

		mov [foodY], edx

	call badCoords
	jc .general

	clc

	pop esi
	pop edi
	pop edx

	ret

drawBorder:
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi

	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor edi, edi
	xor esi, esi

	mov ebx, [border_x1]
	mov esi, [border_y1]

	mov edx, eax

	.ciklus1:
		cmp esi, [border_y2]
		je .vegeCiklus1

		mov eax, edx
		mov ecx, esi
		call calculate_Coord

		mov edi, [border_x1]

			.ciklus2:
				cmp edi, [border_x2]
				je .vegeCiklus2

				mov byte[eax], 153
				mov byte[eax + 1], 255
				mov byte[eax + 2], 204
				mov byte[eax + 3], 0

				add eax, 4

				inc edi
				jmp .ciklus2

			.vegeCiklus2:
		inc esi
		jmp .ciklus1

	.vegeCiklus1:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

runGame:
	push eax
	push ebx
	push ecx

	xor ecx, ecx
	xor ebx, ebx

	mov ebx, [addToScore]

.myLoop:
	mov eax, [fps]
	test eax, eax
	jle .drawThings

		call sleep

.drawThings:
	call gfx_map ; map the framebuffer -> EAX will contain the pointer

	call clearScreen
	call drawBorder
	call displayScore
	call drawSnake
	call placeFood

	call foodEaten
	jnc .increaseSnakeLengthGradually

		add [score], ebx
		sub dword[fps], ebx
		add ecx, [addToLength]

		call generateNewFood
		call changeColorSnake

.increaseSnakeLengthGradually:
	test ecx, ecx
	je .updateThings

		add dword[lengthOfSnake], 1
		dec ecx

.updateThings:
	call updateSnake
	call moveHead

	call snakeOutOfBounds

	call collisionDetection
	jnc .drawQualityContent

		mov byte[ok], 0

.drawQualityContent:
	call gfx_unmap ; unmap the framebuffer
	call gfx_draw ; draw the contents of the framebuffer (*must* be called once in each iteration!)

	; Query and handle the events (loop!)
.eventloop:
	call handleEvents
	jnc .continue

		mov byte[ok], 0

.continue:
	cmp byte[ok], 1
	je .myLoop

.exitFunction:
	pop ecx
	pop ebx
	pop eax

	ret

displayChooseDifficulty:
	push eax
	push ebx
	push ecx
	push edx

	mov dword[fontSize], 10
	mov dword[charOffset], 65

	; EASY LABEL
	mov byte[blue], 255
	mov byte[green], 255
	mov byte[red], 255

	cmp byte[easyActivated], 1
	jne .continue1

		mov byte[blue], 0
		mov byte[green], 255
		mov byte[red], 0

.continue1:
	mov ebx, easyX
	mov ecx, easyY
	mov edx, char_E
	call putChar

	add ebx, [charOffset]
	mov edx, char_A
	call putChar

	add ebx, [charOffset]
	mov edx, char_S
	call putChar

	add ebx, [charOffset]
	mov edx, char_Y
	call putChar

	; NORMAL LABEL
	mov byte[blue], 255
	mov byte[green], 255
	mov byte[red], 255

	cmp byte[normalActivated], 1
	jne .continue2

		mov byte[blue], 0
		mov byte[green], 255
		mov byte[red], 0

.continue2:
	mov ebx, normalX
	mov ecx, normalY
	mov edx, char_N
	call putChar

	add ebx, [charOffset]
	mov edx, char_O
	call putChar

	add ebx, [charOffset]
	mov edx, char_R
	call putChar

	add ebx, [charOffset]
	mov edx, char_M
	call putChar

	add ebx, [charOffset]
	mov edx, char_A
	call putChar

	add ebx, [charOffset]
	mov edx, char_L
	call putChar

	; HARD LABEL
	mov byte[blue], 255
	mov byte[green], 255
	mov byte[red], 255

	cmp byte[hardActivated], 1
	jne .continue3

		mov byte[blue], 0
		mov byte[green], 255
		mov byte[red], 0

.continue3:
	mov ebx, hardX
	mov ecx, hardY
	mov edx, char_H
	call putChar

	add ebx, [charOffset]
	mov edx, char_A
	call putChar

	add ebx, [charOffset]
	mov edx, char_R
	call putChar

	add ebx, [charOffset]
	mov edx, char_D
	call putChar

	; IMPOSSIBLE LABEL
	mov byte[blue], 255
	mov byte[green], 255
	mov byte[red], 255

	cmp byte[impossibleActivated], 1
	jne .continue4

		mov byte[blue], 0
		mov byte[green], 255
		mov byte[red], 0

.continue4:
	mov ebx, impossibleX
	mov ecx, impossibleY
	mov edx, char_I
	call putChar

	add ebx, [charOffset]
	mov edx, char_M
	call putChar

	add ebx, [charOffset]
	mov edx, char_P
	call putChar

	add ebx, [charOffset]
	mov edx, char_O
	call putChar

	add ebx, [charOffset]
	mov edx, char_S
	call putChar

	add ebx, [charOffset]
	mov edx, char_S
	call putChar

	add ebx, [charOffset]
	mov edx, char_I
	call putChar

	add ebx, [charOffset]
	mov edx, char_B
	call putChar

	add ebx, [charOffset]
	mov edx, char_L
	call putChar

	add ebx, [charOffset]
	mov edx, char_E
	call putChar

	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

selectDifficulty:
	mov byte[easyActivated], 0
	mov byte[normalActivated], 0
	mov byte[hardActivated], 0
	mov byte[impossibleActivated], 0

	mov byte[exitSelectDifficulty], 0

.mainLoop:
	call gfx_map

	call clearScreen
	call displayChooseDifficulty

		mov byte[easyActivated], 0
		mov byte[normalActivated], 0
		mov byte[hardActivated], 0
		mov byte[impossibleActivated], 0

	call gfx_unmap
	call gfx_draw

	call checkClick_selectDifficulty

	cmp byte[exitSelectDifficulty], 1
	jne .mainLoop

.endMainLoop:
	ret

displayGUI:
	push eax
	push ebx
	push ecx
	push edx

	mov dword[fontSize], 10
	mov dword[charOffset], 58

	; PLAY LABEL
	mov byte[blue], 255
	mov byte[green], 255
	mov byte[red], 255

	cmp byte[playActivated], 1
	jne .continue1

		mov byte[blue], 0
		mov byte[green], 255
		mov byte[red], 0

.continue1:
	mov ebx, playX
	mov ecx, playY
	mov edx, char_P
	call putChar

	add ebx, [charOffset]
	mov edx, char_L
	call putChar

	add ebx, [charOffset]
	mov edx, char_A
	call putChar

	add ebx, [charOffset]
	mov edx, char_Y
	call putChar

	; SCOREBOARD LABEL
	mov byte[blue], 255
	mov byte[green], 255
	mov byte[red], 255

	cmp byte[scoreBoardActivated], 1
	jne .continue2

		mov byte[blue], 0
		mov byte[green], 255
		mov byte[red], 0

.continue2:
	mov ebx, scoreBoardX
	mov ecx, scoreBoardY
	mov edx, char_S
	call putChar

	add ebx, [charOffset]
	mov edx, char_C
	call putChar

	add ebx, [charOffset]
	mov edx, char_O
	call putChar

	add ebx, [charOffset]
	mov edx, char_R
	call putChar

	add ebx, [charOffset]
	mov edx, char_E
	call putChar

	add ebx, [charOffset]
	mov edx, char_B
	call putChar

	add ebx, [charOffset]
	mov edx, char_O
	call putChar

	add ebx, [charOffset]
	mov edx, char_A
	call putChar

	add ebx, [charOffset]
	mov edx, char_R
	call putChar

	add ebx, [charOffset]
	mov edx, char_D
	call putChar

	; HELP LABEL
	mov byte[blue], 255
	mov byte[green], 255
	mov byte[red], 255

	cmp byte[helpActivated], 1
	jne .continue3

		mov byte[blue], 0
		mov byte[green], 255
		mov byte[red], 0

.continue3:
	mov ebx, helpX
	mov ecx, helpY
	mov edx, char_H
	call putChar

	add ebx, [charOffset]
	mov edx, char_E
	call putChar

	add ebx, [charOffset]
	mov edx, char_L
	call putChar

	add ebx, [charOffset]
	mov edx, char_P
	call putChar

	; EXIT LABEL
	mov byte[blue], 255
	mov byte[green], 255
	mov byte[red], 255

	cmp byte[exitActivated], 1
	jne .continue4

		mov byte[blue], 0
		mov byte[green], 255
		mov byte[red], 0

.continue4:
	mov ebx, exitX
	mov ecx, exitY
	mov edx, char_E
	call putChar

	add ebx, [charOffset]
	mov edx, char_X
	call putChar

	add ebx, [charOffset]
	mov edx, char_I
	call putChar

	add ebx, [charOffset]
	mov edx, char_T
	call putChar

	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

mouseInsideLabel:
	cmp eax, edi
	jg .clearCarry

	cmp eax, ecx
	jl .clearCarry

	cmp ebx, esi
	jg .clearCarry

	cmp ebx, edx
	jl .clearCarry

	jmp .activateCarry

.clearCarry:
	clc
	jmp .kiLep

.activateCarry:
	stc

.kiLep:
	ret

checkClick_selectDifficulty:
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor edi, edi
	xor esi, esi

	call gfx_getevent

		cmp	al, 23	; the window close button was pressed: exit
		je .exitNo1

		cmp al, 27 ; ESC: exit
		je .exitNo1

	push eax

	call gfx_getmouse

	mov dword[fontSize], 10

.easyLabel:
	mov ecx, easyX
	mov edx, easyY

	add ecx, 10
	sub edx, 10
	
	mov edi, easyX
	add edi, 246

	mov esi, easyY
	add esi, 70

	call mouseInsideLabel
	jnc .normalLabel

		mov byte[easyActivated], 1

		pop eax

		cmp eax, 1
		jne .exitNo2

			call initGame_easy
			call runGame
			call saveScore
			call rendEz

			mov byte[exitSelectDifficulty], 1

			jmp .exitNo2

.normalLabel:
	mov ecx, normalX
	mov edx, normalY

	sub edx, 10

	mov edi, normalX
	add edi, 376

	mov esi, normalY
	add esi, 70

	call mouseInsideLabel
	jnc .hardLabel

		mov byte[normalActivated], 1

		pop eax

		cmp eax, 1
		jne .exitNo2

			call initGame_normal
			call runGame
			call saveScore
			call rendEz

			mov byte[exitSelectDifficulty], 1

			jmp .exitNo2

.hardLabel:
	mov ecx, hardX
	mov edx, hardY

	add ecx, 10
	sub edx, 10

	mov edi, hardX
	add edi, 246

	mov esi, hardY
	add esi, 70

	call mouseInsideLabel
	jnc .impossibleLabel

		mov byte[hardActivated], 1

		pop eax

		cmp eax, 1
		jne .exitNo2

			call initGame_hard
			call runGame
			call saveScore
			call rendEz

			mov byte[exitSelectDifficulty], 1

			jmp .exitNo2

.impossibleLabel:
	mov ecx, impossibleX
	mov edx, impossibleY

	add ecx, 10
	sub edx, 10

	mov edi, impossibleX
	add edi, 636

	mov esi, impossibleY
	add esi, 70

	call mouseInsideLabel
	jnc .exitNo1

		mov byte[impossibleActivated], 1

		pop eax

		cmp eax, 1
		jne .exitNo2

			call initGame_impossible
			call runGame
			call saveScore
			call rendEz

			mov byte[exitSelectDifficulty], 1

.exitNo2:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

.exitNo1:
	pop eax
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

checkClick_mainMenu:
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor edi, edi
	xor esi, esi

	call gfx_getevent

		cmp	al, 23	; the window close button was pressed: exit
		je .exitNo1

		cmp al, 27 ; ESC: exit
		je .exitNo1

	push eax

	call gfx_getmouse

	mov dword[fontSize], 10

.playLabel:
	mov ecx, playX
	mov edx, playY

	add ecx, 10
	sub edx, 10
	
	mov edi, playX
	add edi, 225

	mov esi, playY
	add esi, 70

	call mouseInsideLabel
	jnc .exitLabel

		mov byte[playActivated], 1

		pop eax

		cmp eax, 1
		jne .exitNo2

			call selectDifficulty
			jmp .exitNo2

.exitLabel:
	mov ecx, exitX
	mov edx, exitY

	add ecx, 10
	sub edx, 10

	mov edi, exitX
	add edi, 235

	mov esi, exitY
	add esi, 70

	call mouseInsideLabel
	jnc .helpLabel

		mov byte[exitActivated], 1

		pop eax

		cmp eax, 1
		jne .exitNo2

			mov byte[exitGame], 1
			call kiIrScore

			jmp .exitNo2

.helpLabel:
	mov ecx, helpX
	mov edx, helpY

	add ecx, 10
	sub edx, 10

	mov edi, helpX
	add edi, 225

	mov esi, helpY
	add esi, 70

	call mouseInsideLabel
	jnc .scoreBoardLabel

		mov byte[helpActivated], 1

		pop eax

		cmp eax, 1
		jne .exitNo2

			call displayHelp
			jmp .exitNo2

.scoreBoardLabel:
	mov ecx, scoreBoardX
	mov edx, scoreBoardY

	add ecx, 10
	sub edx, 10

	mov edi, scoreBoardX
	add edi, 572

	mov esi, scoreBoardY
	add esi, 70

	call mouseInsideLabel
	jnc .exitNo1

		mov byte[scoreBoardActivated], 1

		pop eax

		cmp eax, 1
		jne .exitNo2

			call displayScoreBoard

.exitNo2:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

.exitNo1:
	pop eax
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret

main:
	; Create the graphics window
    mov	eax, WIDTH ; window width (X)
	mov	ebx, HEIGHT ; window height (Y)
	mov	ecx, 0 ; window mode (NOT fullscreen!)
	mov	edx, caption ; window caption

	call gfx_init
	
	test eax, eax ; if the return value is 0, something went wrong
	jnz .init

		; Print error message and exit
		mov	eax, errormsg
		call io_writestr
		call io_writeln

		ret

.init:
	mov byte[exitGame], 0

	mov byte[playActivated], 0
	mov byte[exitActivated], 0
	mov byte[helpActivated], 0
	mov byte[scoreBoardActivated], 0

	mov dword[lengthOfSnake], 0
	mov dword[lengthOfScoreBoard], 0

	call beOlvas

.mainLoop:
	call gfx_map ; map the framebuffer -> EAX will contain the pointer

	call clearScreen
	call displayGUI

		mov byte[playActivated], 0
		mov byte[exitActivated], 0
		mov byte[helpActivated], 0
		mov byte[scoreBoardActivated], 0

	call gfx_unmap ; unmap the framebuffer
	call gfx_draw ; draw the contents of the framebuffer (*must* be called once in each iteration!)

	call checkClick_mainMenu
	
	cmp byte[exitGame], 1
	jne .mainLoop

.exit:
	call gfx_destroy

    ret

section .data
    caption db "SNAKE: THE GAME", 0
	infomsg db "Use WASD to move the snake!", 0
	errormsg db "ERROR: could not initialize graphics!", 0

	fileName db "scoreBoard.txt", 0

	char_S db 0x3C, 0x24, 0x20, 0x30, 0x18, 0x0C, 0x24, 0x3C
	char_C db 0x38, 0x44, 0x40, 0x40, 0x40, 0x40, 0x44, 0x38
	char_O db 0x3C, 0x66, 0x42, 0x42, 0x42, 0x42, 0x66, 0x3C
	char_R db 0x38, 0x24, 0x24, 0x24, 0x38, 0x2C, 0x24, 0x24
	char_E db 0x3C, 0x20, 0x20, 0x38, 0x38, 0x20, 0x20, 0x3C
	char_COLON db 0x00, 0x00, 0x18, 0x00, 0x00, 0x18, 0x00, 0x00

	char_P db 0x38, 0x24, 0x24, 0x24, 0x38, 0x20, 0x20, 0x20
	char_L db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x3C
	char_A db 0x18, 0x24, 0x24, 0x3C, 0x24, 0x24, 0x24, 0x24
	char_Y db 0x24, 0x24, 0x24, 0x3C, 0x18, 0x18, 0x18, 0x18
	char_B db 0x38, 0x24, 0x24, 0x28, 0x3C, 0x24, 0x24, 0x38
	char_D db 0x38, 0x24, 0x24, 0x24, 0x24, 0x24, 0x24, 0x38
	char_X db 0x24, 0x14, 0x14, 0x08, 0x10, 0x28, 0x28, 0x24
	char_H db 0x24, 0x24, 0x24, 0x3C, 0x3C, 0x24, 0x24, 0x24
	char_I db 0x3C, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x3C
	char_T db 0x7E, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18

	char_# db 0x24, 0x24, 0x24, 0xFF, 0x24, 0xFF, 0x24, 0x24
	char_G db 0x38, 0x44, 0x40, 0x40, 0x4C, 0x44, 0x44, 0x38
	char_M db 0x42, 0x66, 0x5A, 0x4A, 0x42, 0x42, 0x42, 0x42
	char_W db 0x81, 0x49, 0x55, 0x55, 0x55, 0x55, 0x33, 0x22
	char_Z db 0x7C, 0x04, 0x08, 0x3C, 0x10, 0x20, 0x40, 0x7C
	char_N db 0x42, 0x62, 0x52, 0x52, 0x4A, 0x4A, 0x46, 0x42

	char_U db 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x3C
	char_K db 0x22, 0x24, 0x28, 0x38, 0x30, 0x2C, 0x24, 0x22
	char_F db 0x3C, 0x20, 0x20, 0x38, 0x20, 0x20, 0x20, 0x20
	char_V db 0x42, 0x42, 0x42, 0x42, 0x42, 0x24, 0x24, 0x18
	char_UpArrow db 0x18, 0x24, 0x42, 0x18, 0x18, 0x18, 0x18, 0x18
	char_DownArrow db 0x18, 0x18, 0x18, 0x18, 0x18, 0x42, 0x24, 0x18
	char_LeftArrow db 0x00, 0x20, 0x40, 0x9F, 0x9F, 0x40, 0x20, 0x00
	char_RightArrow db 0x00, 0x04, 0x02, 0xF9, 0xF9, 0x02, 0x04, 0x00

	num_0 db 0x3C, 0x42, 0x42, 0x72, 0x4E, 0x42, 0x42, 0x3C
	num_1 db 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18
	num_2 db 0x18, 0x24, 0x04, 0x18, 0x10, 0x30, 0x24, 0x3C
	num_3 db 0x18, 0x24, 0x04, 0x08, 0x08, 0x04, 0x24, 0x18
	num_4 db 0x08, 0x18, 0x28, 0x28, 0x48, 0x7E, 0x08, 0x08
	num_5 db 0x3C, 0x20, 0x20, 0x20, 0x3C, 0x04, 0x04, 0x3C
	num_6 db 0x18, 0x24, 0x20, 0x20, 0x38, 0x24, 0x24, 0x18
	num_7 db 0x7E, 0x06, 0x0C, 0x0C, 0x18, 0x18, 0x30, 0x30
	num_8 db 0x3C, 0x24, 0x24, 0x3C, 0x3C, 0x24, 0x24, 0x3C
	num_9 db 0x3C, 0x24, 0x24, 0x3C, 0x04, 0x04, 0x04, 0x3C

section .bss
	foodX resd 1
	foodY resd 1

	lengthOfSnake resd 1
	snakeX resd 1024
	snakeY resd 1024

	blue resb 1
	green resb 1
	red resb 1

	snakeBlue resb 1
	snakeGreen resb 1
	snakeRed resb 1

	playActivated resb 1
	exitActivated resb 1
	helpActivated resb 1

	easyActivated resb 1
	normalActivated resb 1
	hardActivated resb 1
	impossibleActivated resb 1

	scoreBoardActivated resb 1

	directionX resd 1
	directionY resd 1

	ok resb 1
	exitGame resb 1
	exitSelectDifficulty resb 1

	score resd 1
	scoreArray resd 256
	lengthOfScoreBoard resd 1

	fps resd 1
	fontSize resd 1
	charOffset resd 1
	elozoLenyomottChar resb 1

	radius resd 1
	addToScore resd 1
	addToLength resd 1

	border_x1 resd 1
	border_y1 resd 1

	border_x2 resd 1
	border_y2 resd 1
