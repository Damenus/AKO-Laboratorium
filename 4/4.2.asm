.686
.model flat

.code
_plus_jeden PROC
	push ebp ; zapisanie zawartosci EBP na stosie
	mov ebp,esp ; kopiowanie zawartosci ESP do EBP
	push ebx ; przechowanie zawartosci rejestru EBX

	; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
	; w kodzie w jezyku C
	mov ebx, [ebp+8]
	neg dword ptr [ebx] ; wyznaczenie liczby przeciwnej

	pop ebx
	pop ebp
	ret
_plus_jeden ENDP
END