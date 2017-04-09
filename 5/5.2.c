#include <stdio.h>
#include <stdlib.h>

float nowy_exp(float x);

int main()
{
	float n;
	printf("Podaj liczbe: ");
	scanf_s("%f", &n);

	printf("\Wynik: %f", nowy_exp(n));

	return 0;
}