; Program gwiazdki.asm
; Wyswietlanie znaków * w takt przerwan zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakonczenie programu po nacisnieciu klawisza 'x'
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;

.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
;============================================================
; procedura obs³ugi przerwania zegarowego
obsluga_zegara PROC
	; przechowanie uzywanych rejestrów
	push ax
	push bx
	push es
	
	; wpisanie adresu pamieci ekranu do rejestru ES - pamiec
	; ekranu dla trybu tekstowego zaczyna sie od adresu B8000H,
	; jednak do rejestru ES wpisujemy wartosc B800H,
	; bo w trakcie obliczenia adresu procesor kazdorazowo mnozy
	; zawartosc rejestru ES przez 16
	mov ax, 0B800h ;adres pamieci ekranu
	mov es, ax
	
	;wyliczenie pozycji gwiazdki
	mov al, cs:licznik_y
	mov ah, 80
	mul ah
	mov bx, cs:licznik_x
	add bx, ax
	
	; przes³anie do pamieci ekranu kodu ASCII wyswietlanego znaku
	; i kodu koloru: bia³y na czarnym tle (do nastepnego bajtu)
	mov byte PTR es:[bx], '*' ; kod ASCII
	mov byte PTR es:[bx+1], 00011110B ; kolor
	
	; zwiekszenie o 2 adresu biezacego w pamieci ekranu
	add cs:licznik_y, 2
	cmp cs:licznik_y, 50
	jne koniec
	mov cs:licznik_y, 0
	add cs:licznik_x, 2
	cmp cs:licznik_x, 160
	jne koniec
	mov cs:licznik_x, 0
	
koniec:

	; odtworzenie rejestrów
	pop es
	pop bx
	pop ax
	
	; skok do oryginalnej procedury obs³ugi przerwania zegarowego
	jmp dword PTR cs:wektor8
	
	; dane programu ze wzgledu na specyfike obs³ugi przerwan
	; umieszczone sa w segmencie kodu
	licznik_y db 0
	licznik_x dw 0
	wektor8 dd ?
obsluga_zegara ENDP

;============================================================
; program g³ówny - instalacja i deinstalacja procedury
; obs³ugi przerwan
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
	mov al, 0
	mov ah, 5
	int 10
	mov ax, 0
	mov ds,ax ; zerowanie rejestru DS
	
	; odczytanie zawartosci wektora nr 8 i zapisanie go
	; w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamieci 4 bajty
	; poczawszy od adresu fizycznego 8 * 4 = 32)
	mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
	mov cs:wektor8, eax
	
	; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
	mov ax, SEG obsluga_zegara ; czesc segmentowa adresu
	mov bx, OFFSET obsluga_zegara ; offset adresu
	cli ; zablokowanie przerwan
	; zapisanie adresu procedury do wektora nr 8
	mov ds:[32], bx ; OFFSET
	mov ds:[34], ax ; cz. segmentowa
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
	cmp al, 'x' ; porównanie z kodem litery 'x'
	jne aktywne_oczekiwanie ; skok, gdy inny znak
	
	; deinstalacja procedury obs³ugi przerwania zegarowego
	; odtworzenie oryginalnej zawartosci wektora nr 8
	mov eax, cs:wektor8
	cli
	mov ds:[32], eax ;odes³anie wektora nr 8 do pamieci
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