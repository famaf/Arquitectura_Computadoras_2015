/******************************************************************************
*	main.s
*	 by Delfina Vélez
*
*	Taller de Raspberry Pi
*       Ejemplo en assembler de encendido del led OK 	 
******************************************************************************/

/*
* Mantener la siguiente estructura de inicio de programa
*/
.section .init
.globl _start
_start:

/* 
* Asignar la dirección física de los registros de GPIO a r0
*/
ldr r0,=0x20200000

/*
* Asignar r1=0x00040000	al registro GPIO Function Select 1
* para habilitar el GPIO 16 como salida (bits 18-20 = 001)  
*/

mov r1, #1
mov r3, #1
lsl r3, #3
orr r1, r1,r3
lsl r3, #15
orr r1, r1, r3
lsl r3, #3
orr r1, r1, r3
str r1,[r0,#4]

mov r1, #0
str r1,[r0,#8]

loop$:

ldr r2, [r0, #52]
and r2, r2, #0x1000000
teq r2, #0x1000000
bne loop$



mov r1, #10
mov r4, #1
lsl r4, #10
orr r1, r1, r4
lsl r4, #1
orr r1,r1,r4
lsl r4, #5
orr r1, r1, r4
lsl r4, #1
orr r1, r1, r4
str r1,[r0,#28]


/* 
* Asignar r1=0x00010000 al registro GPIO Pin Output Clear 0
* para poner el GPIO 16 en nivel bajo (bit 16 = 1)
* y hacer que se encienda el LED OK (activo por bajo)
*/






/*
* Definir un loop infinito para que el programa se ejecute
* hasta que se desconecte la alimentación
*/
 
b loop$
