.686
.model flat

extern __write : PROC
extern _ExitProcess@4 : PROC

public _main

.data

	znaki db 12 dup (?)

.code

wyswietl_EAX PROC
	pusha

	mov esi, 11 ; indeks w tablicy 'znaki'
	mov ebx, 10 ; dzielnik równy 10

od_nowa:
	mov edx, 0 ; zerowanie starszej czesci dzielnej
	div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX

	; zamiana reszty z dzielenia na kod ASCII
	add dl, 30H
	mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII

	dec esi ; zmniejszenie indeksu
	cmp eax, 0 ; sprawdzenie czy iloraz = 0
	jne od_nowa ; skok, gdy iloraz niezerowy

wypeln:
	; wype³nienie pozosta³ych bajtów spacjami
	; i wpisanie znaku nowego wiersza
	mov byte PTR znaki [esi], 20H ; kod spacji
	dec esi ; zmniejszenie indeksu
	jnz wypeln
	mov byte PTR znaki [esi], 0AH ; kod nowego wiersza

	; wyswietlenie cyfr na ekranie
	push dword PTR 12 ; liczba wyswietlanych znaków
	push dword PTR OFFSET znaki ; adres wysw. obszaru
	push dword PTR 1; numer urzadzenia (ekran ma numer 1)
	call __write ; wyswietlenie liczby na ekranie
	add esp, 12 ; usuniecie parametrów ze stosu

	popa
	ret
wyswietl_EAX ENDP

_main:
	mov ecx, 0 ; licznik petli
	mov eax, 1 ; aktualnie wypisywana liczba

ptl:
	cmp ecx, 50 ; sprawdzamy czy wypisalismy juz dostateczna ilosc liczb
	je koniec
	add eax, ecx
	call wyswietl_EAX
	inc ecx ; zwiekszamy licznik petli
	jmp ptl

koniec:
	push 0
	call _ExitProcess@4

END