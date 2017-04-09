#include <stdio.h>

void plus_jeden(int * a);

int main()
{
	int m;
	printf("Prosze podac liczbe: ");
	scanf("%d", &m);
	plus_jeden(&m);
	printf("\n liczba odwrotna do podanej to: %d\n", m);

return 0;
}