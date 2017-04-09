.686
.model flat

extern __read : PROC
extern _ExitProcess@4 : PROC

public _main

.data

	; deklaracja tablicy do przechowywania wprowadzanych cyfr
	obszar db 12 dup (?)

.code

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

koniec:
	push 0
	call _ExitProcess@4

END