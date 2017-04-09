#include <stdio.h>

__int64 suma_siedmiu_liczb (__int64 v1, __int64 v2, __int64
v3, __int64 v4, __int64 v5, __int64 v6, __int64 v7);

int main()
{
	__int64 l[7];
	int i;
	printf("Prosze podac 7 liczb: ");
	for(i = 0; i < 7; ++i)
		scanf("%lld", l + i);
	
	printf("Suma podanych liczb to: %lld\n", suma_siedmiu_liczb(l[0], l[1], l[2], l[3], l[4], l[5], l[6]));
	return 0;
}