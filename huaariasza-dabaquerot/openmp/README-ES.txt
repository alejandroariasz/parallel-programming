Aplicacion Blur-effect

Para utilizar la aplicación es necesario instalar OpenCV

https://docs.opencv.org/trunk/d7/d9f/tutorial_linux_install.html

una vez instalado el comando de compilación es el siguiente

g++ -I/usr/include/opencv -I/usr/include/opencv2 -L/usr/local/lib/ -g -o bluromp blur-openmp.cpp -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_ml -lopencv_video -lopencv_features2d -lopencv_calib3d -lopencv_objdetect -lopencv_contrib -lopencv_legacy -lopencv_stitching -fopenmp --std=c++11  

Siendo 

g++ el compilador a utilizar
bluromp nombre del ejecutable a generar
blur-openmp.cpp programa que realiza el efecto de blur
-fopenmp comando para usar las librerías de openmp
--std=c++11 comando para utilizar la última versión de c++

ejecutar aplicación 

./bluromp mario720.jpg 3 2 1

siendo

bluromp nombre del ejecutable a generado
mario720.jpg nombre de la imágen (debe estar en el directorio img)
3 tamaño del kernel a utilizar en el efecto de blur
2 número de hilos a lanzar para hacer el cálculo del efecto de blur
1 variable para cambiar a modo de prueba (si es 0 se verá la imágen resultante, si es uno solo se verán los datos de desempeño)

este programa mostrará en consola algo como lo que se muestra a continuación

1280x720	2	5	475,708 ms

siendo

1280x720 tamaño de la imágen
2 número de hilos
5 tamaño del kernel
475,708 ms tiempo de ejecución

Para ver el rendimiento general basta con ejecutar el archivo script_ejecutar_todo.sh, con el comando 

sh ./script_ejecutar_todo.sh

al finalizar en el archivo timeopenmp.txt se generará una lista con el rendimiento para diferentes imágenes, número de hilos y tamaños de kernel.
