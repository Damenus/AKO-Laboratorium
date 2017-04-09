.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy

wyswietl_AL PROC
	; wyswietlanie zawartosci rejestru AL na ekranie wg adresu
	; podanego w ES:BX
	; stosowany jest bezposredni zapis do pamieci ekranu
	; przechowanie rejestrów
	push ax
	push cx
	push dx
	push es
	
	mov cx, 0B800h ;adres pamieci ekranu
	mov es, cx
	
	mov cl, 10 ; dzielnik
	mov ah, 0 ; zerowanie starszej czesci dzielnej
	; dzielenie liczby w AX przez liczbe w CL, iloraz w AL,
	; reszta w AH (tu: dzielenie przez 10)
	div cl
	add ah, 30H ; zamiana na kod ASCII
	mov es:[bx+4], ah ; cyfra jednosci
	mov ah, 0
	div cl ; drugie dzielenie przez 10
	add ah, 30H ; zamiana na kod ASCII
	mov es:[bx+2], ah ; cyfra dziesiatek
	add al, 30H ; zamiana na kod ASCII
	mov es:[bx+0], al ; cyfra setek
	; wpisanie kodu koloru (intensywny bia³y) do pamieci ekranu
	mov al, 00001111B
	mov es:[bx+1],al
	mov es:[bx+3],al
	mov es:[bx+5],al
	; odtworzenie rejestrów
	pop es
	pop dx
	pop cx
	pop ax
	ret ; wyjscie
wyswietl_AL ENDP

obsluga_klawiatury PROC
	push ax
	push bx
	
	in al, 60h
	mov bx, 320
	call wyswietl_al
	
	pop bx
	pop ax
	jmp dword PTR cs:wektor9

	wektor9 dd ?
obsluga_klawiatury ENDP

zacznij:
	mov al, 0
	mov ah, 5
	int 10
	mov ax, 0
	mov ds,ax ; zerowanie rejestru DS

		
	; odczytanie zawartosci wektora nr 8 i zapisanie go w zmiennej 'wektor9'
	mov eax,ds:[36] 
	mov cs:wektor9, eax
	
	; wpisanie do wektora nr 8 adresu procedury 'obsluga_klawiatury'
	mov ax, SEG obsluga_klawiatury ; czesc segmentowa adresu
	mov bx, OFFSET obsluga_klawiatury ; offset adresu
	cli ; zablokowanie przerwan
	; zapisanie adresu procedury do wektora nr 9
	mov ds:[36], bx ; OFFSET
	mov ds:[38], ax ; cz. segmentowa
	sti ;odblokowanie przerwan

	; oczekiwanie na nacisniecie klawisza 'x'
aktywne_oczekiwanie:
	mov ah,1
	int 16H ; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 jeslinacisnieto jakis klawisz
	jz aktywne_oczekiwanie
	
	; odczytanie kodu ASCII nacisnietego klawisza (INT 16H, AH=0)
	; do rejestru AL
	mov ah, 0
	int 16H
	mov bx, 320
	call wyswietl_AL
	cmp al, 'x' ; porównanie z kodem litery 'x'
	jne aktywne_oczekiwanie ; skok, gdy inny znak
	
	; deinstalacja procedury obs³ugi przerwania zegarowego
	; odtworzenie oryginalnej zawartosci wektora nr 8
	mov eax, cs:wektor9
	cli
	mov ds:[36], eax ;odes³anie wektora nr 9 do pamieci
	sti
	
	; zakonczenie programu
	mov al, 0
	mov ah, 4CH
	int 21H
rozkazy ENDS

nasz_stos SEGMENT stack
	db 128 dup (?)
nasz_stos ENDS

END zacznij