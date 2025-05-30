# Lab Org. y Arq. de Computadoras

* Configuración de pantalla: `640x480` pixels, formato `ARGB` 32 bits.
* El registro `X0` contiene la dirección base del FrameBuffer (Pixel 1).
* El código de cada consigna debe ser escrito en el archivo _app.s_.
* El archivo _start.s_ contiene la inicialización del FrameBuffer **(NO EDITAR)**, al finalizar llama a _app.s_.
* El código de ejemplo pinta toda la pantalla un solo color.

## Estructura

* **[app.s](app.s)** Este archivo contiene a apliación. Todo el hardware ya está inicializado anteriormente.
* **[start.s](start.s)** Este archivo realiza la inicialización del hardware.
* **[Makefile](Makefile)** Archivo que describe como construir el software _(que ensamblador utilizar, que salida generar, etc)_.
* **[memmap](memmap)** Este archivo contiene la descripción de la distribución de la memoria del programa y donde colocar cada sección.

* **README.md** este archivo.

## Uso

El archivo _Makefile_ contiene lo necesario para construir el proyecto.
Se pueden utilizar otros archivos **.s** si les resulta práctico para emprolijar el código y el Makefile los ensamblará.

**Para correr el proyecto ejecutar**

```bash
$ make runQEMU
```
Esto construirá el código y ejecutará qemu para su emulación.

Si qemu se queja con un error parecido a `qemu-system-aarch64: unsupported machine type`, prueben cambiar `raspi3` por `raspi3b` en la receta `runQEMU` del **Makefile** (línea 23 si no lo cambiaron).


## Como correr qemu y gcc usando Docker containers

Los containers son maquinas virtuales livianas que permiten correr procesos individuales como el qemu y gcc.

Para seguir esta guia primero tienen que instala docker y asegurarse que el usuario que vayan a usar tenga permiso para correr docker (ie dockergrp) o ser root

### Linux
 * Para construir el container hacer
```bash
docker build -t famaf/rpi-qemu .
```
 * Para arrancarlo
```bash
xhost +
docker run -dt --name rpi-qemu --rm -v $(pwd):/local --privileged -e "DISPLAY=${DISPLAY:-:0.0}" -v /tmp/.X11-unix:/tmp/.X11-unix -v "$HOME/.Xauthority:/root/.Xauthority:rw" famaf/rpi-qemu
```
 * Para correr el emulador para el ejericico 1:
```bash
docker exec -d rpi-qemu make runQEMU -C ./ejercicio1/
```

 * Para correr el emulador para el ejericico 2:
```bash
docker exec -d rpi-qemu make runQEMU -C ./ejercicio2/
```

 * Para debuggear con gdb (por ej. el ejercicio 1) tienen que correr el qemu en modo debug:
```bash
docker exec -d rpi-qemu make runQEMU_debug -C ./ejercicio1/
```
y luego el docker en modo iterativo y adentro el gdb:
```bash
docker exec -it rpi-qemu make runGDB -C ./ejercicio1/
```

 * Para terminar el container
```bash
docker kill rpi-qemu
```

----------------------------------
### Otros comandos utiles
```bash
# Correr el container en modo interactivo
docker run -it --rm -v $(pwd):/local --privileged -e "DISPLAY=${DISPLAY:-:0.0}" -v /tmp/.X11-unix:/tmp/.X11-unix -v "$HOME/.Xauthority:/root/.Xauthority:rw" famaf/rpi-qemu
# Correr un shell en el container
docker exec -it rpi-qemu /bin/bash
```

### MacOS
En MacOS primero tienen que [instalar un X server](https://medium.com/@mreichelt/how-to-show-x11-windows-within-docker-on-mac-50759f4b65cb) (se recomienda XQuartz). Además, se deben permitir las conexiones de clientes de red, esto se hace entrando a los ajustes del XQuartz, en la pestaña de Seguridad. Luego los comandos para correr el docker, el emulador, el gdb, etc. son iguales que en linux
