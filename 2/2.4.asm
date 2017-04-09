; wczytywanie i wyswietlanie tekstu wielkimi literami
; (inne znaki sie nie zmieniaja)
.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreslenia)
extern __read : PROC ; (dwa znaki podkreslenia)

public _main

.data
	tekst_pocz		db 10, 'Prosze napisac jakis tekst '
					db 'i nacisnac Enter', 10
	koniec_t		db ?
	magazyn			db 80 dup (?)
	nowa_linia		db 10
	liczba_znakow	dd ?
	latin2_male		db 0A5H, 86H, 0A9H,  88H,  0E4H, 0A2H, 98H, 0ABH, 0BEH ; πÊÍ≥ÒÛúüø
	latin2_wielkie	db 0A4H, 8FH, 0A8H, 9DH, 0E3H,  0E0H, 97H,  8DH,  0BDH ; •∆ £—”åèØ
.code
	_main:
		; wyswietlenie tekstu informacyjnego
		; liczba znakÛw tekstu
		mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
		push ecx
		push OFFSET tekst_pocz ; adres tekstu
		push 1 ; nr urzadzenia (tu: ekran - nr 1)
		call __write ; wyswietlenie tekstu poczatkowego
		add esp, 12 ; usuniecie parametrÛw ze stosu

		; czytanie wiersza z klawiatury
		push 80 ; maksymalna liczba znakÛw
		push OFFSET magazyn
		push 0 ; nr urzadzenia (tu: klawiatura - nr 0)
		call __read ; czytanie znakÛw z klawiatury
		add esp, 12 ; usuniecie parametrÛw ze stosu

		; kody ASCII napisanego tekstu zosta≥y wprowadzone
		; do obszaru 'magazyn'
		; funkcja read wpisuje do rejestru EAX liczbe
		; wprowadzonych znakÛw
		mov liczba_znakow, eax

		; rejestr ECX pe≥ni role licznika obiegÛw petli
		mov ecx, eax
		mov ebx, 0 ; indeks poczatkowy

	ptl: 
		mov dl, magazyn[ebx] ; pobranie kolejnego znaku

		cmp dl, 'a'
		jb dalej ; skok, gdy znak nie wymaga zamiany
		cmp dl, 'z'
		ja polskie_znaki ; skok jeøeli moøe byÊ to polski znak

		sub dl, 20H ; zamiana na wielkie litery
		jmp dalej_z_wpisem

	polskie_znaki:
		mov esi, 0 ; indeks petli zagniezdzonej
		ptl2:		
			inc esi
			cmp esi, 10
			je dalej ; skok, bo nie znalezlismy znaku

			cmp dl, latin2_male[esi-1]
			jne ptl2

		mov dl, latin2_wielkie[esi-1]
	
	dalej_z_wpisem:
		; odes≥anie znaku do pamieci
		mov magazyn[ebx], dl

	dalej: 
		inc ebx ; inkrementacja indeksu wskazujacego na kolejny znak
		dec ecx ; zmniejszamy licznik petli o 1
		jnz ptl ; sterowanie petla

		; wyswietlenie przekszta≥conego tekstu
		push liczba_znakow
		push OFFSET magazyn
		push 1
		call __write ; wyswietlenie przekszta≥conego tekstu
		add esp, 12 ; usuniecie parametrÛw ze stosu

		push 0
		call _ExitProcess@4 ; zakonczenie programu
END