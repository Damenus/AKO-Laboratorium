.686
.model flat

public _srednia_harm

.code
_srednia_harm PROC
	push ebp
	mov ebp, esp
	push edi
	mov eax, [ebp + 12] ; ilosc liczb
	mov edi, [ebp + 8] ; adres tablicy z liczbami

	finit
	fldz ; miejsce na sume odwrotnosci liczb

	xor ecx, ecx ; licznik petli
ptl:
	fld1
	fld dword ptr [edi + 4*ecx]

	fdivp st(1), st(0)
	faddp st(1), st(0)

	inc ecx
	cmp ecx, eax
	jne ptl

	; n / suma_odwr
	fild dword ptr [ebp + 12] ; ilosc liczb
	fdivrp st(1), st(0)

	pop edi
	pop ebp
	ret
_srednia_harm ENDP

END