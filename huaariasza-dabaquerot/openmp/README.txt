Blur-effect application

Before start you need to install OpenCV

https://docs.opencv.org/trunk/d7/d9f/tutorial_linux_install.html

once you have everything installed you can proceed to the compilationas described bellow

g++ -I/usr/include/opencv -I/usr/include/opencv2 -L/usr/local/lib/ -g -o bluromp blur-openmp.cpp -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_ml -lopencv_video -lopencv_features2d -lopencv_calib3d -lopencv_objdetect -lopencv_contrib -lopencv_legacy -lopencv_stitching -fopenmp --std=c++11   

g++ el compiler to use
bluromp executable name 
blur-openmp.cpp program to make the blur effect
-fopenmp command to use openmp libraries
--std=c++11 command to use the last version of c++

Execute the application

./bluromp mario720.jpg 3 2 1

bluromp executable name
mario720.jpg image name (inside img folder)
3 kernel size
2 number of threads
1 variable to change to test mode (if it is equal to 0 the output image will be displayed, in other case only performance data will be displayed)

performance data looks like the example bellow

1280x720	2	5	475,708 ms

1280x720 image size
2 number of threads
5 kernel size
475,708 ms execution time

To evaluate the overall performance you just have to execute the script_ejecutar_todo.sh file, using the command

sh ./script_ejecutar_todo.sh

Once it finishes in the timeopenmp.txt file a list with the performance for diferent images, number of threads and kernel sizes will be generated.
