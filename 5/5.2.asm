.686
.model flat

public _nowy_exp

.code
_nowy_exp PROC
	finit

	fld1 ; tutaj bedziemy sumowac
	fld1 ; tutaj bedzie kolejna potega x
	fld1 ; tutaj bedzie kolejna silnia 
	fld1 ; tutaj bedzie numer aktualnie liczonego wyrazu
	fld dword ptr [esp + 4] ; tutaj bedzie x

	mov ecx, 19
ptl:
	fmul st(3), st(0) ; wyliczamy kolejna potege x
	fxch
	fmul st(2), st(0) ; wyliczamy kolejna silnie

	; dodajemy kolejny wyraz do sumy
	fld st(3)
	fld st(3)
	fdivp st(1), st(0)
	faddp st(5), st(0)

	fld1
	faddp st(1), st(0)
	fxch

	loop ptl

	mov ecx, 4
ptl2:
	fstp st(0)
	loop ptl2

	ret
_nowy_exp ENDP

END