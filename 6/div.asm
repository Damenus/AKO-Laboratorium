.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy

obsluga_wyjatku PROC


	jmp dword PTR cs:wektor0

	wektor0 dd ?
obsluga_wyjatku ENDP

zacznij:
	mov eax,ds:[0]
	mov cs:wektor0, eax
	
	mov ax, SEG obsluga_wyjatku
	mov bx, OFFSET obsluga_wyjatku
	cli
	mov ds:[0], bx
	mov ds:[2], ax
	sti

	; deinstalacja procedury obs³ugi przerwania zegarowego
	; odtworzenie oryginalnej zawartosci wektora nr 8
	mov eax, cs:wektor0
	cli
	mov ds:[0], eax ;odes³anie wektora nr 8 do pamieci
	sti
	
	mov al, 0
	mov ah, 4CH
	int 21H
rozkazy ENDS

nasz_stos SEGMENT stack
	db 128 dup (?)
nasz_stos ENDS

END zacznij