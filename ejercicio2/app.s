	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34
	
	

//Definicion de colores
.equ TIERRA, 0xFF999900
.equ PIEDRITA, 0XFFFFFFFF
.equ TIERRA_MEDIA, 0XFF807B37
.equ SOMBRA_TIERRA, 0XFF616422
.equ PASTO, 0xFF49D18D
.equ MADERA, 0xFF705321
.equ SOMBRA_MADERA, 0xFF7C6950
.equ ESCALERA, 0xFFD5B981
.equ TECHO, 0xFFEF871F
.equ HOJAS, 0xFF4FE27B
.equ HOJAS_OSCURAS, 0xFF338941
.equ SOMBRA_HOJAS, 0xFF10401A
.equ FLORES, 0xFFF2B374
.equ TIERRA_MOJADA, 0xFF5E590F
.equ CIELO, 0xFFC3D5EC 
.equ PAJARO, 0xFFFFFFFF
.equ PICO_PAJARO, 0xFFFFFF00
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





dibujar_pixel:
	mov x10, SCREEN_WIDTH    // Cargar la constante SCREEN_WIDTH en un registro temporal 
	mul x4, x2, x10          // x4 = Y * SCREEN_WIDTH (multiplica el Y del píxel por el ancho de la pantalla)
	add x4, x4, x1           // x4 = x4 + X (le sumas la coordenada X del píxel)
	lsl x4, x4, 2            // x4 = x4 * 4 (multiplica por 4, ya que 32 BPP = 4 bytes por píxel)
	add x5, x0, x4           // x5 = framebuffer_base (x0) + offset (x4)
	str w3, [x5]             // Guarda el contenido de w3 (tu color) en la dirección de memoria apuntada por x5
	ret
// ------------------------------------------------------------

/*
		Argumentos:
		x0: framebuffer_base
		x1: x_inicio (X de la esquina superior izquierda)
		x2: y_inicio (Y de la esquina superior izquierda)
		x3: ancho (del rectángulo)
		x4: alto (del rectángulo)
		x5: color	

		
		Cómo funciona? (la lógica detrás):

		Necesitas dos bucles anidados:

		Un bucle exterior para recorrer las filas (Y) del rectángulo.
		Un bucle interior para recorrer las columnas (X) en cada fila.

		Para cada punto (X, Y) dentro del rectángulo, llamas a dibujar_pixel.

		Bucle exterior (Y):

		Empiezas en y_inicio.
		Te detienes cuando y_actual es mayor o igual que y_inicio + alto.
		En cada iteración, incrementas y_actual en 1.
		Bucle interior (X):

		En cada iteración del bucle Y, reinicias x_actual a x_inicio.
		Te detienes cuando x_actual es mayor o igual que x_inicio + ancho.
		En cada iteración, incrementas x_actual en 1.
		Dentro del bucle X: Llamas a dibujar_pixel, pasándole framebuffer_base, x_actual, y_actual, y el color.
			
	 */
	 
	 
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


dibujar_diagonal_izq:

	// --- 1. Guardar registros del llamador (contexto) ---
	stp x19, x20, [sp, -16]!	//Guarda x19 y x20 en la pila
	stp x21, x22, [sp, -16]!  	// Guarda x21 y x22
    stp x23, x24, [sp, -16]!  	// Guarda x23 y x24
    stp x25, x30, [sp, -16]!  	// Guarda x25 y x30 (lr)
    

    // --- 2. Mover los argumentos a registros de "trabajo" ---
   mov x9, 0
   mov x10, 2
	mov x19, x0                 // x19 = framebuffer_base
    mov x20, x1                 // x20 = x_inicio
    mov x21, x2                 // x21 = y_inicio
    mov x22, x3                 // x22 = ancho
    mov x23, x4                 // x23 = alto
    mov x24, x5                 // x24 = color

	// --- 3. Bucle Exterior: Iterar sobre las Filas (Coordenada Y) ---
	mov x25, x21 // x25 es nuestro contador 'y_actual'. Lo inicializamos con y_inicio
	
	loop_diag_izq_y:
	//El bucle debe ir desde y_inicio hasta (y_inicio + alto - 1)
	add x26, x21, x23           // x26 = y_inicio + alto (este es el "límite" o la coordenada "después del final")
    cmp x25, x26                // Compara: ¿y_actual (x25) >= y_inicio + alto (x26)?
    bge end_diag_izq_y              // Si sí (mayor o igual), salta al final del bucle Y. (bge = branch if greater than or equal)

// --- 4. Bucle Interior: Iterar sobre las Columnas (Coordenada X) para la Fila Actual ---
    // Este bucle pinta todos los píxeles de UNA SOLA fila.
    mov x27, x20                // x27 es nuestro contador 'x_actual'. Lo inicializamos con x_inicio para cada nueva fila.
loop_diag_izq_x:
    // Calcular el límite derecho para X (hasta dónde debe llegar este bucle)
    // El bucle debe ir desde x_inicio hasta (x_inicio + ancho - 1).
    // Por lo tanto, salimos si x_actual es mayor o igual a (x_inicio + ancho).
    add x28, x20, x22           // x28 = x_inicio + ancho (este es el "límite" o la coordenada "después del final")
    cmp x27, x28                // Compara: ¿x_actual (x27) >= x_inicio + ancho (x28)?
    bge end_diag_izq_x              // Si sí (mayor o igual), salta al final del bucle X.

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
    b loop_diag_izq_x               // Salta de nuevo al inicio del bucle X para la siguiente columna.

end_diag_izq_x:                     // Etiqueta donde salimos del bucle X (cuando una fila está completa)
    
	// --- 7. Avanzar a la siguiente fila y repetir ---
    add x25, x25, 1             // Incrementa y_actual (y_actual = y_actual + 1). Vamos a la siguiente fila.
    b loop_diag_izq_y               // Salta de nuevo al inicio del bucle Y para la siguiente fila.

end_diag_izq_y:                     // Etiqueta donde salimos del bucle Y (cuando todas las filas están completas)


    
    add x21, x21, x23
    add x20, x20, x22
    add x9, x9, 1
    cmp x9, 4
    blt loop_diag_izq_y
    
    
    // --- 8. Restaurar registros del llamador y retornar ---
    // Estas instrucciones 'ldp' restauran los valores originales de los registros
    // que habíamos guardado al principio. Se hace en orden INVERSO al 'stp'.
    // 'sp, 16' incrementa el Stack Pointer para liberar el espacio.
    ldp x25, x30, [sp], 16   // Restaura x25 y x30 (lr)
    ldp x23, x24, [sp], 16   // Restaura x23 y x24
    ldp x21, x22, [sp], 16   // Restaura x21 y x22
    ldp x19, x20, [sp], 16   // Restaura x19 y x20
    ret                      // Regresa al punto del código que llamó a dibujar_diagonal.
    
    
    dibujar_diagonal_der:

	// --- 1. Guardar registros del llamador (contexto) ---
	stp x19, x20, [sp, -16]!	//Guarda x19 y x20 en la pila
	stp x21, x22, [sp, -16]!  	// Guarda x21 y x22
    stp x23, x24, [sp, -16]!  	// Guarda x23 y x24
    stp x25, x30, [sp, -16]!  	// Guarda x25 y x30 (lr)
    

    // --- 2. Mover los argumentos a registros de "trabajo" ---
    
    
    mov x9, 0
    mov x19, x0                 // x19 = framebuffer_base
    mov x20, x1                 // x20 = x_inicio
    mov x21, x2                 // x21 = y_inicio
    mov x22, x3                 // x22 = ancho
    mov x23, x4                 // x23 = alto
    mov x24, x5                 // x24 = color
    


	// --- 3. Bucle Exterior: Iterar sobre las Filas (Coordenada Y) ---
	mov x25, x21 // x25 es nuestro contador 'y_actual'. Lo inicializamos con y_inicio
	
	loop_diag_der_y:
	//El bucle debe ir desde y_inicio hasta (y_inicio + alto - 1)
	add x26, x21, x23           // x26 = y_inicio + alto (este es el "límite" o la coordenada "después del final")
    cmp x25, x26                // Compara: ¿y_actual (x25) >= y_inicio + alto (x26)?
    bge end_diag_der_y              // Si sí (mayor o igual), salta al final del bucle Y. (bge = branch if greater than or equal)

// --- 4. Bucle Interior: Iterar sobre las Columnas (Coordenada X) para la Fila Actual ---
    // Este bucle pinta todos los píxeles de UNA SOLA fila.
    mov x27, x20                // x27 es nuestro contador 'x_actual'. Lo inicializamos con x_inicio para cada nueva fila.
loop_diag_der_x:
    // Calcular el límite derecho para X (hasta dónde debe llegar este bucle)
    // El bucle debe ir desde x_inicio hasta (x_inicio + ancho - 1).
    // Por lo tanto, salimos si x_actual es mayor o igual a (x_inicio + ancho).
    add x28, x20, x22           // x28 = x_inicio + ancho (este es el "límite" o la coordenada "después del final")
    cmp x27, x28                // Compara: ¿x_actual (x27) >= x_inicio + ancho (x28)?
    bge end_diag_der_x              // Si sí (mayor o igual), salta al final del bucle X.

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
    add x27, x27, 1		             // Incrementa x_actual (x_actual = x_actual + 1). Vamos al siguiente píxel a la derecha.
    b loop_diag_der_x               // Salta de nuevo al inicio del bucle X para la siguiente columna.

end_diag_der_x:                     // Etiqueta donde salimos del bucle X (cuando una fila está completa)
    
	// --- 7. Avanzar a la siguiente fila y repetir ---
    add x25, x25, 1             // Incrementa y_actual (y_actual = y_actual + 1). Vamos a la siguiente fila.
    b loop_diag_der_y               // Salta de nuevo al inicio del bucle Y para la siguiente fila.

end_diag_der_y:                     // Etiqueta donde salimos del bucle Y (cuando todas las filas están completas)

    add x21, x21, x23
    sub x20, x20, x22
    
    add x9, x9, 1
    cmp x9, 4
    blt loop_diag_der_y
    
    
    // --- 8. Restaurar registros del llamador y retornar ---
    // Estas instrucciones 'ldp' restauran los valores originales de los registros
    // que habíamos guardado al principio. Se hace en orden INVERSO al 'stp'.
    // 'sp, 16' incrementa el Stack Pointer para liberar el espacio.
    ldp x25, x30, [sp], 16   // Restaura x25 y x30 (lr)
    ldp x23, x24, [sp], 16   // Restaura x23 y x24
    ldp x21, x22, [sp], 16   // Restaura x21 y x22
    ldp x19, x20, [sp], 16   // Restaura x19 y x20
    ret                      // Regresa al punto del código que llamó a dibujar_diagonal.


funcion_delay:
		// 	Parametros:
		// 	x8 -> Duración DELAY.

		// Guardamos los valores previos en el stack
		SUB SP, SP, 8 										
		STUR x9,  [SP, 0]

		mov x9, x8 
 		mul x9, x9, x9
		delay:
			sub x9, x9, 1
			cbnz x9, delay
			

		// Devolvemos los valores previos del stack
		LDR x9, [SP, 0]					 			
		ADD SP, SP, 8
	ret


	.globl main




main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20

	//---------------- CODE HERE ------------------------------------
	
	//Fondo
	mov x0, x20
	mov x1, 0	
	mov x2, 0		
	mov x3, SCREEN_WIDTH	
	mov x4, SCREEN_HEIGH	
	movz x5, (CIELO & 0x0000FFFF), lsl 0	
	movk x5, (CIELO >> 16), lsl 16
	bl dibujar_rectangulo
	
	
	//---------INICIO ODC 2025------------------
		//O
    	mov x0, x20 //mueve en eje x ➡️
    	mov x1, 502 //mueve en eje y ⬆️               
    	mov x2, 45  //mueve en eje x ⬅️         	    
    	mov x3, 20  //mueve en eje y ⬇️             
    	mov x4, 4               
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 500                
    	mov x2, 50            	    
    	mov x3, 5               
    	mov x4, 40               
    	movz x5, ( AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 520             
    	mov x2, 50            	    
    	mov x3, 5               
    	mov x4, 40               
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 502                
    	mov x2, 90          	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo

    	//D

    	mov x0, x20
    	mov x1, 535               
    	mov x2, 45         	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 535                
    	mov x2, 48            	    
    	mov x3, 5               
    	mov x4, 45               
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 555                
    	mov x2, 49            	    
    	mov x3, 5               
    	mov x4, 40               
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo
    			
    	mov x0, x20
    	mov x1, 535                
    	mov x2, 89            	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo

    	//C
    	mov x0, x20
    	mov x1, 565 //mueve en eje x ➡️              
    	mov x2, 45  //mueve en eje y ⬆️       	    
    	mov x3, 20  //mueve en eje x ⬅️             
    	mov x4, 4   //mueve en eje y ⬇️            
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 565                
    	mov x2, 48            	    
    	mov x3, 5               
    	mov x4, 45               
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 565                
    	mov x2, 89            	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo


    	//2

    	mov x0, x20
    	mov x1, 502                 
    	mov x2, 115            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 515                
    	mov x2, 116           	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 502                 
    	mov x2, 126            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 502                
    	mov x2, 130           	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo

	
    	mov x0, x20
    	mov x1, 502                 
    	mov x2, 140            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (AMARILLO & 0x0000FFFF), lsl 0 
    	movk x5, (AMARILLO >> 16), lsl 16
    	bl dibujar_rectangulo

    	// 0

    	mov x0, x20
		mov x1, 538 
		mov x2, 128 
		mov x3, 15 

		movz x4, (ROSA & 0x0000FFFF), lsl 0
		movk x4, (ROSA >> 16), lsl 16
		bl dibujar_circulo
    	
		mov x0, x20
		mov x1, 538 
		mov x2, 128 
		mov x3, 11 
		movz x4, (CIELO & 0x0000FFFF), lsl 0
		movk x4, (CIELO >> 16), lsl 16
		bl dibujar_circulo


		//2 AZUL

    	mov x0, x20
    	mov x1, 560                 
    	mov x2, 115            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (AZUL_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (AZUL_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 573                
    	mov x2, 116            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (AZUL_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (AZUL_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 560                 
    	mov x2, 126            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (AZUL_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (AZUL_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 560                
    	mov x2, 130            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (AZUL_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (AZUL_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 560                 
    	mov x2, 140            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (AZUL_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (AZUL_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	
    	//5
    	mov x0, x20
    	mov x1, 583                 
    	mov x2, 115            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VERDE_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 583                
    	mov x2, 116            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VERDE_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 583                 
    	mov x2, 126            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VERDE_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 596                
    	mov x2, 130            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VERDE_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

	
    	mov x0, x20
    	mov x1, 582                 
    	mov x2, 140            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VERDE_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo
//---------FIN ODC 2025------------------
	
	//Suelo
	mov x0, x20
    	mov x1, 200      
   	mov x2, 415                  
    	mov x3, 240               
    	mov x4, 17              
    	movz x5, (TIERRA_MOJADA & 0x0000FFFF), lsl 0	
    	movk x5, (TIERRA_MOJADA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
	mov x0, x20
    	mov x1, 150      
   	mov x2, 410                  
    	mov x3, 340               
    	mov x4, 18              
    	movz x5, (TIERRA_MOJADA & 0x0000FFFF), lsl 0	
    	movk x5, (TIERRA_MOJADA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
	mov x0, x20
    	mov x1, 100      
   	mov x2, 400                  
    	mov x3, 440               
    	mov x4, 19              
    	movz x5, (TIERRA_MEDIA & 0x0000FFFF), lsl 0	
    	movk x5, (TIERRA_MEDIA >> 16), lsl 16
    	bl dibujar_rectangulo
	
	mov x0, x20
    	mov x1, 90      
   	mov x2, 390                  
    	mov x3, 470              
    	mov x4, 17               
    	movz x5, (TIERRA & 0x0000FFFF), lsl 0 	
    	movk x5, (TIERRA >> 16), lsl 16
    	bl dibujar_rectangulo
	
	mov x0, x20
    	mov x1, 80      
   	mov x2, 385                  
    	mov x3, 490               
    	mov x4, 10               
    	movz x5, (TIERRA & 0x0000FFFF), lsl 0	
    	movk x5, (TIERRA >> 16), lsl 16
    	bl dibujar_rectangulo
	
	mov x0, x20
    	mov x1, 70      
   	mov x2, 380                  
    	mov x3, 510               
    	mov x4, 9               
    	movz x5, (TIERRA & 0x0000FFFF), lsl 0	
    	movk x5, (TIERRA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	
    	
    	
    	//Sombras de la tierra
    	mov x0, x20
    	mov x1, 90      
   	mov x2, 400                  
    	mov x3, 470               
    	mov x4, 2              
    	movz x5, (TIERRA_MOJADA & 0x0000FFFF), lsl 0	
    	movk x5, (TIERRA_MOJADA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 100      
   	mov x2, 408                  
    	mov x3, 440               
    	mov x4, 2              
    	movz x5, (TIERRA_MOJADA & 0x0000FFFF), lsl 0	
    	movk x5, (TIERRA_MOJADA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 80      
   	mov x2, 393                  
    	mov x3, 490               
    	mov x4, 2              
    	movz x5, (TIERRA_MOJADA & 0x0000FFFF), lsl 0	
    	movk x5, (TIERRA_MOJADA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 70      
   	mov x2, 387                  
    	mov x3, 510               
    	mov x4, 2              
    	movz x5, (TIERRA_MOJADA & 0x0000FFFF), lsl 0	
    	movk x5, (TIERRA_MOJADA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	
    	
	
	//Pasto
	mov x0, x20
    	mov x1, 68      
   	mov x2, 370                  
    	mov x3, 515               
    	mov x4, 10               
    	movz x5, (PASTO & 0x0000FFFF), lsl 0	
    	movk x5, (PASTO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 71      
   	mov x2, 368                  
    	mov x3, 508               
    	mov x4, 9               
    	movz x5, (PASTO & 0x0000FFFF), lsl 0	
    	movk x5, (PASTO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	//Troncos
    	mov x0, x20
    	mov x1, 150      
   	mov x2, 225                  
    	mov x3, 20               
    	mov x4, 145              
    	movz x5, (MADERA & 0x0000FFFF), lsl 0	
    	movk x5, (MADERA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	
    	
    	
    	//Sombras de los troncos
	mov x0, x20
    	mov x1, 164      
   	mov x2, 225                  
    	mov x3, 1               
    	mov x4, 145              
    	movz x5, (SOMBRA_MADERA & 0x0000FFFF), lsl 0	
    	movk x5, (SOMBRA_MADERA >> 16), lsl 16
    	bl dibujar_rectangulo
	
		mov x0, x20
    	mov x1, 156      
   		mov x2, 225                  
    	mov x3, 1               
    	mov x4, 145              
    	movz x5, (SOMBRA_MADERA & 0x0000FFFF), lsl 0	
    	movk x5, (SOMBRA_MADERA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	
    	//Hojas de los arboles
    	mov x0, x20
		mov x1, 160 //Eje x
		mov x2, 160 //Eje y
		mov x3, 70 //Tamano
	
	//RECTANGULO ARBOL
	mov x0, x20
    mov x1, 105      
   	mov x2, 120                  
    mov x3, 110               
    mov x4, 100              
    movz x5, (HOJAS & 0x0000FFFF), lsl 0	
    movk x5, (HOJAS >> 16), lsl 16
    bl dibujar_rectangulo


	//Flores

	mov x0, x20
    	mov x1, 350    //x_inicio  
   		mov x2, 340    //y_inicio              
    	mov x3, 8      //ancho         
    	mov x4, 30      //alto        
    	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	bl dibujar_rectangulo



//-------------------------------------- HOJAS DEL ARBOL ------------------------------------------------------------
	mov x12, 0 //contador
	mov x13, 110 //y_inicio
	mov x14, 90 //x_inicio_izq
	mov x15, 120 //x_inicio_der
	

	hojas:
	//---------INICiO importante:-----------------------
		//x1=x_inicio
		//x2=y_inicio
		//x3=ancho   
		//x4=alto    
	//---------FIN importante:-----------------------
	
	//------------- linea 2 arbol ------------------
		mov x0, x20
    	mov x1, x14      
		add x1, x1, #5
   		mov x2, 100                 
		mov x3, 6              
    	mov x4, 6             
    	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	bl dibujar_diagonal_izq
    	
    	mov x0, x20
    	mov x1, x14
		sub x1, x1,#20      
   		mov x2, 100                  
    	mov x3, 6               
    	mov x4, 6              
    	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	bl dibujar_diagonal_der
	
	//------------- linea 1 arbol ------------------
		mov x0, x20
    	mov x1, x15      
   		mov x2, 200                 
    	mov x3, 6              
    	mov x4, 6              
    	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	bl dibujar_diagonal_izq
    	
    	mov x0, x20
    	mov x1, x14
   		mov x2, 200                  
    	mov x3, 6               
    	mov x4, 6              
    	movz x5, (ROJO & 0x0000FFFF), lsl 0	
    	movk x5, (ROJO >> 16), lsl 16
    	bl dibujar_diagonal_der
    	//----------------------------------------------------------------------------

		//mov x0, x20
    	//mov x1, x14      
   		//mov x2, 140                  
    	//mov x3, 6               
    	//mov x4, 6              
    	//movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	//movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	//bl dibujar_diagonal_der
    	//
    	//mov x0, x20
    	//mov x1, x14      
   		//mov x2, 150                  
    	//mov x3, 6               
    	//mov x4, 6              
    	//movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	//movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	//bl dibujar_diagonal_der
    	//
    	//
    	//mov x0, x20
    	//mov x1, x14      
   		//mov x2, 160                  
    	//mov x3, 6               
    	//mov x4, 6              
    	//movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	//movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	//bl dibujar_diagonal_izq
    	//
    	//mov x0, x20
    	//mov x1, x14      
   		//mov x2, 170                  
    	//mov x3, 6               
    	//mov x4, 6              
    	//movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	//movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	//bl dibujar_diagonal_izq
    	//    	mov x0, x20
    	//mov x1, x14      
   		//mov x2, 180                  
    	//mov x3, 6               
    	//mov x4, 6              
    	//movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	//movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	//bl dibujar_diagonal_der
    	//
    	//mov x0, x20
    	//mov x1, x14      
   		//mov x2, 190                  
    	//mov x3, 6               
    	//mov x4, 6              
    	//movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	//movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	//bl dibujar_diagonal_der
    	//
    	//
    	//
    	//mov x0, x20
    	//mov x1, 110      
   		//mov x2, x13                  
    	//mov x3, 6               
    	//mov x4, 6              
    	//movz x5, (SOMBRA_HOJAS & 0x0000FFFF), lsl 0	
    	//movk x5, (SOMBRA_HOJAS >> 16), lsl 16
    	//bl dibujar_diagonal_izq
		//
    	//mov x0, x20
    	//mov x1, x14      
   		//mov x2, 210                  
    	//mov x3, 6               
    	//mov x4, 6              
    	//movz x5, (SOMBRA_HOJAS & 0x0000FFFF), lsl 0	
    	//movk x5, (SOMBRA_HOJAS >> 16), lsl 16
    	//bl dibujar_diagonal_der
    //-------------- ADD PARA QUE SE MUEVA ---------------------------
    	add x15, x15, 8
    	add x14, x14, 8
    	add x13, x13, 8
    	add x12, x12, 1
    	cmp x12, 12
		blt hojas
// -------------------------- DEVOLVER A 0 ------------------------------
	mov x12, 0
	mov x13, 0
	mov x14, 0
	mov x15, 0

    	//Pajaros en movimiento
    	
    	pajaros:
    	
    		mov x0, x20
    		mov x1, 54      
   			mov x2, 50                  
    		mov x3, 5               
    		mov x4, 25              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_rectangulo
    		
    		mov x0, x20
    		mov x1, 26      
   			mov x2, 50                  
    		mov x3, 60               
    		mov x4, 5              
    		movz x5, (PAJARO & 0x0000FFFF), lsl 0	
    		movk x5, (PAJARO >> 16), lsl 16
    		bl dibujar_rectangulo
	
	
			mov x0, x20
    		mov x1, 54      
   			mov x2, 50                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (PICO_PAJARO & 0x0000FFFF), lsl 0	
    		movk x5, (PICO_PAJARO >> 16), lsl 16
    		bl dibujar_rectangulo
	
		
		
		
		
			mov x0, x20
    		mov x1, 160      
   			mov x2, 30                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (PAJARO & 0x0000FFFF), lsl 0	
    		movk x5, (PAJARO >> 16), lsl 16
    		bl dibujar_diagonal_der
	
	
			mov x0, x20
    		mov x1, 160      
   			mov x2, 30                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (PAJARO & 0x0000FFFF), lsl 0	
    		movk x5, (PAJARO >> 16), lsl 16
    		bl dibujar_diagonal_izq
	
	
			mov x0, x20
    		mov x1, 160      
   			mov x2, 30                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (PICO_PAJARO & 0x0000FFFF), lsl 0	
    		movk x5, (PICO_PAJARO >> 16), lsl 16
    		bl dibujar_rectangulo
	
			mov x8, 20000
		
			bl funcion_delay

		
			mov x0, x20
    		mov x1, 26      
   			mov x2, 50                  
    		mov x3, 60               
    		mov x4, 5              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_rectangulo
	
	
			mov x0, x20
    		mov x1, 54      
   			mov x2, 50                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (PAJARO & 0x0000FFFF), lsl 0	
    		movk x5, (PAJARO >> 16), lsl 16
    		bl dibujar_diagonal_der
	
	
			mov x0, x20
    		mov x1, 54      
   			mov x2, 50                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (PAJARO & 0x0000FFFF), lsl 0	
    		movk x5, (PAJARO >> 16), lsl 16
    		bl dibujar_diagonal_izq
	
	
			mov x0, x20
    		mov x1, 54      
   			mov x2, 50                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (PICO_PAJARO & 0x0000FFFF), lsl 0	
    		movk x5, (PICO_PAJARO >> 16), lsl 16
    		bl dibujar_rectangulo
    		
    		
    		mov x8, 20000
		
			bl funcion_delay
		
		
    		mov x0, x20
    		mov x1, 54      
   		mov x2, 50                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_diagonal_der
	
	
		mov x0, x20
    		mov x1, 54      
   		mov x2, 50                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_diagonal_izq
    		
    		mov x0, x20
    		mov x1, 54      
   		mov x2, 50                  
    		mov x3, 5               
    		mov x4, 25              
    		movz x5, (PAJARO & 0x0000FFFF), lsl 0	
    		movk x5, (PAJARO >> 16), lsl 16
    		bl dibujar_rectangulo
	
	
		mov x0, x20
    		mov x1, 54      
   		mov x2, 50                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (PICO_PAJARO & 0x0000FFFF), lsl 0	
    		movk x5, (PICO_PAJARO >> 16), lsl 16
    		bl dibujar_rectangulo
    			
    		mov x8,20000
		
		bl funcion_delay

			
    	b pajaros
	

InfLoop:
	b InfLoop

