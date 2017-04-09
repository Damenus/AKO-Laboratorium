/* Program przyk³adowy ilustrujacy operacje SSE procesora
Program jest przystosowany do wspó³pracy z podprogramem
zakodowanym w asemblerze (plik arytm_SSE.asm)
*/
#include <stdio.h>

void suma(char* a1, char* a2, char* wynik);
void int2float(int * calkowite, float * zmienno_przec);
void pm_jeden(float * tabl);

int main()
{
	// ###
	// 5.3
	char liczby_A[16] = { -128, -127, -126, -125, -124, -123, -122, -121, 120, 121, 122, 123, 124, 125, 126, 127 };
	char liczby_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3, 3, 3, 3, 3, 3, 3, 3, 3 };
	char wynik[16];
	suma(liczby_A, liczby_B, wynik);
	for (int i = 0 ; i < 16; ++i)
		printf("%d ", (int)wynik[i]);

	// ###
	// 5.4
	int a[2] = { -17, 24 };
	float r[2];
	int2float(a, r);
	printf("\nKonwersja = %f %f\n", r[0], r[1]);

	// ###
	// 5.5
	float tablica[4] = { 27.5, 143.57, 2100.0, -3.51 };
	printf("\n%f %f %f %f\n", tablica[0],
		tablica[1], tablica[2], tablica[3]);
	pm_jeden(tablica);
	printf("\n%f %f %f %f\n", tablica[0],
		tablica[1], tablica[2], tablica[3]);

	return 0;
}