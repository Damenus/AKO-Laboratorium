; wczytywanie i wyswietlanie tekstu wielkimi literami
; (inne znaki sie nie zmieniaja)
.686
.model flat

extern _ExitProcess@4 : PROC
extern _GetStdHandle@4 : PROC
extern _SetConsoleTextAttribute@8 : PROC
extern __write : PROC ; (dwa znaki podkreslenia)
extern __read : PROC ; (dwa znaki podkreslenia)

public _main

.data
	FG_BRIGHT_GREEN equ 10
	STD_OUTPUT_HANDLE equ -11

	handle			dd ?

	tekst_pocz		db 10, 'Prosze napisac jakis tekst '
					db 'i nacisnac Enter', 10
	koniec_t		db ?
	magazyn			db 80 dup (?)
	nowa_linia		db 10
	liczba_znakow	dd ?

.code
	_main:
		; wyswietlenie tekstu informacyjnego
		; liczba znaków tekstu
		mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
		push ecx
		push OFFSET tekst_pocz ; adres tekstu
		push 1 ; nr urzadzenia (tu: ekran - nr 1)
		call __write ; wyswietlenie tekstu poczatkowego
		add esp, 12 ; usuniecie parametrów ze stosu

		; czytanie wiersza z klawiatury
		push 80 ; maksymalna liczba znaków
		push OFFSET magazyn
		push 0 ; nr urzadzenia (tu: klawiatura - nr 0)
		call __read ; czytanie znaków z klawiatury
		add esp, 12 ; usuniecie parametrów ze stosu

		; kody ASCII napisanego tekstu zosta³y wprowadzone
		; do obszaru 'magazyn'
		; funkcja read wpisuje do rejestru EAX liczbe
		; wprowadzonych znaków
		mov liczba_znakow, eax

		; rejestr ECX pe³ni role licznika obiegów petli
		mov ecx, eax
		mov ebx, 0 ; indeks poczatkowy

	ptl: 
		mov dl, magazyn[ebx] ; pobranie kolejnego znaku

		cmp dl, 'a'
		jb dalej ; skok, gdy znak nie wymaga zamiany
		cmp dl, 'z'
		ja dalej ; skok, gdy znak nie wymaga zamiany

		sub dl, 20H ; zamiana na wielkie litery

		; odes³anie znaku do pamieci
		mov magazyn[ebx], dl

	dalej: 
		inc ebx ; inkrementacja indeksu
		loop ptl ; sterowanie petla

		; uzyskanie uchwytu na wyjscie konsoli
		push STD_OUTPUT_HANDLE
		call _GetStdHandle@4
		mov handle, eax

		; zmiana koloru wyswietlanego tekstu
		push FG_BRIGHT_GREEN
		push handle
		call _SetConsoleTextAttribute@8

		; wyswietlenie przekszta³conego tekstu
		push liczba_znakow
		push OFFSET magazyn
		push 1
		call __write ; wyswietlenie przekszta³conego tekstu
		add esp, 12 ; usuniecie parametrów ze stosu

		push 0
		call _ExitProcess@4 ; zakonczenie programu
END