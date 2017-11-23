Blur-effect application

Before start you need to install OpenCV

https://docs.opencv.org/trunk/d7/d9f/tutorial_linux_install.html

once you have everything installed you can proceed to the compilationas described bellow

g++ -I/usr/local/include/opencv -I/usr/local/include/opencv2 -L/usr/local/lib/ -g -o blur blur-effect.cpp -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_ml -lopencv_video -lopencv_features2d -lopencv_calib3d -lopencv_objdetect -lopencv_contrib -lopencv_legacy -lopencv_stitching -lpthread --std=c++11 

g++ el compiler to use
blur executable name 
blur-effect.cpp program to make the blur effect
--std=c++11 command to use the last version of c++

Execute the application

./blur mario720.jpg 3 2 1

blur executable name
mario720.jpg image name (inside img folder)
3 kernel size
2 number of threads
1 variable to change to test mode (if it is equal to 0 the output image will be displayed, in other case only performance data will be displayed)

performance data looks like the example bellow

1280x720	2	5	475,708 ms	462,855 ms

1280x720 image size
2 number of threads
5 kernel size
475,708 ms execution time
462,855 ms execution time without taking into account partitioning time

To evaluate the overall performance you just have to execute the script_ejecutar_todo.sh file, using the command

sh ./script_ejecutar_todo.sh

Once it finishes in the timeposix.txt file a list with the performance for diferent images, number of threads and kernel sizes will be generated.
