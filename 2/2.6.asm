; wczytywanie i wyswietlanie tekstu wielkimi literami
; (inne znaki sie nie zmieniaja)
.686
.model flat

extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
extern __write : PROC ; (dwa znaki podkreslenia)
extern __read : PROC ; (dwa znaki podkreslenia)

public _main

.data
	liczba_pl_znakow equ 18
	rozmiar_bufora	equ 120

	tekst_pocz			db 10, 'Prosze napisac jakis tekst '
						db 'i nacisnac Enter', 10
	koniec_t			db ?

	magazyn				db rozmiar_bufora dup (0)
	liczba_znakow		dd ?

	pl_znaki_latin2		db 0A5H, 0A4H, 86H, 8FH, 0A9H, 0A8H, 88H, 9DH, 0E4H, 0E3H ; π•Ê∆Í ≥£Ò—
						db 0A2H, 0E0H, 98H, 97H, 0ABH, 8DH, 0BEH, 0BDH ; Û”úåüèøØ
	pl_znaki_win1250	db 0B9H, 0A5H, 0E6H, 0C6H, 0EAH, 0CAH, 0B3H, 0A3H, 0F1H, 0D1H ; π•Ê∆Í ≥£Ò—
						db 0F3H, 0D3H, 9CH, 8CH, 9FH, 8FH, 0BFH, 0AFH ; Û”úåüèøØ
	pl_znaki_unicode	dw 0105H, 0104H, 0107H, 0106H, 0119H, 0118H, 0142H, 0141H, 0144H, 0143H ; π•Ê∆Í ≥£Ò—
						dw 00F3H, 00D3H, 015BH, 015AH, 017AH, 0179H, 017CH, 017BH ; Û”úåüèøØ

	tytul_MessageBoxA	db 'Zadanie 2.6 MessageBoxA', 0
	tytul_MessageBoxW	db 'Z',0,'a',0,'d',0,'a',0,'n',0,'i',0,'e',0,' ',0,'2',0,'.',0,'6',0,' ',0
						db 'M',0,'e',0,'s',0,'s',0,'a',0,'g',0,'e',0,'B',0,'o',0,'x',0,'W',0,0,0
	tekst_MessageBoxW	dw rozmiar_bufora dup (0)

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
		push rozmiar_bufora-1 ; maksymalna liczba znakÛw
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
		mov ebx, 0 ; indeks poczatkowy dla znakÛw kodowanych windows1250
		mov edi, 0 ; indeks docelowy dla znakow kodowanych unicode

	ptl: 
		mov dh, 0 ; zerowanie starszej czÍsci znaku w unicode
		mov dl, magazyn[ebx] ; pobranie kolejnego znaku

		cmp dl, 86H ; sprawdzamy czy znak jest mniejszy od Ê
		jb dalej ; skok, gdy znak nie wymaga zamiany

		; porownujemy aktualnie pobrany znak ze znakami z tablic kodowych
		; przeszukujac je od tylu
		mov eax, liczba_pl_znakow ; ustawiamy licznik zagniezdzonej petli
		ptl2:
			cmp eax, 0 ; sprawdzamy czy licznik nie osiagnal 0
			je dalej ; jezeli tak to konczymy nie wpisujac znaku do magazynu(nie nie zamienilismy)

			dec eax ; zmniejszamy licznik
			cmp dl, pl_znaki_latin2[eax] ; sprawdzamy znak
			jne ptl2

		mov dl, pl_znaki_win1250[eax] ; zmieniamy kodowanie znaku na windows1250 
		mov magazyn[ebx], dl ; odes≥anie znaku do pamieci

		mov dx, pl_znaki_unicode[2*eax] ; przes≥anie odpowiedniego znaku unicode do rejestru

	dalej: 
		mov tekst_MessageBoxW[edi], dx ; odes≥anie znaku kodowanego unicode do pamiÍci
		inc ebx ; inkrementacja indeksu znakow windows1250
		add edi, 2 ; inkrementacja indeksu znakow unicode
		dec ecx ; dekrementacja indeksu petli
		jnz ptl ; sterowanie petla

		; wyswietlenie MessageBoxA
		push 4 ; YES/NO
		push OFFSET tytul_MessageBoxA ; adres obszaru zawierajacego tytu≥
		push OFFSET magazyn ; adres obszaru zawierajacego tekst
		push 0 ; NULL
		call _MessageBoxA@16

		; wyswietlenie MessageBoxW
		push 4 ; YES/NO
		push OFFSET tytul_MessageBoxW
		push OFFSET tekst_MessageBoxW
		push 0
		call _MessageBoxW@16

		push 0
		call _ExitProcess@4 ; zakonczenie programu
END