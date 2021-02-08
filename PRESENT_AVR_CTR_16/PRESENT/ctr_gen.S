
/*
 * enc.S
 *
 * Created: 2020-04-19 오전 11:49:41
 *  Author: info
 */ 
  	.global PRESENT_enc_ctr
	.type PRESENT_enc_ctr, @function

#define ZERO  R1

#define P0  R2
#define P1  R3
#define P2  R4
#define P3  R5
#define P4  R6
#define P5  R7
#define P6  R8
#define P7  R9

#define T0  R10
#define T1  R11
#define T2  R12
#define T3  R13
#define T4  R14
#define T5  R15
#define T6  R16
#define T7  R17
#define T8  R18
#define T9  R19
#define CNT_OUT R20

.macro LOAD_MM pointer
	LDD P0,  \pointer+0
	LDD P1,  \pointer+1
	LDD P2,  \pointer+2
	LDD P3,  \pointer+3
	LDD P4,  \pointer+4
	LDD P5,  \pointer+5
	LDD P6,  \pointer+6
	LDD P7,  \pointer+7
.endm

.macro STORE_MM pointer
	STD \pointer+0,  P0
	STD \pointer+1,  P1
	STD \pointer+2,  P2
	STD \pointer+3,  P3
	STD \pointer+4,  P4
	STD \pointer+5,  P5
	STD \pointer+6,  P6
	STD \pointer+7,  P7
.endm

.macro PUSH_REGS 
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11
    PUSH R12
    PUSH R13
    PUSH R14
    PUSH R15
    PUSH R16
    PUSH R17
    PUSH R28
    PUSH R29
.endm

.macro POP_REGS
	POP R29
	POP R28
	POP R17
	POP R16
	POP R15
	POP R14
	POP R13
	POP R12
	POP R11
	POP R10
	POP R9
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	CLR R1
.endm

.macro ADD_ROUND reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, tmp
	LD  \tmp, X+
	EOR \reg0, \tmp
	LD  \tmp, X+
	EOR \reg1, \tmp
	LD  \tmp, X+
	EOR \reg2, \tmp
	LD  \tmp, X+
	EOR \reg3, \tmp
	
	LD  \tmp, X+
	EOR \reg4, \tmp
	LD  \tmp, X+
	EOR \reg5, \tmp
	LD  \tmp, X+
	EOR \reg6, \tmp
	LD  \tmp, X+
	EOR \reg7, \tmp
.endm

.macro P_FUNC_0 X3_0, X3_1, X2_0, X2_1, X1_0, X1_1, X0_0, X0_1, T0_0, T0_1
	
	//t = (X0 ^ (ROR_u16(X1,1)))	& 	0x5555;
	MOVW \T0_0, \X1_0
	LSR \T0_1
	ROR \T0_0
	
	EOR \T0_0, \X0_0
	EOR \T0_1, \X0_1

	ANDI \T0_0, 0X55
	ANDI \T0_1, 0X55

	//X0 = X0 ^ t;
	//X1 = X1 ^ (ROL_u16(t,1));
	EOR \X0_0, \T0_0
	EOR \X0_1, \T0_1

	LSL \T0_0
	ROL \T0_1

	EOR \X1_0, \T0_0
	EOR \X1_1, \T0_1

	//t = (X2 ^ (ROR_u16(X3, 1))) & 0x5555;
	MOVW \T0_0, \X3_0
	LSR \T0_1
	ROR \T0_0
	
	EOR \T0_0, \X2_0
	EOR \T0_1, \X2_1

	ANDI \T0_0, 0X55
	ANDI \T0_1, 0X55

	//X2 = X2 ^ t;
	//X3 = X3 ^ (ROL_u16(t, 1));
	EOR \X2_0, \T0_0
	EOR \X2_1, \T0_1

	LSL \T0_0
	ROL \T0_1

	EOR \X3_0, \T0_0
	EOR \X3_1, \T0_1

	//t = (X0 ^ (ROR_u16(X2, 2))) & 0x3333;
	MOVW \T0_0, \X2_0
	LSR \T0_1
	ROR \T0_0
	LSR \T0_1
	ROR \T0_0
	
	EOR \T0_0, \X0_0
	EOR \T0_1, \X0_1

	ANDI \T0_0, 0X33
	ANDI \T0_1, 0X33

	//X0 = X0 ^ t;
	//X2 = X2 ^ (ROL_u16(t, 2));
	EOR \X0_0, \T0_0
	EOR \X0_1, \T0_1

	LSL \T0_0
	ROL \T0_1
	LSL \T0_0
	ROL \T0_1

	EOR \X2_0, \T0_0
	EOR \X2_1, \T0_1

	//t = (X1 ^ (ROR_u16(X3, 2))) & 0x3333;
	MOVW \T0_0, \X3_0
	LSR \T0_1
	ROR \T0_0
	LSR \T0_1
	ROR \T0_0
	
	EOR \T0_0, \X1_0
	EOR \T0_1, \X1_1

	ANDI \T0_0, 0X33
	ANDI \T0_1, 0X33

	//X1 = X1 ^ t;
	//X3 = X3 ^ (ROL_u16(t, 2));
	EOR \X1_0, \T0_0
	EOR \X1_1, \T0_1

	LSL \T0_0
	ROL \T0_1
	LSL \T0_0
	ROL \T0_1

	EOR \X3_0, \T0_0
	EOR \X3_1, \T0_1

	
.endm


.macro P_FUNC_1 X3_0, X3_1, X2_0, X2_1, X1_0, X1_1, X0_0, X0_1, T0_0, T0_1
	
	//t = (X0 ^ (ROR_u16(X1, 4))) & 0x0F0F;
	MOVW \T0_0, \X1_0
	LSR \T0_1
	ROR \T0_0
	LSR \T0_1
	ROR \T0_0
	LSR \T0_1
	ROR \T0_0
	LSR \T0_1
	ROR \T0_0
	
	EOR \T0_0, \X0_0
	EOR \T0_1, \X0_1

	ANDI \T0_0, 0X0F
	ANDI \T0_1, 0X0F

	//X0 = X0 ^ t;
	//X1 = X1 ^ (ROL_u16(t, 4));
	EOR \X0_0, \T0_0
	EOR \X0_1, \T0_1

	LSL \T0_0
	ROL \T0_1
	LSL \T0_0
	ROL \T0_1
	LSL \T0_0
	ROL \T0_1
	LSL \T0_0
	ROL \T0_1

	EOR \X1_0, \T0_0
	EOR \X1_1, \T0_1

	//t = (X2 ^ (ROR_u16(X3, 4))) & 0x0F0F;
	MOVW \T0_0, \X3_0
	LSR \T0_1
	ROR \T0_0
	LSR \T0_1
	ROR \T0_0
	LSR \T0_1
	ROR \T0_0
	LSR \T0_1
	ROR \T0_0
	
	EOR \T0_0, \X2_0
	EOR \T0_1, \X2_1

	ANDI \T0_0, 0X0F
	ANDI \T0_1, 0X0F

	//X2 = X2 ^ t;
	//X3 = X3 ^ (ROL_u16(t, 4));
	EOR \X2_0, \T0_0
	EOR \X2_1, \T0_1

	LSL \T0_0
	ROL \T0_1
	LSL \T0_0
	ROL \T0_1
	LSL \T0_0
	ROL \T0_1
	LSL \T0_0
	ROL \T0_1

	EOR \X3_0, \T0_0
	EOR \X3_1, \T0_1

	//t = (X0 ^ (ROR_u16(X2, 8))) & 0x00FF;
	MOV \T0_0, \X2_1
	MOV \T0_1, \X2_0

	EOR \T0_0, \X0_0
	//EOR \T0_1, \X0_1

	//ANDI \T0_0, 0XFF
	//ANDI \T0_1, 0X00
	//CLR \T0_1


	//X0 = X0 ^ t;
	//X2 = X2 ^ (ROL_u16(t, 8));
	EOR \X0_0, \T0_0
	//EOR \X0_1, \T0_1

	//MOV \T0_1, \T0_0
	//EOR \X2_0, \T0_0
	//EOR \X2_1, \T0_1
	EOR \X2_1, \T0_0


	//t = (X1 ^ (ROR_u16(X3, 8))) & 0x00FF;
	MOV \T0_0, \X3_1
	MOV \T0_1, \X3_0

	EOR \T0_0, \X1_0
	//EOR \T0_1, \X1_1

	//X1 = X1 ^ t;
	//X3 = X3 ^ (ROL_u16(t, 8));

	EOR \X1_0, \T0_0
	EOR \X3_1, \T0_0

.endm


.macro S_BOX x3_0, x3_1, x2_0, x2_1, x1_0, x1_1, x0_0, x0_1, T1_0, T1_1, T2_0, T2_1, T3_0, T3_1, T4_0, T4_1, T5_0, T5_1
	//T1 = x2 ^ x1;
	MOVW \T1_0, \x2_0
	EOR \T1_0, \x1_0
	EOR \T1_1, \x1_1
	
	//T2 = x1 & T1;
	MOVW \T2_0, \x1_0
	AND \T2_0, \T1_0
	AND \T2_1, \T1_1
	
	//T3 = x0 ^ T2;
	MOVW \T3_0, \x0_0
	EOR \T3_0, \T2_0
	EOR \T3_1, \T2_1

	//T5 = x3 ^ T3;
	MOVW \T5_0, \x3_0
	EOR \T5_0, \T3_0
	EOR \T5_1, \T3_1

	//T2 = T1 & T3;
	MOVW \T2_0, \T1_0
	AND \T2_0, \T3_0
	AND \T2_1, \T3_1

	//T1 = T1 ^ T5;
	EOR \T1_0, \T5_0
	EOR \T1_1, \T5_1


	//T2 = T2 ^ x1;
	EOR \T2_0, \x1_0
	EOR \T2_1, \x1_1
	

	
	//T4 = x3 | T2;
	MOVW \T4_0, \x3_0
	OR \T4_0, \T2_0
	OR \T4_1, \T2_1
	
	//x2 = T1 ^ T4;
	MOVW \x2_0, \T1_0
	EOR \x2_0, \T4_0
	EOR \x2_1, \T4_1

	//x3 = x3 ^ 0xFFFF;
	COM \x3_0
	COM \x3_1
	
	//T2 = T2 ^ x3;
	EOR \T2_0, \x3_0
	EOR \T2_1, \x3_1

	//x0 = x2 ^ T2;
	MOVW \x0_0, \x2_0
	EOR \x0_0, \T2_0
	EOR \x0_1, \T2_1

	//T2 = T2 | T1;
	OR \T2_0, \T1_0
	OR \T2_1, \T1_1

	//x1 = T3 ^ T2;
	MOVW \x1_0, \T3_0
	EOR \x1_0, \T2_0
	EOR \x1_1, \T2_1

	//x3 = T5;
	MOVW \x3_0, \T5_0
	
.endm

.macro LUT N_LUT0, N_LUT1, OFFSET, T0, T1
	LDI R31, hi8(\N_LUT0)
	MOV R30, \OFFSET
	ANDI R30, 0X0F
	LPM \T0, Z
	LDI R31, hi8(\N_LUT1)
	LPM \T1, Z
.endm

.macro LUT_TOP	P0, P1, P2, P3, P4, P5, P6, P7, T0, T1
	MOVW \T0, \P0
	LUT LUT2_0, LUT2_1, \T1, \P4, \P5
	SWAP \T1
	LUT LUT3_0, LUT3_1, \T1, \P6, \P7
	
	LUT LUT0_0, LUT0_1, \T0, \P0, \P1
	SWAP \T0
	LUT LUT1_0, LUT1_1, \T0, \P2, \P3
	
.endm

PRESENT_enc_ctr:
	PUSH_REGS

	MOVW R28, R24		//NONCE
	MOVW R26, R22		//ROUND KEY
	PUSH R20
	PUSH R21
	
	LOAD_MM Y
	LDI R20, 1
	MOVW T0, P0
	MOVW T2, P2

	ADD T0, R20
	ADC T1, R1

	STD Y+0, T0
	STD Y+1, T1

	
	//BEGIN ROUND 
	LUT_TOP P0,P1,P2,P3,P4,P5,P6,P7,T8,T9

	S_BOX P0,P1,P2,P3,P4,P5,P6,P7,T0,T1,T2,T3,T4,T5,T6,T7,T8,T9
	ADIW R26, 16

	CLR ZERO //R30
	LDI CNT_OUT, 14

	LOOP:
	//1
	ADD_ROUND P0,P1,P2,P3,P4,P5,P6,P7,T0
	
	P_FUNC_0 P0,P1,P2,P3,P4,P5,P6,P7,T8,T9
	S_BOX P0,P1,P2,P3,P4,P5,P6,P7,T0,T1,T2,T3,T4,T5,T6,T7,T8,T9
	P_FUNC_1 P0,P1,P2,P3,P4,P5,P6,P7,T8,T9

	//2
	ADD_ROUND P0,P1,P2,P3,P4,P5,P6,P7,T0
	S_BOX P0,P1,P2,P3,P4,P5,P6,P7,T0,T1,T2,T3,T4,T5,T6,T7,T8,T9

	DEC CNT_OUT
	CPSE CNT_OUT, ZERO
	RJMP LOOP

	ADD_ROUND P0,P1,P2,P3,P4,P5,P6,P7,T0
	
	P_FUNC_1 P0,P1,P2,P3,P4,P5,P6,P7,T8,T9
	P_FUNC_0 P0,P1,P2,P3,P4,P5,P6,P7,T8,T9

	S_BOX P0,P1,P2,P3,P4,P5,P6,P7,T0,T1,T2,T3,T4,T5,T6,T7,T8,T9

	ADD_ROUND P0,P1,P2,P3,P4,P5,P6,P7,T0

	POP R31
	POP R30

	LDD T0, Z+0
	EOR P0, T0
	LDD T0, Z+1
	EOR P1, T0
	LDD T0, Z+2
	EOR P2, T0
	LDD T0, Z+3
	EOR P3, T0

	LDD T0, Z+4
	EOR P4, T0
	LDD T0, Z+5
	EOR P5, T0
	LDD T0, Z+6
	EOR P6, T0
	LDD T0, Z+7
	EOR P7, T0

	STORE_MM Z

	POP_REGS
RET


.balign 256
LUT0_0: .byte \
0x8D, 0x9C, 0x8C, 0x9D, 0x9D, 0x8C, 0x8D, 0x8C, 0x9C, 0x8D, 0x9D, 0x9C, 0x8C, 0x8D, 0x9C, 0x9D

.balign 256
LUT0_1: .byte \
0x79, 0x79, 0x78, 0x78, 0x69, 0x68, 0x68, 0x79, 0x68, 0x69, 0x79, 0x69, 0x69, 0x78, 0x78, 0x68

.balign 256
LUT1_0: .byte \
0x29, 0x38, 0x28, 0x39, 0x39, 0x28, 0x29, 0x28, 0x38, 0x29, 0x39, 0x38, 0x28, 0x29, 0x38, 0x39

.balign 256
LUT1_1: .byte \
0x3B, 0x3B, 0x3A, 0x3A, 0x2B, 0x2A, 0x2A, 0x3B, 0x2A, 0x2B, 0x3B, 0x2B, 0x2B, 0x3A, 0x3A, 0x2A

.balign 256
LUT2_0: .byte \
0x63, 0x72, 0x62, 0x73, 0x73, 0x62, 0x63, 0x62, 0x72, 0x63, 0x73, 0x72, 0x62, 0x63, 0x72, 0x73

.balign 256
LUT2_1: .byte \
0xDB, 0xDB, 0xDA, 0xDA, 0xCB, 0xCA, 0xCA, 0xDB, 0xCA, 0xCB, 0xDB, 0xCB, 0xCB, 0xDA, 0xDA, 0xCA

.balign 256
LUT3_0: .byte \
0xA3, 0xB2, 0xA2, 0xB3, 0xB3, 0xA2, 0xA3, 0xA2, 0xB2, 0xA3, 0xB3, 0xB2, 0xA2, 0xA3, 0xB2, 0xB3

.balign 256
LUT3_1: .byte \
0xBD, 0xBD, 0xBC, 0xBC, 0xAD, 0xAC, 0xAC, 0xBD, 0xAC, 0xAD, 0xBD, 0xAD, 0xAD, 0xBC, 0xBC, 0xAC
