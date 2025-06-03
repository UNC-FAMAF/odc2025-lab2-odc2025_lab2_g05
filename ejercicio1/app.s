//Constantes y definiciones globales
.equ SCREEN_WIDTH, 640
.equ SCREEN_HEIGH, 480
.equ BITS_PER_PIXEL, 32 // 32 bits por pixel = 4 bytes por pixel

//Definicion de colores
.equ FONDO, 0xFF2E003E
.equ ROSA, 0xFFFF66CC
.equ ROJO, 0xFFD13438
.equ AZUL_CLARO, 0xFF2B6CB0
.equ AZUL, 0xFF000080
.equ AZUL_OSCURO, 0xFF4682B4
.equ INDIGO, 0xFF4B0082
.equ MAGENTA, 0xFF8B008B
.equ VERDE_CLARO, 0xFF38A169
.equ VERDE_OCEANO, 0xFF2E8B57
.equ TURQUESA, 0xFF319795
.equ AMARILLO, 0xFFECC94B
.equ AMARILLO_LUZ, 0X00FFFFC5
.equ SOMBRA_SUELO, 0xFF1A202C
.equ ESTRUCTURAS_LEJANAS, 0xFF805AD5
.equ FONDO_OSCURO, 0xFF0D1018

//x0 = Direccion base del framebuffer (memoria de la pantalla)
//x1 = Coordenada X del pixel a dibujar
//x2 = Coordenada Y del pixel a dibujar
//x3 = El color del pixel en su formato

dibujar_pixel:
	mov x10, SCREEN_WIDTH    // Cargar la constante SCREEN_WIDTH 
	mul x4, x2, x10          // x4 = Y * SCREEN_WIDTH 
	add x4, x4, x1           // x4 = x4 + X 
	lsl x4, x4, 2            // x4 = x4 * 4 
	add x5, x0, x4           // x5 = framebuffer_base (x0) + offset (x4)
	str w3, [x5]             // Guarda el contenido de w3 en la dirección de memoria apuntada por x5
	ret
// ------------------------------------------------------------

// Ventanas
dibujar_ventanas:
    // Guardamos registros del llamador en la pila
    stp x19, x20, [sp, -16]!    
    stp x21, x22, [sp, -16]!    
    stp x23, x24, [sp, -16]!  
    stp x25, x26, [sp, -16]!
    stp x27, x30, [sp, -16]!

    mov x19, x0    // x19 = framebuffer_base
    mov x20, x1    // x20 = x_inicio
    mov x21, x2    // x21 = y_inicio
    mov x22, x3    // x22 = ancho
    mov x23, x4    // x23 = largo
    mov x24, x5    // x24 = x_final
    mov x25, x6    // x25 = y_final

    movz x14, (AMARILLO_LUZ & 0x0000FFFF), lsl 0
    movk x14, (AMARILLO_LUZ & 0x0000FFFF), lsl 16
    mov x27, x21    // Inicializar y_actual
  

    dibujar_columna:
        mov x26, x20    // Reset X a x_inicio para cada fila
        dibujar_fila:
            mov x0, x19
            mov x1, x26
            mov x2, x27
            mov x3, x22
            mov x4, x23
            mov x5, x14

            bl dibujar_rectangulo
            add x26, x26, 10
            cmp x26, x24
            blt dibujar_fila
        add x27, x27, 10
        cmp x27, x25
        blt dibujar_columna  

  // Restaurar registros
    ldp x27, x30, [sp], 16      
    ldp x25, x26, [sp], 16      
    ldp x23, x24, [sp], 16      
    ldp x21, x22, [sp], 16      
    ldp x19, x20, [sp], 16      
    ret

// ------------------------------------------------------------

dibujar_rectangulo:	
	// Guardamos registros del llamador en la pila
	stp x19, x20, [sp, -16]!	
	stp x21, x22, [sp, -16]!  	
    stp x23, x24, [sp, -16]!  
    stp x25, x26, [sp, -16]!
    stp x27, x30, [sp, -16]!	

	mov x19, x0                 // x19 = framebuffer_base
    mov x20, x1                 // x20 = x_inicio
    mov x21, x2                 // x21 = y_inicio
    mov x22, x3                 // x22 = ancho
    mov x23, x4                 // x23 = alto
    mov x24, x5                 // x24 = color

	// Iterar sobre las Filas
	mov x25, x21 // x25 es nuestro contador. Lo inicializamos con y_inicio
loop_rect_y:
	add x26, x21, x23           // x26 = y_inicio + alto 
    cmp x25, x26                // Compara: ¿y_actual (x25) >= y_inicio + alto (x26)?
    bge end_rect_y              // Si sí salta al final del bucle Y.

    mov x27, x20                // x27 es nuestro contador 'x_actual'.

loop_rect_x:

    add x28, x20, x22           // x28 = x_inicio + ancho 
    cmp x27, x28                // ¿x_actual (x27) >= x_inicio + ancho (x28)?
    bge end_rect_x              // Si sí, salta al final del bucle X.

    //pintamos pixel
    mov x0, x19                 //framebuffer_base 
    mov x1, x27                 //x_actual (la X de nuestro píxel actual)
    mov x2, x25                 //y_actual (la Y de nuestro píxel actual)
    mov x3, x24                 //color (que lo tenemos guardado en x24)
    bl dibujar_pixel            
	
    add x27, x27, 1             //x_actual = x_actual + 1)
    b loop_rect_x               

end_rect_x:                     
    
    add x25, x25, 1             //y_actual = y_actual + 1.
    b loop_rect_y               

end_rect_y:                     

    //restauraramos los registros
    ldp x27, x30, [sp], 16   // Restaura x27 y x30 (lr)  
    ldp x25, x26, [sp], 16   // Restaura x25 y x26
    ldp x23, x24, [sp], 16   // Restaura x23 y x24
    ldp x21, x22, [sp], 16   // Restaura x21 y x22
    ldp x19, x20, [sp], 16   // Restaura x19 y x20
    ret                      // Regresa al punto del código que llamó a dibujar_rectangulo.


//------------------------------------------------------

dibujar_circulo:
    //guardamos registros 
	stp x19, x20, [sp, -16]!
    stp x21, x22, [sp, -16]!
    stp x23, x24, [sp, -16]!
    stp x25, x30, [sp, -16]!

	//mover los argumentos a registros 
    mov x19, x0     // x19 = framebuffer_base
    mov x20, x1     // x20 = cx (centro x)
    mov x21, x2     // x21 = cy (centro y)
    mov x22, x3     // x22 = radio
    mov x23, x4     // x23 = color

    //Calculo radio al cuadrado
    mul x24, x22, x22 // x24 = radio * radio (radio^2)

    // Este bucle va desde (cy - radio) hasta (cy + radio).
    sub x25, x21, x22   // y_start = cy - radio 
    mov x26, x25        // x26 es nuestro contador 'y_actual'. 

loop_circle_y:

    add x27, x21, x22   // y_end = cy + radio 
    cmp x26, x27        //y_actual (x26) > y_end (x27)?
    bgt end_circle_y    //si sí, salta al final del bucle Y

    // Este bucle va desde (cx - radio) hasta (cx + radio).
    sub x28, x20, x22   // x_start = cx - radio 
    mov x29, x28        // x29 es nuestro contador 'x_actual'

loop_circle_x:

    add x30, x20, x22   // x_end = cx + radio
    cmp x29, x30        //x_actual (x29) > x_end (x30)?
    bgt end_circle_x    //si sí (mayor), salta al final del bucle X.

    // Calcular (x_actual - cx)^2
    sub x5, x29, x20   // x5 = x_actual - cx 
    mul x5, x5, x5     // x5 = x5 * x5 

    // Calcular (y_actual - cy)^2
    sub x6, x26, x21   // x6 = y_actual - cy 
    mul x6, x6, x6     // x6 = x6 * x6 

    // Calcular la distancia al cuadrado desde el centro: (x-cx)^2 + (y-cy)^2
    add x7, x5, x6     // x7 = (x-cx)^2 + (y-cy)^2


    cmp x7, x24        //distancia_cuadrada (x7) <= radio^2 (x24)?
    ble draw_circle_pixel //si sí, salta a pintar el píxel

    b skip_draw_circle_pixel 

draw_circle_pixel:       //etiqueta para cuando el píxel está dentro del círculo

    // Pasamos los argumentos a 'dibujar_pixel' en los registros que espera (x0, x1, x2, x3).
    mov x0, x19     //framebuffer_base 
    mov x1, x29     //x_actual 
    mov x2, x26     //y_actual
    mov x3, x23     //color
    bl dibujar_pixel 

skip_draw_circle_pixel:  

    add x29, x29, 1 //x_actual = x_actual + 1.
    b loop_circle_x 

end_circle_x:

    add x26, x26, 1 //y_actual = y_actual + 1
    b loop_circle_y 

end_circle_y:

    //restauramos los valores originales de los registros
    ldp x25, x30, [sp], 16
    ldp x23, x24, [sp], 16
    ldp x21, x22, [sp], 16
    ldp x19, x20, [sp], 16
    ret

//------------------------------------------------------------------
//main

.globl main

main:
    mov x20, x0 // Guarda la dirección base del framebuffer en x20
                // x0 es el primer argumento que el sistema le pasa a 'main',
                // y en este caso, es la dirección de memoria donde puedes escribir para pintar la pantalla.
                // La guardamos en x20 porque x0 se usará para pasar argumentos a tus rutinas de dibujo.

	//FONDO
	mov x0, x20
	mov x1, 0
	mov x2, 0
	mov x3, SCREEN_WIDTH
	mov x4, SCREEN_HEIGH

	movz x5, (FONDO & 0x0000FFFF), lsl 0 //cargamos los primeros 16 bits y los demas en 0s
	movk x5, (FONDO >> 16), lsl 16 // actualizamos con los otros 16 bits (nos queda el color de 32 bits)
	bl dibujar_rectangulo


    ///Suelo

    mov x0, x20
    mov x1, 0      
    mov x2, 410                 
    mov x3, SCREEN_WIDTH              
    mov x4, 70               
    movz x5, (SOMBRA_SUELO & 0x0000FFFF), lsl 0 
    movk x5, (SOMBRA_SUELO >> 16), lsl 16
    bl dibujar_rectangulo


    mov x0, x20
    mov x1, 50      
    mov x2, 435                 
    mov x3, 40             
    mov x4, 7               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 200     
    mov x2, 435                 
    mov x3, 40             
    mov x4, 7               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 350     
    mov x2, 435                 
    mov x3, 40             
    mov x4, 7               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 500     
    mov x2, 435                 
    mov x3, 40             
    mov x4, 7               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    //Edificios de Atras
 
    mov x0, x20
    mov x1, 0      
    mov x2, 305                
    mov x3, SCREEN_WIDTH              
    mov x4, 108               
    movz x5, (FONDO_OSCURO & 0x0000FFFF), lsl 0 
    movk x5, (FONDO_OSCURO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 10      
    mov x2, 295                
    mov x3, 20              
    mov x4, 108               
    movz x5, (FONDO_OSCURO & 0x0000FFFF), lsl 0 
    movk x5, (FONDO_OSCURO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 30      
    mov x2, 250                
    mov x3, 20              
    mov x4, 108               
    movz x5, (FONDO_OSCURO & 0x0000FFFF), lsl 0 
    movk x5, (FONDO_OSCURO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 250      
    mov x2, 270                
    mov x3, 20              
    mov x4, 108               
    movz x5, (FONDO_OSCURO & 0x0000FFFF), lsl 0 
    movk x5, (FONDO_OSCURO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 245      
    mov x2, 260                
    mov x3, 10              
    mov x4, 108               
    movz x5, (FONDO_OSCURO & 0x0000FFFF), lsl 0 
    movk x5, (FONDO_OSCURO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 545      
    mov x2, 260                
    mov x3, 10              
    mov x4, 108               
    movz x5, (FONDO_OSCURO & 0x0000FFFF), lsl 0 
    movk x5, (FONDO_OSCURO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 555      
    mov x2, 240                
    mov x3, 20              
    mov x4, 108               
    movz x5, (FONDO_OSCURO & 0x0000FFFF), lsl 0 
    movk x5, (FONDO_OSCURO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 575      
    mov x2, 260                
    mov x3, 10              
    mov x4, 108               
    movz x5, (FONDO_OSCURO & 0x0000FFFF), lsl 0 
    movk x5, (FONDO_OSCURO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 560      
    mov x2, 220                
    mov x3, 10              
    mov x4, 108               
    movz x5, (FONDO_OSCURO & 0x0000FFFF), lsl 0 
    movk x5, (FONDO_OSCURO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 490      
    mov x2, 270                
    mov x3, 20              
    mov x4, 40               
    movz x5, (FONDO_OSCURO & 0x0000FFFF), lsl 0 
    movk x5, (FONDO_OSCURO >> 16), lsl 16
    bl dibujar_rectangulo

	//Dibujamos La luna
	mov x0, x20
	mov x1, 130
	mov x2, 150
	mov x3, 60 

	movz x4, (ROJO & 0x0000FFFF), lsl 0
	movk x4, (ROJO >> 16), lsl 16
	bl dibujar_circulo

    mov x0, x20
	mov x1, 40
	mov x2, 70
	mov x3, 20 

	movz x4, (AMARILLO & 0x0000FFFF), lsl 0
	movk x4, (AMARILLO >> 16), lsl 16
	bl dibujar_circulo

    mov x0, x20
    mov x1, 10                 
    mov x2, 70                
    mov x3, 60                  
    mov x4, 6                  
    movz x5, (ESTRUCTURAS_LEJANAS & 0x0000FFFF), lsl 0 
    movk x5, (ESTRUCTURAS_LEJANAS >> 16), lsl 16
    bl dibujar_rectangulo

    //NUBES

    mov x0, x20
    mov x1, 200                 
    mov x2, 50                  
    mov x3, 80                  
    mov x4, 6                  
    movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (VERDE_CLARO >> 16), lsl 16
    bl dibujar_rectangulo

	mov x0, x20
    mov x1, 180                 
    mov x2, 55             		
    mov x3, 120                  
    mov x4, 6                  
    movz x5, (TURQUESA & 0x0000FFFF), lsl 0 
    movk x5, (TURQUESA >> 16), lsl 16
    bl dibujar_rectangulo

	mov x0, x20
    mov x1, 90                
    mov x2, 203                  
    mov x3, 80                  
    mov x4, 6                  
    movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (VERDE_CLARO >> 16), lsl 16
    bl dibujar_rectangulo

	mov x0, x20
    mov x1, 70                
    mov x2, 209             	
    mov x3, 120                
    mov x4, 6                  
    movz x5, (TURQUESA & 0x0000FFFF), lsl 0 
    movk x5, (TURQUESA >> 16), lsl 16
    bl dibujar_rectangulo

	mov x0, x20
    mov x1, 500                
    mov x2, 209             	
    mov x3, 30               
    mov x4, 3                
    movz x5, (TURQUESA & 0x0000FFFF), lsl 0 
    movk x5, (TURQUESA >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 500                
    mov x2, 100             	
    mov x3, 20               
    mov x4, 3                
    movz x5, (TURQUESA & 0x0000FFFF), lsl 0 
    movk x5, (TURQUESA >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 530                
    mov x2, 50             	
    mov x3, 80              
    mov x4, 6                
    movz x5, (TURQUESA & 0x0000FFFF), lsl 0 
    movk x5, (TURQUESA >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 540                
    mov x2, 44             	
    mov x3, 60              
    mov x4, 6                
    movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (VERDE_CLARO >> 16), lsl 16
    bl dibujar_rectangulo

	//Edificios

    // Sombra principal edificio principal:
    mov x0, x20
    mov x1, 294                
    mov x2, 209             	
    mov x3, 73               
    mov x4, 200                
    movz x5, (0x00 & 0x0000FFFF), lsl 0 
    movk x5, (0x00 >> 16), lsl 16
    bl dibujar_rectangulo

	// Principal
	mov x0, x20
    mov x1, 300                
    mov x2, 209             	
    mov x3, 60               
    mov x4, 200                
    movz x5, (TURQUESA & 0x0000FFFF), lsl 0 
    movk x5, (TURQUESA >> 16), lsl 16
    bl dibujar_rectangulo

    // Sombra parte chica de arriba
	mov x0, x20
    mov x1, 310                
    mov x2, 155             	
    mov x3, 40               
    mov x4, 53                
    movz x5, (0x00 & 0x0000FFFF), lsl 0 
    movk x5, (0x00 >> 16), lsl 16
    bl dibujar_rectangulo

	// Parte chica de arriba
	mov x0, x20
    mov x1, 315                
    mov x2, 160             	
    mov x3, 30               
    mov x4, 70                
    movz x5, (TURQUESA & 0x0000FFFF), lsl 0 
    movk x5, (TURQUESA >> 16), lsl 16
    bl dibujar_rectangulo

    // Dibujar ventanas edificio principal
    mov x0, x20 // framebuffer
    mov x1, 303 // x_inicio
    mov x2, 213 // y_inicio
    mov x3, 4 
    mov x4, 4
    mov x5, 357 // x_final
    mov x6, 400 // y_final

    bl dibujar_ventanas

    // Dibujar ventanas edificio principal parte chica arriba
    mov x0, x20 // framebuffer
    mov x1, 318 // x_inicio
    mov x2, 164 // y_inicio
    mov x3, 4 
    mov x4, 4
    mov x5, 342 // x_final
    mov x6, 210 // y_final

    bl dibujar_ventanas

    // Sombra edificio verde de la derecha
    mov x0, x20
    mov x1, 400                
    mov x2, 270             	
    mov x3, 60               
    mov x4, 140                
    movz x5, (0x00 & 0x0000FFFF), lsl 0 
    movk x5, (0x00 >> 16), lsl 16
    bl dibujar_rectangulo

    //Edificio verde de la derecha
    mov x0, x20
    mov x1, 408                
    mov x2, 278             	
    mov x3, 45               
    mov x4, 125               
    movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (VERDE_CLARO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 408                
    mov x2, 250             	
    mov x3, 30               
    mov x4, 130               
    movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (VERDE_CLARO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 430                
    mov x2, 285             	
    mov x3, 13               
    mov x4, 118               
    movz x5, (VERDE_OCEANO & 0x0000FFFF), lsl 0 
    movk x5, (VERDE_OCEANO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 360                
    mov x2, 350             	
    mov x3, 50               
    mov x4, 60                
    movz x5, (0x00 & 0x0000FFFF), lsl 0 
    movk x5, (0x00 >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 370                
    mov x2, 358             	
    mov x3, 33               
    mov x4, 45                
    movz x5, (INDIGO & 0x0000FFFF), lsl 0 
    movk x5, (INDIGO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 280                
    mov x2, 270            	
    mov x3, 14               
    mov x4, 139                
    movz x5, (0x00 & 0x0000FFFF), lsl 0 
    movk x5, (0x00 >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 284                
    mov x2, 274            	
    mov x3, 10               
    mov x4, 133                
    movz x5, (AZUL & 0x0000FFFF), lsl 0 
    movk x5, (AZUL >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 170                
    mov x2, 274            	
    mov x3, 60               
    mov x4, 133                
    movz x5, (0x00 & 0x0000FFFF), lsl 0 
    movk x5, (0x00 >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 175                
    mov x2, 280            	
    mov x3, 50               
    mov x4, 120                
    movz x5, (ROJO & 0x0000FFFF), lsl 0 
    movk x5, (ROJO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 120                
    mov x2, 308            	
    mov x3, 50               
    mov x4, 100                
    movz x5, (0x00 & 0x0000FFFF), lsl 0 
    movk x5, (0x00 >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 125                
    mov x2, 318            	
    mov x3, 44               
    mov x4, 82                
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo


    mov x0, x20
    mov x1, 60                
    mov x2, 256            	
    mov x3, 60               
    mov x4, 150                
    movz x5, (0x00 & 0x0000FFFF), lsl 0 
    movk x5, (0x00 >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 66                
    mov x2, 260            	
    mov x3, 48               
    mov x4, 140                
    movz x5, (MAGENTA & 0x0000FFFF), lsl 0 
    movk x5, (MAGENTA >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 100             
    mov x2, 290            	
    mov x3, 10               
    mov x4, 100               
    movz x5, (FONDO & 0x0000FFFF), lsl 0 
    movk x5, (FONDO >> 16), lsl 16
    bl dibujar_rectangulo

   
// LETRAS ODC 2025

    //O
    mov x0, x20
    mov x1, 503                
    mov x2, 325            	    
    mov x3, 20               
    mov x4, 4               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 500                
    mov x2, 330            	    
    mov x3, 5               
    mov x4, 40               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 520                
    mov x2, 330            	    
    mov x3, 5               
    mov x4, 40               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 503                
    mov x2, 370            	    
    mov x3, 20               
    mov x4, 4               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    //D

    mov x0, x20
    mov x1, 535                
    mov x2, 325            	    
    mov x3, 20               
    mov x4, 4               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 535                
    mov x2, 330            	    
    mov x3, 5               
    mov x4, 40               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 556                
    mov x2, 330            	    
    mov x3, 5               
    mov x4, 37               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 535                
    mov x2, 368            	    
    mov x3, 20               
    mov x4, 4               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    //C
    mov x0, x20
    mov x1, 572                
    mov x2, 330            	    
    mov x3, 5               
    mov x4, 40               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 578                
    mov x2, 325            	    
    mov x3, 15               
    mov x4, 4               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 578                
    mov x2, 370            	    
    mov x3, 15               
    mov x4, 4               
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    //Numeros 2025

    //2

    mov x0, x20
    mov x1, 502                 
    mov x2, 390            	    
    mov x3, 18                  
    mov x4, 4                   
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo


    mov x0, x20
    mov x1, 515                
    mov x2, 394            	    
    mov x3, 5                  
    mov x4, 10                   
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 502                 
    mov x2, 404            	    
    mov x3, 18                  
    mov x4, 4                   
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 502                
    mov x2, 408            	    
    mov x3, 5                  
    mov x4, 10                   
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    
    mov x0, x20
    mov x1, 502                 
    mov x2, 415            	    
    mov x3, 18                  
    mov x4, 4                   
    movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    movk x5, (AMARILLO >> 16), lsl 16
    bl dibujar_rectangulo

    // 0

    mov x0, x20
	mov x1, 538 
	mov x2, 404 
	mov x3, 15 

	movz x4, (ROSA & 0x0000FFFF), lsl 0
	movk x4, (ROSA >> 16), lsl 16
	bl dibujar_circulo


    //2

    mov x0, x20
    mov x1, 560                 
    mov x2, 390            	    
    mov x3, 18                  
    mov x4, 4                   
    movz x5, (AZUL_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (AZUL_CLARO >> 16), lsl 16
    bl dibujar_rectangulo


    mov x0, x20
    mov x1, 573                
    mov x2, 394            	    
    mov x3, 5                  
    mov x4, 10                   
    movz x5, (AZUL_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (AZUL_CLARO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 560                 
    mov x2, 404            	    
    mov x3, 18                  
    mov x4, 4                   
    movz x5, (AZUL_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (AZUL_CLARO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 560                
    mov x2, 408            	    
    mov x3, 5                  
    mov x4, 10                   
    movz x5, (AZUL_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (AZUL_CLARO >> 16), lsl 16
    bl dibujar_rectangulo

    
    mov x0, x20
    mov x1, 560                 
    mov x2, 415            	    
    mov x3, 18                  
    mov x4, 4                   
    movz x5, (AZUL_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (AZUL_CLARO >> 16), lsl 16
    bl dibujar_rectangulo

    //5

    mov x0, x20
    mov x1, 583                 
    mov x2, 390            	    
    mov x3, 18                  
    mov x4, 4                   
    movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (VERDE_CLARO >> 16), lsl 16
    bl dibujar_rectangulo


    mov x0, x20
    mov x1, 583                
    mov x2, 394            	    
    mov x3, 5                  
    mov x4, 10                   
    movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (VERDE_CLARO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 583                 
    mov x2, 404            	    
    mov x3, 18                  
    mov x4, 4                   
    movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (VERDE_CLARO >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 596                
    mov x2, 408            	    
    mov x3, 5                  
    mov x4, 10                   
    movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (VERDE_CLARO >> 16), lsl 16
    bl dibujar_rectangulo

    
    mov x0, x20
    mov x1, 582                 
    mov x2, 415            	    
    mov x3, 18                  
    mov x4, 4                   
    movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    movk x5, (VERDE_CLARO >> 16), lsl 16
    bl dibujar_rectangulo

    //ESTREllAS

	mov x0, x20
	mov x1, 400 
	mov x2, 150 
	mov x3, 3 

	//Cargamos el color
	movz x4, (AMARILLO & 0x0000FFFF), lsl 0
	movk x4, (AMARILLO >> 16), lsl 16
	bl dibujar_circulo

    mov x0, x20
	mov x1, 450 
	mov x2, 170
	mov x3, 3 

	movz x4, (ROSA & 0x0000FFFF), lsl 0
	movk x4, (ROSA >> 16), lsl 16
	bl dibujar_circulo

    
    mov x0, x20
	mov x1, 550 
	mov x2, 120
	mov x3, 3 

	movz x4, (ROSA & 0x0000FFFF), lsl 0
	movk x4, (ROSA >> 16), lsl 16
	bl dibujar_circulo

    mov x0, x20
	mov x1, 150 
	mov x2, 50
	mov x3, 3 

	movz x4, (AMARILLO & 0x0000FFFF), lsl 0
	movk x4, (AMARILLO >> 16), lsl 16
	bl dibujar_circulo

    mov x0, x20
	mov x1, 130 
	mov x2, 250
	mov x3, 3 

	movz x4, (ROSA & 0x0000FFFF), lsl 0
	movk x4, (ROSA >> 16), lsl 16
	bl dibujar_circulo


    mov x0, x20
	mov x1, 30 
	mov x2, 150
	mov x3, 3 

	movz x4, (AMARILLO & 0x0000FFFF), lsl 0
	movk x4, (AMARILLO >> 16), lsl 16
	bl dibujar_circulo

    mov x0, x20
	mov x1, 250 
	mov x2, 110
	mov x3, 3 

	movz x4, (ROSA & 0x0000FFFF), lsl 0
	movk x4, (ROSA >> 16), lsl 16
	bl dibujar_circulo

    mov x0, x20
	mov x1, 450 
	mov x2, 60
	mov x3, 3 

	movz x4, (ROSA & 0x0000FFFF), lsl 0
	movk x4, (ROSA >> 16), lsl 16
	bl dibujar_circulo

    mov x0, x20
	mov x1, 350
	mov x2, 60
	mov x3, 3 

	movz x4, (ROSA & 0x0000FFFF), lsl 0
	movk x4, (ROSA >> 16), lsl 16
	bl dibujar_circulo

    mov x0, x20
	mov x1, 390
	mov x2, 30
	mov x3, 3 

	movz x4, (AMARILLO & 0x0000FFFF), lsl 0
	movk x4, (AMARILLO >> 16), lsl 16
	bl dibujar_circulo

    mov x0, x20
	mov x1, 600
	mov x2, 200
	mov x3, 3 

	movz x4, (AMARILLO & 0x0000FFFF), lsl 0
	movk x4, (AMARILLO >> 16), lsl 16
	bl dibujar_circulo

    mov x0, x20
	mov x1, 260
	mov x2, 200
	mov x3, 3 

	movz x4, (AMARILLO & 0x0000FFFF), lsl 0
	movk x4, (AMARILLO >> 16), lsl 16
	bl dibujar_circulo


InfLoop:
	b InfLoop
