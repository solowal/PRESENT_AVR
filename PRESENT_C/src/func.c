/*
 * func.c
 *
 *  Created on: 2020. 12. 8.
 *      Author: info
 */

#include "func.h"


//16-bit
void PERMUTATE_FUNC_ZERO_16(u16* x0_in, u16* x1_in, u16* x2_in, u16* x3_in) {
	u16 X0, X1, X2, X3;
	u16 t;

	X3 = *x0_in;
	X2 = *x1_in;
	X1 = *x2_in;
	X0 = *x3_in;

	t = (X0 ^ (ROR_u16(X1,1)))	& 	0x5555;
	X0 = X0 ^ t;
	X1 = X1 ^ (ROL_u16(t,1));

	t = (X2 ^ (ROR_u16(X3, 1))) & 0x5555;
	X2 = X2 ^ t;
	X3 = X3 ^ (ROL_u16(t, 1));

	t = (X0 ^ (ROR_u16(X2, 2))) & 0x3333;
	X0 = X0 ^ t;
	X2 = X2 ^ (ROL_u16(t, 2));

	t = (X1 ^ (ROR_u16(X3, 2))) & 0x3333;
	X1 = X1 ^ t;
	X3 = X3 ^ (ROL_u16(t, 2));

	*x0_in = X3;
	*x1_in = X2;
	*x2_in = X1;
	*x3_in = X0;
}

void PERMUTATE_FUNC_ONE_16(u16* x0_in, u16* x1_in, u16* x2_in, u16* x3_in) {
	u16 X0, X1, X2, X3;
	u16 t;

	X3 = *x0_in;
	X2 = *x1_in;
	X1 = *x2_in;
	X0 = *x3_in;

	t = (X0 ^ (ROR_u16(X1, 4))) & 0x0F0F;
	X0 = X0 ^ t;
	X1 = X1 ^ (ROL_u16(t, 4));

	t = (X2 ^ (ROR_u16(X3, 4))) & 0x0F0F;
	X2 = X2 ^ t;
	X3 = X3 ^ (ROL_u16(t, 4));

	t = (X0 ^ (ROR_u16(X2, 8))) & 0x00FF;
	X0 = X0 ^ t;
	X2 = X2 ^ (ROL_u16(t, 8));

	t = (X1 ^ (ROR_u16(X3, 8))) & 0x00FF;
	X1 = X1 ^ t;
	X3 = X3 ^ (ROL_u16(t, 8));

	*x0_in = X3;
	*x1_in = X2;
	*x2_in = X1;
	*x3_in = X0;
}

void S_BOX_FUNC_16(u16* word1, u16* word2, u16* word3, u16* word4) {
	u16 x0, x1, x2, x3;
	u16 T1, T2, T3, T4, T5;

	x3 = *word1;
	x2 = *word2;
	x1 = *word3;
	x0 = *word4;

	T1 = x2 ^ x1;
	T2 = x1 & T1;
	T3 = x0 ^ T2;
	T5 = x3 ^ T3;
	T2 = T1 & T3;
	T1 = T1 ^ T5;
	T2 = T2 ^ x1;


	T4 = x3 | T2;
	x2 = T1 ^ T4;
	x3 = x3 ^ 0xFFFF;
	T2 = T2 ^ x3;
	x0 = x2 ^ T2;
	T2 = T2 | T1;
	x1 = T3 ^ T2;
	x3 = T5;

	*word1 = x3;
	*word2 = x2;
	*word3 = x1;
	*word4 = x0;
}

void S_BOX_INV_FUNC_16(u16* word1, u16* word2, u16* word3, u16* word4) {
	u16 x0, x1, x2, x3;
	u16 T1, T2, T3, T4, T5;

	x3 = *word1;
	x2 = *word2;
	x1 = *word3;
	x0 = *word4;


	T5 = x3 ^ 0xFFFF;
	T1 = x2 ^ x0;
	T2 = x2 & x0;
	T3 = x1 ^ T2;
	T4 = x3 ^ T1;
	x3 = T5 ^ T3;
	T5 = T1 & x3;
	T1 = x2 ^ T5;
	T2 = T4 | T1;
	x0 = T3 ^ T2;
	T5 = T4 ^ T1;
	T2 = T3 & T5;
	x2 = T4 ^ T2;
	x1 = T2 ^ (T1 ^ 0xFFFF);

	*word1 = x3;
	*word2 = x2;
	*word3 = x1;
	*word4 = x0;
}


void byte_to_bit(u8* in, u8* out, u32 size_bit) {
	u32 size_byte = size_bit / 8;
	u32 i, j;
	u8 bit_selector = 1;

	for (i = 0; i < size_byte; i++) {
		bit_selector = 1;

		for (j = 0; j < 8; j++) {
			if (in[i] & bit_selector)
			out[i * 8 + j] = 1;
			bit_selector = bit_selector << 1;
		}
	}
}

void bit_to_byte(u8* in, u8* out, u32 size_bit) {
	u32 size_byte = size_bit / 8;
	u32 i, j;

	for (i = 0; i < size_byte; i++) {
		out[i] = 0;
		for (j = 0; j < 8; j++) {
			out[i] = out[i] + (in[i * 8 + j] << j);
		}

	}
}



#define S_BOX_BIT

void S_BOX_FUNC(u8* bit1, u8* bit2, u8* bit3, u8* bit4) {
	#ifdef S_BOX_BIT
	u8 x0, x1, x2, x3;
	u8 T1, T2, T3, T4, T5;
	x3 = *bit1;
	x2 = *bit2;
	x1 = *bit3;
	x0 = *bit4;

	T1 = x2 ^ x1;
	T2 = x1 & T1;
	T3 = x0 ^ T2;
	T5 = x3 ^ T3;
	T2 = T1 & T3;
	T1 = T1 ^ T5;
	T2 = T2 ^ x1;
	T4 = x3 | T2;
	x2 = T1 ^ T4;
	x3 = x3 ^ 0x1;
	T2 = T2 ^ x3;
	x0 = x2 ^ T2;
	T2 = T2 | T1;
	x1 = T3 ^ T2;
	x3 = T5;

	*bit1 = x3;
	*bit2 = x2;
	*bit3 = x1;
	*bit4 = x0;

	#else
	u8 SBOX[16] = {0xC, 0x5, 0x6, 0xB, 0x9, 0x0, 0xA, 0xD, 0x3, 0xE, 0xF, 0x8, 0x4, 0x7, 0x1, 0x2};
	u8 input = *bit1 + ((*bit2) << 1) + ((*bit3) << 2) + ((*bit4) << 3);
	input = SBOX[input];

	*bit1 = input & 0x1;
	*bit2 = (input & 0x2) >> 1;
	*bit3 = (input & 0x4) >> 2;
	*bit4 = (input & 0x8) >> 3;
	#endif
}

void PERMUTATE_FUNC(u8* in, u8* out) {
	u8 text_tmp[SIZE_TEXT];
	u32 i, j;

	for (i = 0; i < 4; i++) {
		for (j = 0; j < 16; j++) {
			text_tmp[i * 16 + j] = in[i + j * 4];
		}
	}

	for (i = 0; i < SIZE_TEXT; i++) {
		out[i] = text_tmp[i];
	}
}

void PERMUTATE_FUNC_ZERO(u8* in, u8* out) {
	u8 text_tmp[SIZE_TEXT];
	u32 i, j;

	for (i = 0; i < 4; i++) {
		for (j = 0; j < 4; j++) {
			text_tmp[i * 16 + j] = in[i + j * 16];
		}
		for (j = 0; j < 4; j++) {
			text_tmp[i * 16 + j + 4] = in[i + j * 16 + 4];
		}
		for (j = 0; j < 4; j++) {
			text_tmp[i * 16 + j + 8] = in[i + j * 16 + 8];
		}
		for (j = 0; j < 4; j++) {
			text_tmp[i * 16 + j + 12] = in[i + j * 16 + 12];
		}
	}

	for (i = 0; i < SIZE_TEXT; i++) {
		out[i] = text_tmp[i];
	}
}

void PERMUTATE_FUNC_ONE(u8* in, u8* out) {
	u8 text_tmp[SIZE_TEXT];
	u32 i, j;

	for (i = 0; i < 4; i++) {
		for (j = 0; j < 4; j++) {
			text_tmp[i * 16 + j] = in[i * 4 + j];
		}
		for (j = 0; j < 4; j++) {
			text_tmp[i * 16 + j + 4] = in[i * 4 + j + 16];
		}
		for (j = 0; j < 4; j++) {
			text_tmp[i * 16 + j + 8] = in[i * 4 + j + 32];
		}
		for (j = 0; j < 4; j++) {
			text_tmp[i * 16 + j + 12] = in[i * 4 + j + 48];
		}
	}

	for (i = 0; i < SIZE_TEXT; i++) {
		out[i] = text_tmp[i];
	}
}

void ROUND_COUNTER(u8* bit1, u8* bit2, u8* bit3, u8* bit4, u8* bit5, u8 counter) {
	u8 input = *bit1 + ((*bit2) << 1) + ((*bit3) << 2) + ((*bit4) << 3)
	+ ((*bit5) << 4);

	input = input ^ counter;

	*bit1 = input & 0x1;
	*bit2 = (input & 0x2) >> 1;
	*bit3 = (input & 0x4) >> 2;
	*bit4 = (input & 0x8) >> 3;
	*bit5 = (input & 0x10) >> 4;
}


