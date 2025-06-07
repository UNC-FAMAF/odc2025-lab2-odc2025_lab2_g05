	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34
	
	.include "rutinas.s"

//Definicion de colores
.equ TIERRA, 0xFF999900
.equ PIEDRITA, 0xFFFFFFFF
.equ TIERRA_MEDIA, 0xFF807B37
.equ SOMBRA_TIERRA, 0xFF616422
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
.equ BLANCO_HOJAS, 0xFFFFFFFF
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
.equ AMARILLO_LUZ, 0x00FFFFC5
.equ SOMBRA_SUELO, 0xFF1A202C
.equ ESTRUCTURAS_LEJANAS, 0xFF805AD5
.equ FONDO_OSCURO, 0xFF0D1018
.equ NARANJA, 0xFFFFA42D
.equ NEGRO, 0xFF000000
.equ VIOLETA_CLARO, 0xFFE5CCFF
.equ VIOLETA, 0xFFCC99FF
.equ VIOLETA_OSCURO, 0xFFB266FF


	.globl main




main:

	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	
	//---------------------------------------------Fondo-------------------------------------------------------

	mov x0, x20 	//x0 = framebuffer
	mov x1, 0		//x1 = x_inicio
	mov x2, 0		//x2 = y_inicio
	mov x3, SCREEN_WIDTH		//x3 = ancho	
	mov x4, SCREEN_HEIGH		//x4 = alto
	movz x5, (CIELO & 0x0000FFFF), lsl 0 	//x5 = color	
	movk x5, (CIELO >> 16), lsl 16
	bl dibujar_rectangulo
	

	//---------------------------------------------Suelo-------------------------------------------------------
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
    	
    	
    	
    //---------------------------------------------Sombras de la tierra----------------------------------------
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
    	
    	
	//-------------------------------------------------------Pasto------------------------------------------
	
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

    	
//-----------------------------------------------------Arboles-------------------------------------------------------------
    	
    // ---------------------------------------------- Tronco1 (Izq)  ---------------------------------------------- 
    mov x0, x20
    mov x1, 150     // x_inicio 
   	mov x2, 225                 // y_inicio 
    mov x3, 20              // ancho 
    mov x4, 145             // alto 
    movz x5, (MADERA & 0x0000FFFF), lsl 0	//color
    movk x5, (MADERA >> 16), lsl 16
    bl dibujar_rectangulo
    	
    mov x0, x20
    mov x1, 260     // x_inicio 
   	mov x2, 245                 // y_inicio 
    mov x3, 25              // ancho 
    mov x4, 125             // alto 
    movz x5, (MADERA & 0x0000FFFF), lsl 0	//color
    movk x5, (MADERA >> 16), lsl 16
    bl dibujar_rectangulo
    	
    	
    //----------------------------------------------Sombras del tronco----------------------------------------
	mov x0, x20
    mov x1, 164     // x_inicio 
   	mov x2, 225                 // y_inicio 
    mov x3, 1              // ancho 
    mov x4, 145             // alto 
    movz x5, (SOMBRA_MADERA & 0x0000FFFF), lsl 0	//color
    movk x5, (SOMBRA_MADERA >> 16), lsl 16
    bl dibujar_rectangulo
	
	mov x0, x20
    mov x1, 156     // x_inicio 
   	mov x2, 225                 // y_inicio 
    mov x3, 1              // ancho 
    mov x4, 145             // alto 
    movz x5, (SOMBRA_MADERA & 0x0000FFFF), lsl 0	//color
    movk x5, (SOMBRA_MADERA >> 16), lsl 16
    bl dibujar_rectangulo
    	
    	
    	
    	
// ---------------------------------------------- Sombras de los troncos ---------------------------------------------- 
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
    	
    	
    //------------------------------------------Hojas grandes de los arboles estaticas-------------------------------------------
    	
    mov x0, x20
    mov x1, 95     // x_inicio 
   	mov x2, 95                 // y_inicio 
    mov x3, 130              // ancho 
    mov x4, 130             // alto 
    movz x5, (HOJAS & 0x0000FFFF), lsl 0	//color
    movk x5, (HOJAS >> 16), lsl 16
    bl dibujar_rectangulo
    	
    mov x0, x20
    mov x1, 80     // x_inicio 
   	mov x2, 140                 // y_inicio 
    mov x3, 40              // ancho 
    mov x4, 90             // alto 
    movz x5, (HOJAS & 0x0000FFFF), lsl 0	//color
    movk x5, (HOJAS >> 16), lsl 16
    bl dibujar_rectangulo
    	
    mov x0, x20
    mov x1, 195     // x_inicio 
   	mov x2, 115                 // y_inicio 
    mov x3, 140              // ancho 
    mov x4, 140             // alto 
    movz x5, (HOJAS & 0x0000FFFF), lsl 0	//color
    movk x5, (HOJAS >> 16), lsl 16
    bl dibujar_rectangulo
	
	
	mov x0, x20
    mov x1, 270     // x_inicio 
   	mov x2, 105                 // y_inicio 
    mov x3, 110              // ancho 
    mov x4, 110             // alto 
    movz x5, (HOJAS & 0x0000FFFF), lsl 0	//color
    movk x5, (HOJAS >> 16), lsl 16
    bl dibujar_rectangulo //--- arbol chiquito ---
	



// ---------------------------------------------- INICIO NUBES  ---------------------------------------------- 
	mov x14,#360
	mov x15, #55		
	// ---------------------------------------------- INICIO NUBE 1  ---------------------------------------------- 
		//  ---------------------------------------------- centro 1  ----------------------------------------------
	    	mov x0, x20 //mueve en eje x ➡️
	    	mov x1, x14 //mueve en eje y ⬆️               
	    	add x1, x1,#10 //mueve en eje y ⬆️               
	    	mov x2, 40  //mueve en eje x ⬅️         	    
	    	mov x3, 100  //mueve en eje y ⬇️             
	    	mov x4, 30               
	    	movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0 
	    	movk x5, (BLANCO_HOJAS >> 16), lsl 16
	    	bl dibujar_rectangulo
		//  ---------------------------------------------- circulo superior 1 (IZQ -> DER)  ----------------------------------------------
			mov x0, x20
			mov x1, x14 //UBICAR EN X 
			mov x2, x15  //UBICAR EN y x15=55
			mov x3, 20  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo
		//  ---------------------------------------------- circulo superior 2 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x14 //UBICAR EN X 
			add x1,x1,#20
			sub x15,x15,#20 //x15=55-20
			mov x2, x15  //UBICAR EN y x15=35
			mov x3, 15  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo
		//  ---------------------------------------------- circulo superior 3 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x1 //UBICAR EN X 
			add x1,x1,#20
			mov x2, x15  //UBICAR EN y x15=35
			mov x3, 10  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo
		//  ---------------------------------------------- circulo superior 4 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x1 //UBICAR EN X 
			add x1,x1,#20
			mov x2, x15  //UBICAR EN y x15=35
			mov x3, 18  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo
		//  ---------------------------------------------- circulo superior 5 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x1 //UBICAR EN X 
			add x1,x1,#35
			add x15,x15,#20 //x15=35+20
			mov x2, x15  //UBICAR EN y x15=55
			mov x3, 25  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo

		//  ---------------------------------------------- circulo inferior 1 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x14 //UBICAR EN X 
			add x1,x1,#20
			add x15,x15,#10
			mov x2, x15  //UBICAR EN y
			mov x3, 15  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo
		//  ---------------------------------------------- circulo inferior 2 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x1 //UBICAR EN X 
			add x1,x1,#20
			mov x2, x15  //UBICAR EN y
			mov x3, 10  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo
		//  ---------------------------------------------- circulo inferior 3 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x1 //UBICAR EN X 
			add x1,x1,#20
			mov x2, x15  //UBICAR EN y
			mov x3, 18  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo

	// ---------------------------------------------- FIN NUBE 1  ----------------------------------------------

	// ---------------------------------------------- INICIO NUBE 2  ----------------------------------------------
	 mov x14, 210 
		//  ---------------------------------------------- centro 1  ----------------------------------------------
	    	mov x0, x20 //mueve en eje x ➡️
	    	mov x1, x14 //mueve en eje x ⬆️               
	    	add x1, x1,#10                
	    	mov x2, 50  //mueve en eje x ⬅️         	    
	    	mov x3, 100  //mueve en eje y ⬇️             
	    	mov x4, 30               
	    	movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0 
	    	movk x5, (BLANCO_HOJAS >> 16), lsl 16
	    	bl dibujar_rectangulo
		//  ---------------------------------------------- circulo superior 1 (IZQ -> DER)  ----------------------------------------------
			mov x0, x20
			mov x1, x14 //UBICAR EN X 
			mov x2, x15  //UBICAR EN y x15=55
			mov x3, 20  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo
		//  ---------------------------------------------- circulo superior 2 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x14 //UBICAR EN X 
			add x1,x1,#20
			sub x15,x15,#20 //x15=55-20
			mov x2, x15  //UBICAR EN y x15=35
			mov x3, 15  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo
		//  ---------------------------------------------- circulo superior 3 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x1 //UBICAR EN X 
			add x1,x1,#20
			mov x2, x15  //UBICAR EN y x15=35
			mov x3, 10  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo
		//  ---------------------------------------------- circulo superior 4 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x1 //UBICAR EN X 
			add x1,x1,#23
			mov x2, x15  //UBICAR EN y x15=35
			mov x3, 18  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo
		//  ---------------------------------------------- circulo superior 5 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x1 //UBICAR EN X 
			add x1,x1,#30
			add x15,x15,#20 //x15=35+20
			mov x2, x15  //UBICAR EN y x15=55
			mov x3, 22  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo

		//  ---------------------------------------------- circulo inferior 1 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x14 //UBICAR EN X 
			add x1,x1,#20
			add x15,x15,#10
			mov x2, x15  //UBICAR EN y
			mov x3, 15  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo
		//  ---------------------------------------------- circulo inferior 2 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x1 //UBICAR EN X 
			add x1,x1,#20
			mov x2, 65  //UBICAR EN y
			mov x3, 10  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo
		//  ---------------------------------------------- circulo inferior 3 (IZQ -> DER)  ----------------------------------------------
	
			mov x0, x20
			mov x1, x1 //UBICAR EN X 
			add x1,x1,#20
			mov x2, 65  //UBICAR EN y
			mov x3, 18  //DIAMETRO DEL CIRCULO
			movz x4, (BLANCO_HOJAS & 0x0000FFFF), lsl 0
			movk x4, (BLANCO_HOJAS >> 16), lsl 16
			bl dibujar_circulo
	// ---------------------------------------------- FIN NUBE 2  ---------------------------------------------- 
// ---------------------------------------------- FIN NUBES  ---------------------------------------------- 
		// -------------------------- DEVOLVER A 0 ------------------------------
		mov x14, 0
		mov x15, 0

//-----------------------------------Todo el movimiento de la imagen--------------------------------------------------------
    		
movimiento_pixeles:
    	
    	
		//-------------------------------------- HOJAS DEL ARBOL ------------------------------------------------------------
	mov x12, 0 //contador1
	mov x13, 0 //contador2
	mov x14, 180 //x_inicio2
	mov x15, 300 //x_inicio1
	

	hojas1:
	//---------INICIO importante:-----------------------
		//x1=x_inicio
		//x2=y_inicio
		//x3=ancho   
		//x4=alto    
		//x13=y_inicio desplazado   
		//x14=x_inicio desplazado   
	//---------FIN importante:-----------------------

	// ------ HOJAS LINEA 1 ---------
		//------------- linea 1 hojas -> blanco ------------------
    		mov x0, x20
    		mov x1, x15 
   			mov x2, 135                          
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_izq
			
			mov x8, 2500
			bl funcion_delay

		//------------- linea 1 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x15 
   			mov x2, 135                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_izq

			mov x8, 2500
			bl funcion_delay
	//-------------------------------------------------
			mov x0, x20
    		mov x1, x15 
   			mov x2, 135                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x8, 2500
			bl funcion_delay
		//------------- linea 10 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x15 
   			mov x2, 135                         
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x8, 2500
			bl funcion_delay
	
	
	// --- FIN HOJAS LINEA 1 ---------



	// ------ HOJAS LINEA 2 ---------

		//------------- linea 2 hojas -> blanco ------------------
    		mov x0, x20
    		mov x1, x15 
   			mov x2, 160                        
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_izq

			mov x8, 2500
			bl funcion_delay
			
		//------------- linea 2 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x15 
   			mov x2, 160                        
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_izq

			mov x8, 2500
			bl funcion_delay

			mov x0, x20
    		mov x1, x15 
   			mov x2, 160                        
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x8, 2500
			bl funcion_delay

		//------------- linea 2 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x15
   			mov x2, 160                        
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x8, 2500
			bl funcion_delay


	// --- FIN HOJAS LINEA 2 ---------
	
	// ------ HOJAS LINEA 3 ---------
		//------------- linea 3 hojas -> blanco ------------------
    		mov x0, x20
    		mov x1, x15 
   			mov x2, 185                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_izq

			mov x8, 2500
			bl funcion_delay

		//------------- linea 3 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x15 
   			mov x2, 185                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_izq

			mov x8, 2500
			bl funcion_delay
			
			mov x0, x20
    		mov x1, x15 
   			mov x2, 185                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x8, 2500
			bl funcion_delay

		//------------- linea 10 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x15 
   			mov x2, 185                          
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x8, 2500
			bl funcion_delay

	// --- FIN HOJAS LINEA 3 ---------

	// ------ HOJAS LINEA 4 ---------
		//------------- linea 4 hojas -> blanco ------------------
    		mov x0, x20
    		mov x1, x15 
   			mov x2, 210                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_izq

			mov x8, 2500
			bl funcion_delay

		//------------- linea 4 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x15 
   			mov x2, 210                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_izq

			mov x8, 2500
			bl funcion_delay

		//------------- linea 4 hojas -> blanco ------------------
    		mov x0, x20
    		mov x1, x15 
   			mov x2, 210                          
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x8, 2500
			bl funcion_delay

		//------------- linea 4 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x15 
   			mov x2, 210                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_der
	// --- FIN HOJAS LINEA 4 ---------
	
		// ----------Condicion del bucle hojas primera parte y desplazamiento de x_inicio------------------------

			sub x15, x15, 25
			add x12, x12, 1
			cmp x12, 4
			blt hojas1


	//---------------------Inicializacion de nuevo de las variables-------------------------		

		mov x12, 0 //contador1
		mov x13, 0 //contador2
		mov x14, 180 //x_inicio2
		mov x15, 300 //x_inicio1


		hojas2:
	// ------ HOJAS LINEA 5 ---------
		//------------- linea 5 hojas -> blanco ------------------
    		mov x0, x20
    		mov x1, x14 
   			mov x2, 120                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_izq

			mov x8, 2500
			bl funcion_delay

		//------------- linea 5 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x14 
   			mov x2, 120                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_izq

			mov x8, 2500
			bl funcion_delay

		//------------- linea 5 hojas -> blanco ------------------
			mov x0, x20
    		mov x1, x14 
   			mov x2, 120                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x8, 2500
			bl funcion_delay

		//------------- linea 5 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x14 
   			mov x2, 120                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_der

	// --- FIN HOJAS LINEA 5 ---------
	
	// ------ HOJAS LINEA 6 ---------
		//------------- linea 6 hojas -> blanco ------------------
    		mov x0, x20
    		mov x1, x14 
   			mov x2, 145                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_izq

			mov x8, 2500
			bl funcion_delay

		//------------- linea 6 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x14
   			mov x2, 145                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_izq

			mov x8, 2500
			bl funcion_delay

		//------------- linea 8 hojas -> blanco ------------------
			mov x0, x20
    		mov x1, x14 //x14=119
   			mov x2, 145                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x8, 2500
			bl funcion_delay

		//------------- linea 8 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x14 
   			mov x2, 145                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_der

			


	// --- FIN HOJAS LINEA 6 ---------
	// ------ HOJAS LINEA 7 ---------
		//------------- linea 7 hojas -> blanco ------------------
    		mov x0, x20
    		mov x1, x14 
   			mov x2, 170                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_izq

			mov x8, 2500
			bl funcion_delay

		//------------- linea 7 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x14 
   			mov x2, 170                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_izq

			mov x8, 2500
			bl funcion_delay

			//------------- linea 7 hojas -> blanco ------------------
    		mov x0, x20
    		mov x1, x14 
   			mov x2, 170                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (BLANCO_HOJAS & 0x0000FFFF), lsl 0	
    		movk x5, (BLANCO_HOJAS >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x8, 2500
			bl funcion_delay

		//------------- linea 7 hojas -> verde ------------------
    		mov x0, x20
    		mov x1, x14 
   			mov x2, 170                       
    		mov x3, 4               
    		mov x4, 5              
    		movz x5, (VERDE_CLARO & 0x0000FFFF), lsl 0	
    		movk x5, (VERDE_CLARO >> 16), lsl 16
    		bl dibujar_diagonal_der

		
	// --- FIN HOJAS LINEA 7 ---------

	// -------- condicion del bucle hojas segunda parte y desplazamiento de x_inicio--------------------
		sub x14, x14, 25
    	add x13, x13, 1
    	cmp x13, 3
		blt hojas2
// -------------------------- DEVOLVER A 0 ------------------------------
	mov x12, 0
	mov x13, 0
	mov x14, 0
	mov x15, 0
	mov x18, 0




//-----------------------------------------Flores en movimiento-------------------------------------------------------------
	
	//-----------------------------------------------Flor del medio--------------------------------------------------------------
		mov x0, x20
    	mov x1, 362     // x_inicio 
   		mov x2, 349                 // y_inicio 
		mov x3, 6              // ancho 
		mov x4, 6             // alto 
   		movz x5, (CIELO & 0x0000FFFF), lsl 0	//color
   		movk x5, (CIELO >> 16), lsl 16
		bl dibujar_diagonal_izq
	
		mov x0, x20
    	mov x1, 360    //x_inicio  
   		mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 7      //alto        
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	
		mov x0, x20
    	mov x1, 380    //x_inicio  
   		mov x2, 348    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 25      //alto        
    	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 373    //x_inicio  
   		mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 6      //alto        
    	movz x5, (NARANJA & 0x0000FFFF), lsl 0	
    	movk x5, (NARANJA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	//-----------------------------------------------Flor de la izquierda--------------------------------------------------------------
    	
    	mov x0, x20
    	mov x1, 192     // x_inicio 
   		mov x2, 349                 // y_inicio 
		mov x3, 6              // ancho 
		mov x4, 6             // alto 
   		movz x5, (CIELO & 0x0000FFFF), lsl 0	//color
   		movk x5, (CIELO >> 16), lsl 16
		bl dibujar_diagonal_izq
	
		mov x0, x20
    	mov x1, 190    //x_inicio  
   		mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 7      //alto        
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	
    	mov x0, x20
    	mov x1, 210    //x_inicio  
   		mov x2, 348    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 25      //alto        
    	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 203    //x_inicio  
   		mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 6      //alto        
    	movz x5, (NARANJA & 0x0000FFFF), lsl 0	
    	movk x5, (NARANJA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	//-----------------------------------------------Flor de la derecha--------------------------------------------------------------
    	
    	mov x0, x20
    	mov x1, 442     // x_inicio 
   		mov x2, 349                 // y_inicio 
		mov x3, 6              // ancho 
		mov x4, 6             // alto 
   		movz x5, (CIELO & 0x0000FFFF), lsl 0	//color
   		movk x5, (CIELO >> 16), lsl 16
		bl dibujar_diagonal_izq
	
		mov x0, x20
    	mov x1, 440    //x_inicio  
   		mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 7      //alto        
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	
    	mov x0, x20
    	mov x1, 460    //x_inicio  
   		mov x2, 348    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 25      //alto        
    	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 453    //x_inicio  
   		mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 6      //alto        
    	movz x5, (NARANJA & 0x0000FFFF), lsl 0	
    	movk x5, (NARANJA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	
    	mov x8, 18000
		bl funcion_delay
	
	//-----------------------------------------------Flor del medio--------------------------------------------------------------
	
		mov x0, x20
    	mov x1, 380    //x_inicio  
   		mov x2, 348    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 25      //alto 
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	//color
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 373    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 6      //alto        
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
	
	
    	mov x0, x20
    	mov x1, 380    //x_inicio  
   	mov x2, 362    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 11      //alto        
    	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 375    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 16      //alto        
    	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 368    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 6      //alto        
    	movz x5, (NARANJA & 0x0000FFFF), lsl 0	
    	movk x5, (NARANJA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	//-----------------------------------------------Flor de la izquierda--------------------------------------------------------------
    	
    	mov x0, x20
    	mov x1, 210    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 25      //alto  
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	//color
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 203    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 6      //alto         
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	
    	mov x0, x20
    	mov x1, 210    //x_inicio  
   	mov x2, 362    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 11      //alto        
    	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 205    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 16      //alto        
    	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 198    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 6      //alto        
    	movz x5, (NARANJA & 0x0000FFFF), lsl 0	
    	movk x5, (NARANJA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	//-----------------------------------------------Flor de la derecha--------------------------------------------------------------
    	
    	mov x0, x20
    	mov x1, 460    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 25      //alto    
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	//color
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 453    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 6      //alto         
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	
    	mov x0, x20
    	mov x1, 460    //x_inicio  
   	mov x2, 362    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 11      //alto        
    	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 455    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 16      //alto        
    	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 448    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 6      //alto        
    	movz x5, (NARANJA & 0x0000FFFF), lsl 0	
    	movk x5, (NARANJA >> 16), lsl 16
    	bl dibujar_rectangulo

    	
    	mov x8, 18000
		bl funcion_delay
	
	
	mov x0, x20
    	mov x1, 380    //x_inicio  
   	mov x2, 362    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 11      //alto        
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 375    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 16      //alto        
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 368    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 6      //alto        
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
	
	
	mov x0, x20
    	mov x1, 362     // x_inicio 
   	mov x2, 349                 // y_inicio 
	mov x3, 6              // ancho 
	mov x4, 6             // alto 
   	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	//color
   	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
	bl dibujar_diagonal_izq
	
	mov x0, x20
    	mov x1, 360    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 7      //alto        
    	movz x5, (NARANJA & 0x0000FFFF), lsl 0	
    	movk x5, (NARANJA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	
    	mov x0, x20
    	mov x1, 210    //x_inicio  
   	mov x2, 362    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 11      //alto        
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 205    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 16      //alto        
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 198    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 6      //alto        
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	
    	mov x0, x20
    	mov x1, 192     // x_inicio 
   	mov x2, 349                 // y_inicio 
	mov x3, 6              // ancho 
	mov x4, 6             // alto 
   	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	//color
   	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
	bl dibujar_diagonal_izq
	
	mov x0, x20
    	mov x1, 190    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 7      //alto        
    	movz x5, (NARANJA & 0x0000FFFF), lsl 0	
    	movk x5, (NARANJA >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	
    	
    	mov x0, x20
    	mov x1, 460    //x_inicio  
   	mov x2, 362    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 11      //alto        
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 455    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 6      //ancho         
    	mov x4, 16      //alto        
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 448    //x_inicio  
   	mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 6      //alto        
    	movz x5, (CIELO & 0x0000FFFF), lsl 0	
    	movk x5, (CIELO >> 16), lsl 16
    	bl dibujar_rectangulo
    	
    	mov x0, x20
    	mov x1, 442     // x_inicio 
   	mov x2, 349                 // y_inicio 
	mov x3, 6              // ancho 
	mov x4, 6             // alto 
   	movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	//color
   	movk x5, (HOJAS_OSCURAS >> 16), lsl 16
	bl dibujar_diagonal_izq
	
		mov x0, x20
    	mov x1, 440    //x_inicio  
   		mov x2, 348    //y_inicio              
    	mov x3, 20      //ancho         
    	mov x4, 7      //alto        
    	movz x5, (NARANJA & 0x0000FFFF), lsl 0	
    	movk x5, (NARANJA >> 16), lsl 16
    	bl dibujar_rectangulo




    	
    	//--------------------------------------------Hojas en movimiento-----------------------------------------

			//--------------------------------------Hoja del extremo izquierdo------------------------------------
			mov x0, x20
    		mov x1, 90      
   			mov x2, 230                  
    		mov x3, 6               
    		mov x4, 6              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x0, x20
    		mov x1, 90      
   			mov x2, 230                  
    		mov x3, 6               
    		mov x4, 30              
    		movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    		movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    		bl dibujar_rectangulo

			//--------------------------------------Hoja izquierda a la del medio------------------------------------
			mov x0, x20
    		mov x1, 130      
   			mov x2, 225                  
    		mov x3, 6               
    		mov x4, 6              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x0, x20
    		mov x1, 130      
   			mov x2, 225                  
    		mov x3, 6               
    		mov x4, 30              
    		movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    		movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    		bl dibujar_rectangulo

			//--------------------------------------Hoja del medio------------------------------------

			mov x0, x20
    		mov x1, 205      
   			mov x2, 255                  
    		mov x3, 6               
    		mov x4, 6              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x0, x20
    		mov x1, 205      
   			mov x2, 255                  
    		mov x3, 6               
    		mov x4, 30              
    		movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    		movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    		bl dibujar_rectangulo

			//--------------------------------------Hoja derecha a la del medio------------------------------------

			mov x0, x20
    		mov x1, 250      
   			mov x2, 255                  
    		mov x3, 6               
    		mov x4, 6              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x0, x20
    		mov x1, 250      
   			mov x2, 255                  
    		mov x3, 6               
    		mov x4, 30              
    		movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    		movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    		bl dibujar_rectangulo

			//--------------------------------------Hoja del extremo derecho------------------------------------

			mov x0, x20
    		mov x1, 310      
   			mov x2, 255                  
    		mov x3, 6               
    		mov x4, 6              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_diagonal_der

			mov x0, x20
    		mov x1, 310      
   			mov x2, 255                  
    		mov x3, 6               
    		mov x4, 30              
    		movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    		movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    		bl dibujar_rectangulo


			mov x8, 22000
			bl funcion_delay


			//--------------------------------------Hoja del extremo izquierdo------------------------------------

			mov x0, x20
    		mov x1, 90      
   			mov x2, 230                  
    		mov x3, 6               
    		mov x4, 30              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_rectangulo

			mov x0, x20
    		mov x1, 90      
   			mov x2, 230                  
    		mov x3, 6               
    		mov x4, 6              
    		movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    		movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    		bl dibujar_diagonal_der

			//--------------------------------------Hoja izquierda a la del medio------------------------------------

			mov x0, x20
    		mov x1, 130      
   			mov x2, 225                  
    		mov x3, 6               
    		mov x4, 30              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_rectangulo

			mov x0, x20
    		mov x1, 130      
   			mov x2, 225                  
    		mov x3, 6               
    		mov x4, 6              
    		movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    		movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    		bl dibujar_diagonal_der

			//--------------------------------------Hoja del medio------------------------------------

			mov x0, x20
    		mov x1, 205      
   			mov x2, 255                  
    		mov x3, 6               
    		mov x4, 30              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_rectangulo

			mov x0, x20
    		mov x1, 205      
   			mov x2, 255                  
    		mov x3, 6               
    		mov x4, 6              
    		movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    		movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    		bl dibujar_diagonal_der

			//--------------------------------------Hoja derecha a la del medio------------------------------------

			mov x0, x20
    		mov x1, 250      
   			mov x2, 255                  
    		mov x3, 6               
    		mov x4, 30              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_rectangulo

			mov x0, x20
    		mov x1, 250      
   			mov x2, 255                  
    		mov x3, 6               
    		mov x4, 6              
    		movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    		movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    		bl dibujar_diagonal_der

			//--------------------------------------Hoja del extremo derecho------------------------------------

			mov x0, x20
    		mov x1, 310      
   			mov x2, 255                  
    		mov x3, 6               
    		mov x4, 30              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_rectangulo

			mov x0, x20
    		mov x1, 310      
   			mov x2, 255                  
    		mov x3, 6               
    		mov x4, 6              
    		movz x5, (HOJAS_OSCURAS & 0x0000FFFF), lsl 0	
    		movk x5, (HOJAS_OSCURAS >> 16), lsl 16
    		bl dibujar_diagonal_der




    	
    	//--------------------------------Pajaros en movimiento Y letras de odc 2025----------------------------------

		//En esta parte necesitabamos intercalar el movimiento de los pajaros con las letras
		//Ya que si le hacemos el codigo en un lugar apartado sin intercalarlo con el codigo del movimiento de los pajaros
		//Nos quedaria muy a destiempo la animacion de las letras

			//-----------------------------------Letra O-----------------------------------------------------

		mov x0, x20 
    	mov x1, 502                
    	mov x2, 45           	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 500                
    	mov x2, 50            	    
    	mov x3, 5               
    	mov x4, 40               
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 520             
    	mov x2, 50            	    
    	mov x3, 5               
    	mov x4, 40               
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 502                
    	mov x2, 90          	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo						
										

			//-----------------------------------Letra D-----------------------------------------------------

		mov x0, x20
    	mov x1, 535               
    	mov x2, 45         	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 535                
    	mov x2, 48            	    
    	mov x3, 5               
    	mov x4, 45               
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 555                
    	mov x2, 49            	    
    	mov x3, 5               
    	mov x4, 40               
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo
    			
    	mov x0, x20
    	mov x1, 535                
    	mov x2, 89            	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo


			//-----------------------------------Letra C-----------------------------------------------------

		mov x0, x20
    	mov x1, 565               
    	mov x2, 45         	    
    	mov x3, 20             
    	mov x4, 4             
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 565                
    	mov x2, 48            	    
    	mov x3, 5               
    	mov x4, 45               
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 565                
    	mov x2, 89            	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo


			//-----------------------------------Numero 2-----------------------------------------------------


		mov x0, x20
    	mov x1, 502                 
    	mov x2, 115            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 515                
    	mov x2, 116           	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 502                 
    	mov x2, 126            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 502                
    	mov x2, 130           	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

	
    	mov x0, x20
    	mov x1, 502                 
    	mov x2, 140            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

			//-----------------------------------Numero 0-----------------------------------------------------


    	mov x0, x20
		mov x1, 538 
		mov x2, 128 
		mov x3, 15 

		movz x4, (VIOLETA_CLARO & 0x0000FFFF), lsl 0
		movk x4, (VIOLETA_CLARO >> 16), lsl 16
		bl dibujar_circulo
    	
		mov x0, x20
		mov x1, 538 
		mov x2, 128 
		mov x3, 11 
		movz x4, (CIELO & 0x0000FFFF), lsl 0
		movk x4, (CIELO >> 16), lsl 16
		bl dibujar_circulo

			//-----------------------------------Numero 2-----------------------------------------------------

		
    	mov x0, x20
    	mov x1, 560                 
    	mov x2, 115            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 573                
    	mov x2, 116            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 560                 
    	mov x2, 126            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 560                
    	mov x2, 130            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 560                 
    	mov x2, 140            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

			//-----------------------------------Numero 5-----------------------------------------------------


    	mov x0, x20
    	mov x1, 583                 
    	mov x2, 115            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 583                
    	mov x2, 116            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 583                 
    	mov x2, 126            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 596                
    	mov x2, 130            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo

	
    	mov x0, x20
    	mov x1, 582                 
    	mov x2, 140            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_CLARO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_CLARO >> 16), lsl 16
    	bl dibujar_rectangulo





			//-----------------------------------Pajaro izquierdo-----------------------------------------------------
    	
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
    		mov x4, 5              
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
	
		
			//-----------------------------------Pajaro derecho-----------------------------------------------------

			mov x0, x20
    		mov x1, 132      
   			mov x2, 30                  
    		mov x3, 60               
    		mov x4, 5              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_rectangulo
	
	
			mov x0, x20
    		mov x1, 160      
   			mov x2, 30                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
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



			//-----------------------------------Letra O-----------------------------------------------------

		mov x0, x20 
    	mov x1, 502                
    	mov x2, 45           	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 500                
    	mov x2, 50            	    
    	mov x3, 5               
    	mov x4, 40               
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 520             
    	mov x2, 50            	    
    	mov x3, 5               
    	mov x4, 40               
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 502                
    	mov x2, 90          	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo						
										

			//-----------------------------------Letra D-----------------------------------------------------

		mov x0, x20
    	mov x1, 535               
    	mov x2, 45         	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 535                
    	mov x2, 48            	    
    	mov x3, 5               
    	mov x4, 45               
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 555                
    	mov x2, 49            	    
    	mov x3, 5               
    	mov x4, 40               
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo
    			
    	mov x0, x20
    	mov x1, 535                
    	mov x2, 89            	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo


			//-----------------------------------Letra C-----------------------------------------------------

		mov x0, x20
    	mov x1, 565               
    	mov x2, 45         	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 565                
    	mov x2, 48            	    
    	mov x3, 5               
    	mov x4, 45               
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 565                
    	mov x2, 89            	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo


			//-----------------------------------Numero 2-----------------------------------------------------


		mov x0, x20
    	mov x1, 502                 
    	mov x2, 115            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 515                
    	mov x2, 116           	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 502                 
    	mov x2, 126            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 502                
    	mov x2, 130           	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

	
    	mov x0, x20
    	mov x1, 502                 
    	mov x2, 140            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

			//-----------------------------------Numero 0-----------------------------------------------------


    	mov x0, x20
		mov x1, 538 
		mov x2, 128 
		mov x3, 15 

		movz x4, (VIOLETA & 0x0000FFFF), lsl 0
		movk x4, (VIOLETA >> 16), lsl 16
		bl dibujar_circulo
    	
		mov x0, x20
		mov x1, 538 
		mov x2, 128 
		mov x3, 11 
		movz x4, (CIELO & 0x0000FFFF), lsl 0
		movk x4, (CIELO >> 16), lsl 16
		bl dibujar_circulo

			//-----------------------------------Numero 2-----------------------------------------------------

		
    	mov x0, x20
    	mov x1, 560                 
    	mov x2, 115            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 573                
    	mov x2, 116            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 560                 
    	mov x2, 126            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 560                
    	mov x2, 130            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 560                 
    	mov x2, 140            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

			//-----------------------------------Numero 5-----------------------------------------------------


    	mov x0, x20
    	mov x1, 583                 
    	mov x2, 115            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 583                
    	mov x2, 116            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 583                 
    	mov x2, 126            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 596                
    	mov x2, 130            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo

	
    	mov x0, x20
    	mov x1, 582                 
    	mov x2, 140            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA >> 16), lsl 16
    	bl dibujar_rectangulo





			//-----------------------------------Pajaro izquierdo-----------------------------------------------------

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
    		

			//-----------------------------------Pajaro derecho-----------------------------------------------------

			mov x0, x20
    		mov x1, 160      
   			mov x2, 30                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_diagonal_der
	
	
			mov x0, x20
    		mov x1, 160      
   			mov x2, 30                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_diagonal_izq
    		
    		mov x0, x20
    		mov x1, 160      
   		mov x2, 30                  
    		mov x3, 5               
    		mov x4, 25              
    		movz x5, (PAJARO & 0x0000FFFF), lsl 0	
    		movk x5, (PAJARO >> 16), lsl 16
    		bl dibujar_rectangulo
	
	
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
		

			//-----------------------------------Letra O-----------------------------------------------------

		mov x0, x20 
    	mov x1, 502                
    	mov x2, 45           	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 500                
    	mov x2, 50            	    
    	mov x3, 5               
    	mov x4, 40               
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 520             
    	mov x2, 50            	    
    	mov x3, 5               
    	mov x4, 40               
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 502                
    	mov x2, 90          	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo						
										

			//-----------------------------------Letra D-----------------------------------------------------

		mov x0, x20
    	mov x1, 535               
    	mov x2, 45         	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 535                
    	mov x2, 48            	    
    	mov x3, 5               
    	mov x4, 45               
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 555                
    	mov x2, 49            	    
    	mov x3, 5               
    	mov x4, 40               
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo
    			
    	mov x0, x20
    	mov x1, 535                
    	mov x2, 89            	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo


			//-----------------------------------Letra C-----------------------------------------------------

		mov x0, x20
    	mov x1, 565               
    	mov x2, 45         	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 565                
    	mov x2, 48            	    
    	mov x3, 5               
    	mov x4, 45               
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 565                
    	mov x2, 89            	    
    	mov x3, 20               
    	mov x4, 4               
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo


			//-----------------------------------Numero 2-----------------------------------------------------


		mov x0, x20
    	mov x1, 502                 
    	mov x2, 115            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 515                
    	mov x2, 116           	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 502                 
    	mov x2, 126            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 502                
    	mov x2, 130           	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

	
    	mov x0, x20
    	mov x1, 502                 
    	mov x2, 140            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

			//-----------------------------------Numero 0-----------------------------------------------------


    	mov x0, x20
		mov x1, 538 
		mov x2, 128 
		mov x3, 15 

		movz x4, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0
		movk x4, (VIOLETA_OSCURO >> 16), lsl 16
		bl dibujar_circulo
    	
		mov x0, x20
		mov x1, 538 
		mov x2, 128 
		mov x3, 11 
		movz x4, (CIELO & 0x0000FFFF), lsl 0
		movk x4, (CIELO >> 16), lsl 16
		bl dibujar_circulo

			//-----------------------------------Numero 2-----------------------------------------------------

		
    	mov x0, x20
    	mov x1, 560                 
    	mov x2, 115            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 573                
    	mov x2, 116            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 560                 
    	mov x2, 126            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 560                
    	mov x2, 130            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 560                 
    	mov x2, 140            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

			//-----------------------------------Numero 5-----------------------------------------------------


    	mov x0, x20
    	mov x1, 583                 
    	mov x2, 115            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo


    	mov x0, x20
    	mov x1, 583                
    	mov x2, 116            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 583                 
    	mov x2, 126            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

    	mov x0, x20
    	mov x1, 596                
    	mov x2, 130            	    
    	mov x3, 5                  
    	mov x4, 10                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo

	
    	mov x0, x20
    	mov x1, 582                 
    	mov x2, 140            	    
    	mov x3, 18                  
    	mov x4, 4                   
    	movz x5, (VIOLETA_OSCURO & 0x0000FFFF), lsl 0 
    	movk x5, (VIOLETA_OSCURO >> 16), lsl 16
    	bl dibujar_rectangulo




		//-----------------------------------Pajaro izquierdo-----------------------------------------------------

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
    		

		//-----------------------------------Pajaro derecho-----------------------------------------------------

			mov x0, x20
    		mov x1, 160      
   		mov x2, 30                  
    		mov x3, 5               
    		mov x4, 25              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_rectangulo
	
	
		mov x0, x20
    		mov x1, 160      
   		mov x2, 30                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
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


			//-----------------------------------Pajaro izquierdo-----------------------------------------------------

			mov x0, x20
    		mov x1, 54      
   		mov x2, 50                  
    		mov x3, 5               
    		mov x4, 25              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_rectangulo
	
		mov x0, x20
    		mov x1, 54      
   		mov x2, 50                  
    		mov x3, 5               
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

			//-----------------------------------Pajaro derecho-----------------------------------------------------

			mov x0, x20
    		mov x1, 160      
   			mov x2, 30                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_diagonal_der
	
	
			mov x0, x20
    		mov x1, 160      
   			mov x2, 30                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (CIELO & 0x0000FFFF), lsl 0	
    		movk x5, (CIELO >> 16), lsl 16
    		bl dibujar_diagonal_izq
	
			mov x0, x20
    		mov x1, 132      
   			mov x2, 30                  
    		mov x3, 60               
    		mov x4, 5              
    		movz x5, (PAJARO & 0x0000FFFF), lsl 0	
    		movk x5, (PAJARO >> 16), lsl 16
    		bl dibujar_rectangulo
	
	
			mov x0, x20
    		mov x1, 160      
   			mov x2, 30                  
    		mov x3, 5               
    		mov x4, 5              
    		movz x5, (PICO_PAJARO & 0x0000FFFF), lsl 0	
    		movk x5, (PICO_PAJARO >> 16), lsl 16
    		bl dibujar_rectangulo



    	b movimiento_pixeles
	

InfLoop:
	b InfLoop

