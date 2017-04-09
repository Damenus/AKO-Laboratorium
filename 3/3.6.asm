.686
.model flat

extern __read : PROC
extern __write : PROC
extern _ExitProcess@4 : PROC

public _main

.data

	; deklaracja tablicy do przechowywania wprowadzanych cyfr
	obszar db 12 dup (?)
	; deklaracja tablicy do przechowywania wyswietlanych cyfr
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

wczytaj_do_EAX_hex PROC
; wczytywanie liczby szesnastkowej z klawiatury – liczba po
; konwersji na postac binarna zostaje wpisana do rejestru EAX
; po wprowadzeniu ostatniej cyfry naley nacisnac klawisz Enter
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

	; rezerwacja 12 bajtów na stosie przeznaczonych na tymczasowe
	; przechowanie cyfr szesnastkowych wyswietlanej liczby
	sub esp, 12 ; rezerwacja poprzez zmniejszenie ESP
	mov esi, esp ; adres zarezerwowanego obszaru pamieci

	push dword PTR 10 ; max ilosc znaków wczytyw. liczby
	push esi ; adres obszaru pamieci
	push dword PTR 0; numer urzadzenia (0 dla klawiatury)
	call __read ; odczytywanie znaków z klawiatury(dwa znaki podkreslenia przed read)
	add esp, 12 ; usuniecie parametrów ze stosu
	mov eax, 0 ; dotychczas uzyskany wynik

pocz_konw:
	mov dl, [esi] ; pobranie kolejnego bajtu
	inc esi ; inkrementacja indeksu
	cmp dl, 10 ; sprawdzenie czy nacisnieto Enter
	je gotowe ; skok do konca podprogramu

	; sprawdzenie czy wprowadzony znak jest cyfra 0, 1, 2 , ..., 9
	cmp dl, '0'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, '9'
	ja sprawdzaj_dalej
	sub dl, '0' ; zamiana kodu ASCII na wartosc cyfry

dopisz:
	shl eax, 4 ; przesuniecie logiczne w lewo o 4 bity
	or al, dl ; dopisanie utworzonego kodu 4-bitowego na 4 ostatnie bity rejestru EAX
	jmp pocz_konw ; skok na poczatek petli konwersji

; sprawdzenie czy wprowadzony znak jest cyfra A, B, ..., F
sprawdzaj_dalej:
	cmp dl, 'A'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'F'
	ja sprawdzaj_dalej2
	sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
	jmp dopisz

	; sprawdzenie czy wprowadzony znak jest cyfra a, b, ..., f
	sprawdzaj_dalej2:
	cmp dl, 'a'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'f'
	ja pocz_konw ; inny znak jest ignorowany
	sub dl, 'a' - 10
	jmp dopisz

gotowe:
	; zwolnienie zarezerwowanego obszaru pamieci
	add esp, 12
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX_hex ENDP

_main:
	call wczytaj_do_EAX_hex
	call wyswietl_EAX

koniec:
	push 0
	call _ExitProcess@4

END