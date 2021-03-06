#!bin/bash
g++ -g -o header header.cpp 
wait
g++ -I/usr/include/opencv -I/usr/include/opencv2 -L/usr/local/lib/ -g -o bluromp blur-openmp.cpp -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_ml -lopencv_video -lopencv_features2d -lopencv_calib3d -lopencv_objdetect -lopencv_contrib -lopencv_legacy -lopencv_stitching -fopenmp --std=c++11 
wait
./header > timeomp.txt 
wait

#720p image

./bluromp mario720.jpg 3 1 1 >> timeomp.txt 
wait
./bluromp mario720.jpg 5 1 1 >> timeomp.txt 
wait
./bluromp mario720.jpg 9 1 1 >> timeomp.txt 
wait
./bluromp mario720.jpg 13 1 1 >> timeomp.txt 
wait
./bluromp mario720.jpg 15 1 1 >> timeomp.txt 
wait

./bluromp mario720.jpg 3 2 1 >> timeomp.txt
wait
./bluromp mario720.jpg 5 2 1 >> timeomp.txt
wait
./bluromp mario720.jpg 9 2 1 >> timeomp.txt
wait
./bluromp mario720.jpg 13 2 1 >> timeomp.txt
wait
./bluromp mario720.jpg 15 2 1 >> timeomp.txt
wait

./bluromp mario720.jpg 3 4 1 >> timeomp.txt
wait
./bluromp mario720.jpg 5 4 1 >> timeomp.txt
wait
./bluromp mario720.jpg 9 4 1 >> timeomp.txt
wait
./bluromp mario720.jpg 13 4 1 >> timeomp.txt
wait
./bluromp mario720.jpg 15 4 1 >> timeomp.txt
wait

./bluromp mario720.jpg 3 8 1 >> timeomp.txt
wait
./bluromp mario720.jpg 5 8 1 >> timeomp.txt
wait
./bluromp mario720.jpg 9 8 1 >> timeomp.txt
wait
./bluromp mario720.jpg 13 8 1 >> timeomp.txt
wait
./bluromp mario720.jpg 15 8 1 >> timeomp.txt
wait

./bluromp mario720.jpg 3 16 1 >> timeomp.txt
wait
./bluromp mario720.jpg 5 16 1 >> timeomp.txt
wait
./bluromp mario720.jpg 9 16 1 >> timeomp.txt
wait
./bluromp mario720.jpg 13 16 1 >> timeomp.txt
wait
./bluromp mario720.jpg 15 16 1 >> timeomp.txt
wait


#1080p image

./bluromp mario.jpg 3 1 1 >> timeomp.txt
wait
./bluromp mario.jpg 5 1 1 >> timeomp.txt
wait
./bluromp mario.jpg 9 1 1 >> timeomp.txt
wait
./bluromp mario.jpg 13 1 1 >> timeomp.txt
wait
./bluromp mario.jpg 15 1 1 >> timeomp.txt
wait

./bluromp mario.jpg 3 2 1 >> timeomp.txt
wait
./bluromp mario.jpg 5 2 1 >> timeomp.txt
wait
./bluromp mario.jpg 9 2 1 >> timeomp.txt
wait
./bluromp mario.jpg 13 2 1 >> timeomp.txt
wait
./bluromp mario.jpg 15 2 1 >> timeomp.txt
wait

./bluromp mario.jpg 3 4 1 >> timeomp.txt
wait
./bluromp mario.jpg 5 4 1 >> timeomp.txt
wait
./bluromp mario.jpg 9 4 1 >> timeomp.txt
wait
./bluromp mario.jpg 13 4 1 >> timeomp.txt
wait
./bluromp mario.jpg 15 4 1 >> timeomp.txt
wait

./bluromp mario.jpg 3 8 1 >> timeomp.txt
wait
./bluromp mario.jpg 5 8 1 >> timeomp.txt
wait
./bluromp mario.jpg 9 8 1 >> timeomp.txt
wait
./bluromp mario.jpg 13 8 1 >> timeomp.txt
wait
./bluromp mario.jpg 15 8 1 >> timeomp.txt
wait

./bluromp mario.jpg 3 16 1 >> timeomp.txt
wait
./bluromp mario.jpg 5 16 1 >> timeomp.txt
wait
./bluromp mario.jpg 9 16 1 >> timeomp.txt
wait
./bluromp mario.jpg 13 16 1 >> timeomp.txt
wait
./bluromp mario.jpg 15 16 1 >> timeomp.txt
wait


#4k image

./bluromp mario4k.jpg 3 1 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 5 1 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 9 1 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 13 1 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 15 1 1 >> timeomp.txt
wait

./bluromp mario4k.jpg 3 2 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 5 2 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 9 2 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 13 2 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 15 2 1 >> timeomp.txt
wait

./bluromp mario4k.jpg 3 4 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 5 4 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 9 4 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 13 4 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 15 4 1 >> timeomp.txt
wait

./bluromp mario4k.jpg 3 8 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 5 8 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 9 8 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 13 8 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 15 8 1 >> timeomp.txt
wait

./bluromp mario4k.jpg 3 16 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 5 16 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 9 16 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 13 16 1 >> timeomp.txt
wait
./bluromp mario4k.jpg 15 16 1 >> timeomp.txt
wait
