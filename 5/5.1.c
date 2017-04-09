#include <stdio.h>
#include <stdlib.h>

float srednia_harm(float * tablica, unsigned int n);

int main()
{
	int n;
	printf("Podaj ilosc liczb: ");
	scanf_s("%d", &n);

	float *liczby = (float*)malloc(n * sizeof(float));

	printf("Podaj liczby: \n");
	for (int i = 0; i < n; ++i)
		scanf_s("%f", liczby+i);

	printf("\nSrednia harmoniczna podanych liczb: %f", srednia_harm(liczby, n));

	free(liczby);
	return 0;
}