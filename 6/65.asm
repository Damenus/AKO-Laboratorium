; Program linie.asm
; Wyswietlanie znak�w * w takt przerwan zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakonczenie programu po nacisnieciu dowolnego klawisza
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy
linia PROC
; przechowanie rejestr�w
push ax
push bx
push es
mov ax, 0A000H ; adres pamieci ekranu dla trybu 13H
mov es, ax
mov bx, cs:adres_piksela ; adres biezacy piksela
mov al, cs:kolor
mov es:[bx], al ; wpisanie kodu koloru do pamieci ekranu
; przejscie do nastepnego wiersza na ekranie
add bx, 322
; sprawdzenie czy ca�a linia wykreslona
cmp bx, 320*200
jb dalej ; skok, gdy linia jeszcze nie wykreslona
; kreslenie linii zosta�o zakonczone - nastepna linia bedzie
; kreslona w innym kolorze o 10 pikseli dalej
add word PTR cs:przyrost, 10
mov bx, 10
add bx, cs:przyrost
inc cs:kolor ; kolejny kod koloru
; zapisanie adresu biezacego piksela
dalej:
mov cs:adres_piksela, bx
; odtworzenie rejestr�w
pop es
pop bx
pop ax
; skok do oryginalnego podprogramu obs�ugi przerwania
; zegarowego
jmp dword PTR cs:wektor8
; zmienne procedury
kolor db 2 ; biezacy numer koloru
adres_piksela dw 10 ; biezacy adres piksela
przyrost dw 0
wektor8 dd ?
linia ENDP
; INT 10H, funkcja nr 0 ustawia tryb sterownika graficznego
zacznij:
mov ah, 0
mov al, 13H ; nr trybu
int 10H
mov bx, 0
mov es, bx ; zerowanie rejestru ES
mov eax, es:[32] ; odczytanie wektora nr 8
mov cs:wektor8, eax; zapamietanie wektora nr 8
; adres procedury 'linia' w postaci segment:offset
mov ax, SEG linia
mov bx, OFFSET linia
cli ; zablokowanie przerwan
; zapisanie adresu procedury 'linia' do wektora nr 8
mov es:[32], bx
mov es:[32+2], ax
sti ; odblokowanie przerwan
czekaj:
mov ah, 1 ; sprawdzenie czy jest jakis znak
int 16h ; w buforze klawiatury
jz czekaj
mov ah, 0 ; funkcja nr 0 ustawia tryb sterownika
mov al, 3H ; nr trybu
int 10H
; odtworzenie oryginalnej zawartosci wektora nr 8
mov eax, cs:wektor8
mov es:[32], eax
; zakonczenie wykonywania programu
mov ax, 4C00H
int 21H
rozkazy ENDS
stosik SEGMENT stack
db 256 dup (?)
stosik ENDS
END zacznij