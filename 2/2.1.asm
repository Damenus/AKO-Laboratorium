; program przyk³adowy (wersja 32-bitowa)
.686
.model flat

extrn _ExitProcess@4 : near
extrn __write : near ; (dwa znaki podkreslenia)
public _main

.data
	tekst	db 10, 'Nazywam si', 0A9H, '. . . ' , 10, 'M' , 0A2H
			db 'j pierwszy 32-bitowy program asemblerowy dzia', 88H
			db 'a ju', 0BEH, ' poprawnie!', 10

.code
	_main:
		mov ecx, 85 ; liczba znaków wyswietlanego tekstu
		; wywo³anie funkcji ”write” z biblioteki jezyka C
		push ecx ; liczba znaków wyswietlanego tekstu
		push dword PTR OFFSET tekst ; po³oenie obszaru
		; ze znakami
		push dword PTR 1 ; uchwyt urzadzenia wyjsciowego
		call __write ; wyswietlenie znaków
		; (dwa znaki podkreslenia _ )
		add esp, 12 ; usuniecie parametrów ze stosu
		; zakonczenie wykonywania programu
		push dword PTR 0 ; kod powrotu programu
		call _ExitProcess@4
END