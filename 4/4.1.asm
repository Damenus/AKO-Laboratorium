.686
.model flat

public _szukaj4_max

.code
_szukaj4_max PROC
	push ebp ; zapisanie zawartosci EBP na stosie
	mov ebp, esp ; kopiowanie zawartosci ESP do EBP

	; w eax przechowywana jest aktualnie najwieksza liczba
	mov eax, [ebp + 20] ; na poczatek umieszczamy tam d
	mov ecx, 3 ; musimy sprawdzic 3 kolejne liczby
ptl:
	mov edx, [ebp + 4 + 4 * ecx]  ; kolejna liczba
	cmp eax, edx ; porownanie aktualnie najwiekszej liczby z
				 ; nastepna w kolejnosci z pozostalych liczb
	jge wieksza ; jezeli aktualna liczba jest wieksza to sprawdzamy kolejna
	mov eax, edx ; jezeli jest mniejsza to na jej miejsce wpisujemy sprawdzana
wieksza:
	loop ptl

	pop ebp
	ret
_szukaj4_max ENDP

END