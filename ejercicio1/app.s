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
.equ DETALLES_AMARILLOS, 0xFFECC94B
.equ SOMBRA_SUELO, 0xFF1A202C
.equ ESTRUCTURAS_LEJANAS, 0xFF805AD5

//Argumentos x0 a x3
//x0 = Direccion base del framebuffer (memoria de la pantalla)
//x1 = Coordenada X del pixel a dibujar
//x2 = Coordenada Y del pixel a dibujar
//x3 = El color del pixel en su formato


dibujar_pixel:
	mov x10, SCREEN_WIDTH    // Cargar la constante SCREEN_WIDTH en un registro temporal 
	mul x4, x2, x10          // x4 = Y * SCREEN_WIDTH (multiplica el Y del píxel por el ancho de la pantalla)
	add x4, x4, x1           // x4 = x4 + X (le sumas la coordenada X del píxel)
	lsl x4, x4, 2            // x4 = x4 * 4 (multiplica por 4, ya que 32 BPP = 4 bytes por píxel)
	add x5, x0, x4           // x5 = framebuffer_base (x0) + offset (x4)
	str w3, [x5]             // Guarda el contenido de w3 (tu color) en la dirección de memoria apuntada por x5
	ret
// ------------------------------------------------------------

dibujar_rectangulo:	
	// --- 1. Guardar registros del llamador (contexto) ---
	stp x19, x20, [sp, -16]!	//Guarda x19 y x20 en la pila
	stp x21, x22, [sp, -16]!  	// Guarda x21 y x22
    stp x23, x24, [sp, -16]!  	// Guarda x23 y x24
    stp x25, x30, [sp, -16]!  	// Guarda x25 y x30 (lr)

    // --- 2. Mover los argumentos a registros de "trabajo" ---
	mov x19, x0                 // x19 = framebuffer_base
    mov x20, x1                 // x20 = x_inicio
    mov x21, x2                 // x21 = y_inicio
    mov x22, x3                 // x22 = ancho
    mov x23, x4                 // x23 = alto
    mov x24, x5                 // x24 = color

	// --- 3. Bucle Exterior: Iterar sobre las Filas (Coordenada Y) ---
	mov x25, x21 // x25 es nuestro contador 'y_actual'. Lo inicializamos con y_inicio
loop_rect_y:
	//El bucle debe ir desde y_inicio hasta (y_inicio + alto - 1)
	add x26, x21, x23           // x26 = y_inicio + alto (este es el "límite" o la coordenada "después del final")
    cmp x25, x26                // Compara: ¿y_actual (x25) >= y_inicio + alto (x26)?
    bge end_rect_y              // Si sí (mayor o igual), salta al final del bucle Y. (bge = branch if greater than or equal)

// --- 4. Bucle Interior: Iterar sobre las Columnas (Coordenada X) para la Fila Actual ---
    // Este bucle pinta todos los píxeles de UNA SOLA fila.
    mov x27, x20                // x27 es nuestro contador 'x_actual'. Lo inicializamos con x_inicio para cada nueva fila.
loop_rect_x:
    // Calcular el límite derecho para X (hasta dónde debe llegar este bucle)
    // El bucle debe ir desde x_inicio hasta (x_inicio + ancho - 1).
    // Por lo tanto, salimos si x_actual es mayor o igual a (x_inicio + ancho).
    add x28, x20, x22           // x28 = x_inicio + ancho (este es el "límite" o la coordenada "después del final")
    cmp x27, x28                // Compara: ¿x_actual (x27) >= x_inicio + ancho (x28)?
    bge end_rect_x              // Si sí (mayor o igual), salta al final del bucle X.

// --- 5. ¡Pintar el píxel actual! ---
    // Aquí es donde llamamos a 'dibujar_pixel' para el píxel en (x_actual, y_actual)
    // Pasamos los argumentos a 'dibujar_pixel' en los registros que espera (x0, x1, x2, x3).
    mov x0, x19                 // Argumento 1: framebuffer_base (que lo tenemos guardado en x19)
    mov x1, x27                 // Argumento 2: x_actual (la X de nuestro píxel actual)
    mov x2, x25                 // Argumento 3: y_actual (la Y de nuestro píxel actual)
    mov x3, x24                 // Argumento 4: color (que lo tenemos guardado en x24)
    bl dibujar_pixel            // ¡Llama a la rutina que realmente pinta el píxel!
                                // Después de esta llamada, la ejecución vuelve a la siguiente línea.
	
	// --- 6. Avanzar al siguiente píxel en la fila y repetir ---
    add x27, x27, 1             // Incrementa x_actual (x_actual = x_actual + 1). Vamos al siguiente píxel a la derecha.
    b loop_rect_x               // Salta de nuevo al inicio del bucle X para la siguiente columna.

end_rect_x:                     // Etiqueta donde salimos del bucle X (cuando una fila está completa)
    
	// --- 7. Avanzar a la siguiente fila y repetir ---
    add x25, x25, 1             // Incrementa y_actual (y_actual = y_actual + 1). Vamos a la siguiente fila.
    b loop_rect_y               // Salta de nuevo al inicio del bucle Y para la siguiente fila.

end_rect_y:                     // Etiqueta donde salimos del bucle Y (cuando todas las filas están completas)

    // --- 8. Restaurar registros del llamador y retornar ---
    // Estas instrucciones 'ldp' restauran los valores originales de los registros
    // que habíamos guardado al principio. Se hace en orden INVERSO al 'stp'.
    // 'sp, 16' incrementa el Stack Pointer para liberar el espacio.
    ldp x25, x30, [sp], 16   // Restaura x25 y x30 (lr)
    ldp x23, x24, [sp], 16   // Restaura x23 y x24
    ldp x21, x22, [sp], 16   // Restaura x21 y x22
    ldp x19, x20, [sp], 16   // Restaura x19 y x20
    ret                      // Regresa al punto del código que llamó a dibujar_rectangulo.

/*
En Resumen (Más Sencillo):
dibujar_rectangulo es como un robot que tiene dos contadores.

El primer contador (y_actual) se encarga de ir de fila en fila (de arriba a abajo).
Por cada fila, el segundo contador (x_actual) se encarga de ir de píxel en píxel dentro de esa fila (de izquierda a derecha).
En cada píxel que visita, le dice a dibujar_pixel: "Pinta este píxel en esta (X,Y) con el color que te di".
Cuando ha pintado todos los píxeles de la fila, el primer contador pasa a la siguiente fila y el segundo contador vuelve a empezar.
Cuando ha pintado todas las filas, ha terminado el rectángulo y vuelve a donde lo llamaron.

*/


//------------------------------------------------------
/*
Dibujar circulo

dibujar_circulo es un robot que:

Calcula dónde está el centro del círculo y qué tan grande es (su radio).
Traza un cuadrado imaginario alrededor del círculo.
Usa dos contadores (uno para X y otro para Y) para ir visitando cada píxel dentro de ese cuadrado imaginario.
Para cada píxel visitado, hace una pregunta matemática: "¿Este píxel está lo suficientemente cerca del centro (según la fórmula del círculo)?"
Si la respuesta es "Sí", le dice a dibujar_pixel: "Pinta este píxel".
Si la respuesta es "No", simplemente salta al siguiente píxel sin pintarlo.
Cuando ha visitado todos los píxeles del cuadrado, significa que ya ha dibujado el círculo, y regresa.

Argumentos que necesita (x0 a x4):

x0: Dirección base del framebuffer.
x1: cx (Coordenada X del centro del círculo).
x2: cy (Coordenada Y del centro del círculo).
x3: radio (El radio del círculo).
x4: color (El color con el que pintar el círculo).


*/

dibujar_circulo:
    // --- 1. Guardar registros del llamador (stp) ---
    // Igual que en dibujar_rectangulo, guardamos los registros "callee-saved"
	stp x19, x20, [sp, -16]!
    stp x21, x22, [sp, -16]!
    stp x23, x24, [sp, -16]!
    stp x25, x30, [sp, -16]!

	// --- 2. Mover los argumentos a registros de "trabajo" ---
    mov x19, x0     // x19 = framebuffer_base
    mov x20, x1     // x20 = cx (centro x)
    mov x21, x2     // x21 = cy (centro y)
    mov x22, x3     // x22 = radio
    mov x23, x4     // x23 = color

    // --- 3. Calcular radio al cuadrado  ---
    // Esto lo calculamos una sola vez aquí, en lugar de hacerlo en cada píxel del bucle.
    // Esto es una optimización importante para que sea más rápido.
    mul x24, x22, x22 // x24 = radio * radio (radio^2)

	// --- 4. Bucle Exterior: Iterar sobre las Filas (y_actual) ---
    // Este bucle va desde (cy - radio) hasta (cy + radio).
    sub x25, x21, x22   // y_start = cy - radio (El límite superior de Y para el cuadrado)
    mov x26, x25        // x26 es nuestro contador 'y_actual'. Lo inicializamos en y_start.
loop_circle_y:
    add x27, x21, x22   // y_end = cy + radio (El límite inferior de Y para el cuadrado)
    cmp x26, x27        // Compara: ¿y_actual (x26) > y_end (x27)?
    bgt end_circle_y    // Si sí (mayor), salta al final del bucle Y. (bgt = branch if greater than)

 // --- 5. Bucle Interior: Iterar sobre las Columnas (x_actual) para la Fila Actual ---
    // Este bucle va desde (cx - radio) hasta (cx + radio).
    sub x28, x20, x22   // x_start = cx - radio (El límite izquierdo de X para el cuadrado)
    mov x29, x28        // x29 es nuestro contador 'x_actual'. Lo inicializamos en x_start para cada nueva fila.
loop_circle_x:
    add x30, x20, x22   // x_end = cx + radio (El límite derecho de X para el cuadrado)
    cmp x29, x30        // Compara: ¿x_actual (x29) > x_end (x30)?
    bgt end_circle_x    // Si sí (mayor), salta al final del bucle X.

// --- 6. Aplicar la Fórmula del Círculo para el Píxel Actual (x_actual, y_actual) ---
    // Calcular (x_actual - cx)^2
    sub x5, x29, x20   // x5 = x_actual - cx (distancia horizontal del píxel al centro)
    mul x5, x5, x5     // x5 = x5 * x5 (distancia horizontal al cuadrado)

    // Calcular (y_actual - cy)^2
    sub x6, x26, x21   // x6 = y_actual - cy (distancia vertical del píxel al centro)
    mul x6, x6, x6     // x6 = x6 * x6 (distancia vertical al cuadrado)

    // Calcular la distancia al cuadrado desde el centro: (x-cx)^2 + (y-cy)^2
    add x7, x5, x6     // x7 = (x-cx)^2 + (y-cy)^2

    // --- 7. Decidir si Pintar el Píxel (Comparar con radio^2) ---
    cmp x7, x24        // Compara: ¿distancia_cuadrada (x7) <= radio^2 (x24)?
    ble draw_circle_pixel // Si sí (menor o igual), salta a pintar el píxel. (ble = branch if less than or equal)

    b skip_draw_circle_pixel // Si no, salta directamente a la siguiente iteración (sin pintar).

draw_circle_pixel:       // Etiqueta para cuando el píxel está dentro del círculo
    // --- 8. ¡Pintar el píxel actual! ---
    // Pasamos los argumentos a 'dibujar_pixel' en los registros que espera (x0, x1, x2, x3).
    mov x0, x19     // Argumento 1: framebuffer_base (que lo tenemos guardado en x19)
    mov x1, x29     // Argumento 2: x_actual (la X de nuestro píxel actual)
    mov x2, x26     // Argumento 3: y_actual (la Y de nuestro píxel actual)
    mov x3, x23     // Argumento 4: color (que lo tenemos guardado en x23)
    bl dibujar_pixel // Llama a la rutina que realmente pinta el píxel.

skip_draw_circle_pixel:  // Etiqueta donde continuamos después de decidir si pintar o no
    // --- 9. Avanzar al siguiente píxel en la fila y repetir ---
    add x29, x29, 1 // Incrementa x_actual (x_actual = x_actual + 1). Vamos al siguiente píxel a la derecha.
    b loop_circle_x // Salta de nuevo al inicio del bucle X para la siguiente columna.
end_circle_x:

    // --- 10. Avanzar a la siguiente fila y repetir ---
    add x26, x26, 1 // Incrementa y_actual (y_actual = y_actual + 1). Vamos a la siguiente fila.
    b loop_circle_y // Salta de nuevo al inicio del bucle Y para la siguiente fila.
end_circle_y:

    // --- 11. Restaurar registros del llamador y retornar ---
    // Restauramos los valores originales de los registros en orden inverso al 'stp'.
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

	//Dibujamos FONDO
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
    mov x2, 406                 
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
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo



    mov x0, x20
    mov x1, 200     
    mov x2, 435                 
    mov x3, 40             
    mov x4, 7               
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo


    
    mov x0, x20
    mov x1, 350     
    mov x2, 435                 
    mov x3, 40             
    mov x4, 7               
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo



     
    mov x0, x20
    mov x1, 500     
    mov x2, 435                 
    mov x3, 40             
    mov x4, 7               
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo










	//Dibujamos La luna
	mov x0, x20
	mov x1, 130
	mov x2, 150
	mov x3, 60 

	//Cargamos el color
	movz x4, (ROJO & 0x0000FFFF), lsl 0
	movk x4, (ROJO >> 16), lsl 16
	bl dibujar_circulo



    mov x0, x20
	mov x1, 40
	mov x2, 70
	mov x3, 20 

	//Cargamos el color
	movz x4, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0
	movk x4, (DETALLES_AMARILLOS >> 16), lsl 16
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


    //Sombra principal edificio principal:
    mov x0, x20
    mov x1, 294                
    mov x2, 209             	
    mov x3, 73               
    mov x4, 200                
    movz x5, (0x00 & 0x0000FFFF), lsl 0 
    movk x5, (0x00 >> 16), lsl 16
    bl dibujar_rectangulo



	//principal
	mov x0, x20
    mov x1, 300                
    mov x2, 209             	
    mov x3, 60               
    mov x4, 200                
    movz x5, (TURQUESA & 0x0000FFFF), lsl 0 
    movk x5, (TURQUESA >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 342                
    mov x2, 215             	
    mov x3, 11               
    mov x4, 118               
    movz x5, (AZUL_OSCURO & 0x0000FFFF), lsl 0 
    movk x5, (AZUL_OSCURO >> 16), lsl 16
    bl dibujar_rectangulo


    //sombra parte chica de arriba
	mov x0, x20
    mov x1, 310                
    mov x2, 155             	
    mov x3, 40               
    mov x4, 53                
    movz x5, (0x00 & 0x0000FFFF), lsl 0 
    movk x5, (0x00 >> 16), lsl 16
    bl dibujar_rectangulo

	//parte chica de arriba
	mov x0, x20
    mov x1, 315                
    mov x2, 160             	
    mov x3, 30               
    mov x4, 70                
    movz x5, (TURQUESA & 0x0000FFFF), lsl 0 
    movk x5, (TURQUESA >> 16), lsl 16
    bl dibujar_rectangulo

    //Parte de abajo edificio principal
    mov x0, x20
    mov x1, 300                
    mov x2, 339             	
    mov x3, 60               
    mov x4, 70                
    movz x5, (MAGENTA & 0x0000FFFF), lsl 0 
    movk x5, (MAGENTA >> 16), lsl 16
    bl dibujar_rectangulo

    //Sombra edificio verde de la derecha
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
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
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
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 500                
    mov x2, 330            	    
    mov x3, 5               
    mov x4, 40               
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 520                
    mov x2, 330            	    
    mov x3, 5               
    mov x4, 40               
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 503                
    mov x2, 370            	    
    mov x3, 20               
    mov x4, 4               
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    //D

    mov x0, x20
    mov x1, 535                
    mov x2, 325            	    
    mov x3, 20               
    mov x4, 4               
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 535                
    mov x2, 330            	    
    mov x3, 5               
    mov x4, 40               
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 556                
    mov x2, 330            	    
    mov x3, 5               
    mov x4, 37               
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 535                
    mov x2, 368            	    
    mov x3, 20               
    mov x4, 4               
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    //C
    mov x0, x20
    mov x1, 572                
    mov x2, 330            	    
    mov x3, 5               
    mov x4, 40               
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 578                
    mov x2, 325            	    
    mov x3, 15               
    mov x4, 4               
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 578                
    mov x2, 370            	    
    mov x3, 15               
    mov x4, 4               
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    //Numeros 2025

    //2

    mov x0, x20
    mov x1, 502                 
    mov x2, 390            	    
    mov x3, 18                  
    mov x4, 4                   
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo


    mov x0, x20
    mov x1, 515                
    mov x2, 394            	    
    mov x3, 5                  
    mov x4, 10                   
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 502                 
    mov x2, 404            	    
    mov x3, 18                  
    mov x4, 4                   
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    mov x0, x20
    mov x1, 502                
    mov x2, 408            	    
    mov x3, 5                  
    mov x4, 10                   
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
    bl dibujar_rectangulo

    
    mov x0, x20
    mov x1, 502                 
    mov x2, 415            	    
    mov x3, 18                  
    mov x4, 4                   
    movz x5, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0 
    movk x5, (DETALLES_AMARILLOS >> 16), lsl 16
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
	movz x4, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0
	movk x4, (DETALLES_AMARILLOS >> 16), lsl 16
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

	movz x4, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0
	movk x4, (DETALLES_AMARILLOS >> 16), lsl 16
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

	movz x4, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0
	movk x4, (DETALLES_AMARILLOS >> 16), lsl 16
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

	movz x4, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0
	movk x4, (DETALLES_AMARILLOS >> 16), lsl 16
	bl dibujar_circulo

    mov x0, x20
	mov x1, 600
	mov x2, 200
	mov x3, 3 

	movz x4, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0
	movk x4, (DETALLES_AMARILLOS >> 16), lsl 16
	bl dibujar_circulo

    mov x0, x20
	mov x1, 260
	mov x2, 200
	mov x3, 3 

	movz x4, (DETALLES_AMARILLOS & 0x0000FFFF), lsl 0
	movk x4, (DETALLES_AMARILLOS >> 16), lsl 16
	bl dibujar_circulo


InfLoop:
	b InfLoop
