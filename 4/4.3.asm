.686
.model flat

.code
_odejmij_jeden PROC
	push ebp ; zapisanie zawartosci EBP na stosie
	mov ebp,esp ; kopiowanie zawartosci ESP do EBP
	push ebx ; przechowanie zawartosci rejestru EBX

	; wpisanie do rejestru EBX adresu adresu zmiennej zdefiniowanej
	; w kodzie w jezyku C
	mov ebx, [ebp+8]
	mov ebx, [ebx] ; wpisanie do ebx wlasciwego adresu zmiennej
	dec dword ptr [ebx] ; zmniejszenie liczby o 1

	pop ebx
	pop ebp
	ret
_odejmij_jeden ENDP
END