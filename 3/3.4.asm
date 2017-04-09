.686
.model flat

extern __read : PROC
extern __write : PROC
extern _ExitProcess@4 : PROC

public _main

.data

	; deklaracja tablicy do przechowywania wprowadzanych cyfr
	obszar db 12 dup (?)

	dekoder db '0123456789ABCDEF'

.code

wyswietl_EAX_hex PROC
; wyswietlanie zawartosci rejestru EAX
; w postaci liczby szesnastkowej

	pusha ; przechowanie rejestrów

	; rezerwacja 12 bajtów na stosie (poprzez zmniejszenie rejestru ESP) 
	; przeznaczonych na tymczasowe przechowanie cyfr szesnastkowych wyswietlanej liczby
	sub esp, 12
	mov edi, esp ; adres zarezerwowanego obszaru pamieci

	; przygotowanie konwersji
	mov ecx, 8 ; liczba obiegów petli konwersji
	mov esi, 1 ; indeks poczatkowy uywany przy zapisie cyfr

	; petla konwersji
ptl3hex:
	; przesuniecie cykliczne (obrót) rejestru EAX o 4 bity w lewo
	; w szczególnosci, w pierwszym obiegu petli bity nr 31 - 28
	; rejestru EAX zostana przesuniete na pozycje 3 - 0
	rol eax, 4
	; wyodrebnienie 4 najm³odszych bitów i odczytanie z tablicy
	; 'dekoder' odpowiadajacej im cyfry w zapisie szesnastkowym
	mov ebx, eax ; kopiowanie EAX do EBX
	and ebx, 0000000FH ; zerowanie bitów 31 - 4 rej.EBX
	mov dl, dekoder[ebx] ; pobranie cyfry z tablicy	
	mov [edi][esi], dl ; przes³anie cyfry do obszaru roboczego
	inc esi ;inkrementacja modyfikatora
	loop ptl3hex ; sterowanie petla

	; wpisanie znaku nowego wiersza przed i po cyfrach
	mov byte PTR [edi][0], 10
	mov byte PTR [edi][9], 10

	; wyswietlenie przygotowanych cyfr
	push 10 ; 8 cyfr + 2 znaki nowego wiersza
	push edi ; adres obszaru roboczego
	push 1 ; nr urzadzenia (tu: ekran)
	call __write ; wyswietlenie

	; usuniecie ze stosu 24 bajtów, w tym 12 bajtów zapisanych
	; przez 3 rozkazy push przed rozkazem call
	; i 12 bajtów zarezerwowanych na poczatku podprogramu
	add esp, 24
	popa ; odtworzenie rejestrów
	ret ; powrót z podprogramu
wyswietl_EAX_hex ENDP

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
	call wyswietl_EAX_hex

koniec:
	push 0
	call _ExitProcess@4

END