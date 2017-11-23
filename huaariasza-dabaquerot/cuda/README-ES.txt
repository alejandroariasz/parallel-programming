Aplicación Blur-effect

Para utilizar la aplicación es necesario instalar OpenCV

https://docs.opencv.org/trunk/d7/d9f/tutorial_linux_install.html

e instalar cuda

http://www.nvidia.es/object/cuda-parallel-computing-es.html

una vez instalados los programas necesarios el comando de compilación es el siguiente

make

El makefile tiene configurada la compilación del programa, sin embargo este programa depende de la instalación de cuda en la cuál se tiene en cuenta la arquitectura del sistema operativo y de la GPU, por lo tanto puede no funcionar en otros equipos, para realizar los ajustes necesarios y lograr correr el programa:

1 Entrar a la carpeta de instalación de cuda, tomar el makefile de alguno de los ejemplos y reemplazar el makefile utilizado.

2 ajustar la ruta de instalación de cuda (CUDA_PATH), esta variable debe tener una ruta absoluta, a continuación se muestra un ejemplo de dicha ruta:

CUDA_PATH ?= /usr/local/cuda-9.0

2 Reemplazar el segmento de compilación:

# Target rules
all: build

build: blur-cuda

check.deps:
ifeq ($(SAMPLE_ENABLED),0)
	@echo "Sample will be waived due to the above missing dependencies"
else
	@echo "Sample is ready - all dependencies have been met"
endif

blur-cuda.o: blur-cuda.cu
	$(EXEC) $(NVCC) -I/usr/include/opencv -I/usr/include/opencv2 -L/usr/local/lib/ $(INCLUDES) $(ALL_CCFLAGS) $(GENCODE_FLAGS) -o $@ -c $<

blur-cuda: blur-cuda.o
	$(EXEC) $(NVCC) $(ALL_LDFLAGS) $(GENCODE_FLAGS) -o $@ $+ $(LIBRARIES) -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_ml -lopencv_video -lopencv_features2d -lopencv_calib3d -lopencv_objdetect -lopencv_contrib -lopencv_legacy -lopencv_stitching --std=c++11

run: build
	$(EXEC) ./blur-cuda mario720.jpg 3 1 

clean:
	rm -f blur-cuda blur-cuda.o
	#rm -rf ../../bin/$(TARGET_ARCH)/$(TARGET_OS)/$(BUILD_TYPE)/vectorAdd

clobber: clean

El segmento de compilación debe indicar los archivos de salida y las librerías a importar. 

Siendo 

blur-cuda nombre del ejecutable a generar
blur-cuda.cu programa que realiza el efecto de blur
--std=c++11 comando para utilizar la última versión de c++

ejecutar aplicación 

./blur-cuda mario720.jpg 3 256 1 1

siendo

blur-cuda nombre del ejecutable a generado
mario720.jpg nombre de la imágen (debe estar en el directorio img)
3 tamaño del kernel a utilizar en el efecto de blur
256 número de hilos a lanzar para hacer el cálculo del efecto de blur
1 número de bloques a utilizar en la GPU
1 variable para cambiar a modo de prueba (si es 0 se verá la imágen resultante, si es uno solo se verán los datos de desempeño)

este programa mostrará en consola algo como lo que se muestra a continuación

1280x720	256	1	3	5766.91 ms

siendo

1280x720 tamaño de la imágen
256 número de hilos
1 Número de bloques
3 tamaño del kernel
5766.91 ms tiempo de ejecución

Para ver el rendimiento general basta con ejecutar el archivo script_ejecutar_todo.sh, con el comando 

sh ./script_ejecutar_todo.sh

al finalizar en el archivo timeocuda.txt se generará una lista con el rendimiento para diferentes imágenes, número de hilos, número de bloques y tamaños de kernel.
