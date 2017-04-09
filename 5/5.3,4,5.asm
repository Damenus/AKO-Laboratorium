; Program przyk³adowy ilustrujacy operacje SSE procesora
; Poniszy podprogram jest przystosowany do wywo³ywania
; z poziomu jezyka C (program arytmc_SSE.c)

.686
.XMM ; zezwolenie na asemblacje rozkazów grupy SSE
.model flat

public _suma
.data 
jedynki dd 1.0,1.0,1.0,1.0
.code
_suma PROC

	mov eax, [esp + 4] ; 1 tablica
	mov ecx, [esp + 8] ; 2 tablica
	mov edx, [esp + 12] ; tablica wynikowa
	movups xmm0, [eax]
	movups xmm1, [ecx]
 
	paddsb xmm0, xmm1

	movups [edx], xmm0

	ret
_suma ENDP

_int2float PROC

	mov eax, [esp + 4] ; liczby calkowite
	mov edx, [esp + 8] ; tablica wynikowa

	cvtpi2ps xmm0, qword ptr [eax]

	movlps qword ptr [edx], xmm0

	ret
_int2float ENDP

_pm_jeden PROC

	mov edx, [esp + 4] ; tablica z liczbami
	movups xmm0, [edx]
	movups xmm1, jedynki

	addsubps xmm0, xmm1
	movups [edx], xmm0

	ret	
_pm_jeden ENDP

END