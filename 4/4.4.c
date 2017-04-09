#include <stdio.h>
#include <stdlib.h>

#define NUM_COUNT 20

void przestaw(int* a, int c);


void printArray(int* a, int c)
{
	int i;
	for(i = 0; i < c; ++i)
		printf("%d ", a[i]);
}

int main()
{
	int a[NUM_COUNT];

	int i;
	for(i = 0; i < NUM_COUNT; ++i)
		a[i] = (rand() - RAND_MAX / 2) % 100; 

	printf("Tablica poczatkowa: ");
	printArray(a, NUM_COUNT);

	for(i = 0; i < NUM_COUNT - 1; ++i)
		przestaw(a, NUM_COUNT - i);

	printf("\nTablica wynikowa: ");
	printArray(a, NUM_COUNT);

	return 0;
}