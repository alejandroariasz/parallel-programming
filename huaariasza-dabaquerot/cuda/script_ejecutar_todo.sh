#!bin/bash
g++ -g -o header header.cpp 
wait
make
wait
./header > timecuda.txt 
wait

#720p image

./blur-cuda mario720.jpg 3 256 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 5 256 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 13 256 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 15 256 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 41 256 1 1 >> timecuda.txt 
wait

./blur-cuda mario720.jpg 3 512 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 5 512 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 13 512 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 15 512 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 41 512 1 1 >> timecuda.txt 
wait

./blur-cuda mario720.jpg 3 1024 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 5 1024 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 13 1024 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 15 1024 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 41 1024 1 1 >> timecuda.txt 
wait

./blur-cuda mario720.jpg 3 1024 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 5 1024 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 13 1024 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 15 1024 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 41 1024 2 1 >> timecuda.txt 
wait

#1080p image

./blur-cuda mario.jpg 3 256 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 5 256 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 13 256 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 15 256 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 41 256 1 1 >> timecuda.txt 
wait

./blur-cuda mario.jpg 3 512 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 5 512 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 13 512 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 15 512 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 41 512 1 1 >> timecuda.txt 
wait

./blur-cuda mario.jpg 3 1024 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 5 1024 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 13 1024 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 15 1024 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 41 1024 1 1 >> timecuda.txt 
wait

./blur-cuda mario.jpg 3 1024 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 5 1024 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 13 1024 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 15 1024 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 41 1024 2 1 >> timecuda.txt 
wait

#4k image

./blur-cuda mario4k.jpg 3 256 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 5 256 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 13 256 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 15 256 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 41 256 1 1 >> timecuda.txt 
wait

./blur-cuda mario4k.jpg 3 512 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 5 512 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 13 512 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 15 512 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 41 512 1 1 >> timecuda.txt 
wait

./blur-cuda mario4k.jpg 3 1024 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 5 1024 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 13 1024 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 15 1024 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 41 1024 1 1 >> timecuda.txt 
wait

./blur-cuda mario4k.jpg 3 1024 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 5 1024 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 13 1024 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 15 1024 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 41 1024 2 1 >> timecuda.txt 
wait


