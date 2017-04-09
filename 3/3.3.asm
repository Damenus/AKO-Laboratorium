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

wczytaj_do_EAX PROC
; wczytywanie liczby dziesietnej z klawiatury – liczba po
; konwersji na postac binarna zostaje wpisana do rejestru EAX
; po wprowadzeniu ostatniej cyfry naley nacisnac klawisz
; Enter

	push ebx
	push esi
	push edi

	push dword PTR 12 ; max ilosc znaków wczytywanej liczby
	push dword PTR OFFSET obszar ; adres obszaru pamieci
	push dword PTR 0; numer urzadzenia (0 dla klawiatury)
	call __read ; odczytywanie znaków z klawiatury(dwa znaki podkreslenia przed read)
	add esp, 12 ; usuniecie parametrów ze stosu

	; zamiana cyfr w kodzie ASCII na liczbe binarna
	mov esi, 0 ; bieaca wartosc przekszta³canej liczby przechowywana jest
	; w rejestrze ESI; przyjmujemy 0 jako wartosc poczatkowa
	mov ebx, OFFSET obszar ; adres obszaru ze znakami

; pobranie kolejnej cyfry w kodzie ASCII
nowy:
	mov al, [ebx]
	inc ebx ; zwiekszenie indeksu
	cmp al,10 ; sprawdzenie czy nacisnieto Enter
	je byl_enter ; skok, gdy nacisnieto Enter
	sub al, 30H ; zamiana kodu ASCII na wartosc cyfry
	movzx edi, al ; przechowanie wartosci cyfry w rejestrze EDI
	mov eax, 10 ; mnozna
	mul esi ; mnozenie wczesniej obliczonej wartosci razy 10
	add eax, edi ; dodanie ostatnio odczytanej cyfry
	mov esi, eax ; dotychczas obliczona wartosc
	jmp nowy

byl_enter:
	mov eax, esi ; przepisanie wyniku konwersji do rejestru EAX
	; wartosc binarna wprowadzonej liczby znajduje sie teraz w rejestrze EAX

	pop edi
	pop esi
	pop ebx
	ret

wczytaj_do_EAX ENDP

_main:
	call wczytaj_do_EAX
	mul eax ; podnosimy do kwadratu
	call wyswietl_EAX

koniec:
	push 0
	call _ExitProcess@4

END