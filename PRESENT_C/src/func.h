/*
 * func.h
 *
 *  Created on: 2020. 12. 8.
 *      Author: info
 */

#ifndef FUNC_H_
#define FUNC_H_

#include <stdio.h>
#include <stdlib.h>

typedef unsigned char 	u8;
typedef unsigned short 	u16;
typedef unsigned int 	u32;

#define SIZE_TEXT 		64
#define SIZE_KEY  		128
#define SIZE_SUB_KEY 	64
#define NUM_ROUND 		32

void PERMUTATE_FUNC_ZERO_16(u16* x0_in, u16* x1_in, u16* x2_in, u16* x3_in);
void PERMUTATE_FUNC_ONE_16(u16* x0_in, u16* x1_in, u16* x2_in, u16* x3_in);
void S_BOX_FUNC_16(u16* word1, u16* word2, u16* word3, u16* word4);
void S_BOX_INV_FUNC_16(u16* word1, u16* word2, u16* word3, u16* word4);
void byte_to_bit(u8* in, u8* out, u32 size_bit);
void bit_to_byte(u8* in, u8* out, u32 size_bit);

void S_BOX_FUNC(u8* bit1, u8* bit2, u8* bit3, u8* bit4);
void PERMUTATE_FUNC(u8* in, u8* out);
void PERMUTATE_FUNC_ZERO(u8* in, u8* out);
void PERMUTATE_FUNC_ONE(u8* in, u8* out);
void ROUND_COUNTER(u8* bit1, u8* bit2, u8* bit3, u8* bit4, u8* bit5, u8 counter);


#endif /* FUNC_H_ */
