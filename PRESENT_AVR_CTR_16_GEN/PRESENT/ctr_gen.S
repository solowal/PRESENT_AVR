
/*
 * enc.S
 *
 * Created: 2020-04-19 오전 11:49:41
 *  Author: info
 */ 
  	.global PRESENT_gen
	.type PRESENT_gen, @function
#define CNT_OUT R0
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

#define C4 R20
#define C5 R21
#define C6 R22
#define C7 R23

#define C0 R24
#define C1 R25
#define C2 R26
#define C3 R27


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
	LDD  \tmp, Y+0
	EOR \reg0, \tmp
	LDD  \tmp, Y+1
	EOR \reg1, \tmp
	LDD  \tmp, Y+2
	EOR \reg2, \tmp
	LDD  \tmp, Y+3
	EOR \reg3, \tmp
	
	LDD  \tmp, Y+4
	EOR \reg4, \tmp
	LDD  \tmp, Y+5
	EOR \reg5, \tmp
	LDD  \tmp, Y+6
	EOR \reg6, \tmp
	LDD  \tmp, Y+7
	EOR \reg7, \tmp

.endm

.macro ADD_ROUND2 reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, tmp
	LDD  \tmp, Y+8
	EOR \reg0, \tmp
	LDD  \tmp, Y+9
	EOR \reg1, \tmp
	LDD  \tmp, Y+10
	EOR \reg2, \tmp
	LDD  \tmp, Y+11
	EOR \reg3, \tmp
	
	LDD  \tmp, Y+12
	EOR \reg4, \tmp
	LDD  \tmp, Y+13
	EOR \reg5, \tmp
	LDD  \tmp, Y+14
	EOR \reg6, \tmp
	LDD  \tmp, Y+15
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

.macro STORE_MM_4 pointer
	STD \pointer+0,  P0
	STD \pointer+1,  P1
	STD \pointer+32,  P2
	STD \pointer+33,  P3
	ADIW R30, 32
	STD \pointer+32,  P4
	STD \pointer+33,  P5
	ADIW R30, 32
	STD \pointer+32,  P6
	STD \pointer+33,  P7
	SBIW R30, 32
	SBIW R30, 30
.endm
//ADIW R30, 2


PRESENT_gen:
	PUSH_REGS

	MOVW R28, R24		//PLAIN TEXT
	
	
	LOAD_MM Y

	MOVW R28, R22		//ROUND KEY
	MOVW R30, R20		//TABLE

	MOVW C0, P0
	MOVW C2, P2
	MOVW C4, P4
	MOVW C6, P6

	CLR ZERO 
	LDI T9, 16
	MOV CNT_OUT, T9
	//BEGIN ROUND 
	
	LOOP:
	//1
	ADD_ROUND P0,P1,P2,P3,P4,P5,P6,P7,T0
	
	P_FUNC_0 P0,P1,P2,P3,P4,P5,P6,P7,T8,T9
	S_BOX P0,P1,P2,P3,P4,P5,P6,P7,T0,T1,T2,T3,T4,T5,T6,T7,T8,T9
	P_FUNC_1 P0,P1,P2,P3,P4,P5,P6,P7,T8,T9

	ADD_ROUND2 P0,P1,P2,P3,P4,P5,P6,P7,T0

	///STORE
	STORE_MM_4 Z

	ADIW C0, 1
	ADIW C0, 16
	INC C1
	LDI T9, 16
	ADD C1, T9

	MOVW P0, C0
	MOVW P2, C2
	MOVW P4, C4
	MOVW P6, C6

	DEC CNT_OUT
	CPSE CNT_OUT, ZERO
	RJMP LOOP

	POP_REGS
RET