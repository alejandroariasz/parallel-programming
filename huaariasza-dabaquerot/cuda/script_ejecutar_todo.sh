#!bin/bash
g++ -g -o header header.cpp 
wait
make
wait
./header > timecuda.txt 
wait

#720p image, 1 block

./blur-cuda mario720.jpg 3 192 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 5 192 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 13 192 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 15 192 1 1 >> timecuda.txt 
wait

./blur-cuda mario720.jpg 3 384 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 5 384 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 13 384 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 15 384 1 1 >> timecuda.txt 
wait

./blur-cuda mario720.jpg 3 768 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 5 768 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 13 768 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 15 768 1 1 >> timecuda.txt 
wait

./blur-cuda mario720.jpg 3 1536 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 5 1536 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 13 1536 1 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 15 1536 1 1 >> timecuda.txt 
wait

#720p image, 2 blocks

./blur-cuda mario720.jpg 3 192 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 5 192 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 13 192 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 15 192 2 1 >> timecuda.txt 
wait

./blur-cuda mario720.jpg 3 384 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 5 384 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 13 384 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 15 384 2 1 >> timecuda.txt 
wait

./blur-cuda mario720.jpg 3 768 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 5 768 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 13 768 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 15 768 2 1 >> timecuda.txt 
wait

./blur-cuda mario720.jpg 3 1536 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 5 1536 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 13 1536 2 1 >> timecuda.txt 
wait
./blur-cuda mario720.jpg 15 1536 2 1 >> timecuda.txt 
wait

#1080p image, 1 block

./blur-cuda mario.jpg 3 192 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 5 192 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 13 192 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 15 192 1 1 >> timecuda.txt 
wait

./blur-cuda mario.jpg 3 384 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 5 384 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 13 384 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 15 384 1 1 >> timecuda.txt 
wait

./blur-cuda mario.jpg 3 768 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 5 768 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 13 768 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 15 768 1 1 >> timecuda.txt 
wait

./blur-cuda mario.jpg 3 1536 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 5 1536 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 13 1536 1 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 15 1536 1 1 >> timecuda.txt 
wait

#1080p image, 2 blocks

./blur-cuda mario.jpg 3 192 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 5 192 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 13 192 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 15 192 2 1 >> timecuda.txt 
wait

./blur-cuda mario.jpg 3 384 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 5 384 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 13 384 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 15 384 2 1 >> timecuda.txt 
wait

./blur-cuda mario.jpg 3 768 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 5 768 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 13 768 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 15 768 2 1 >> timecuda.txt 
wait

./blur-cuda mario.jpg 3 1536 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 5 1536 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 13 1536 2 1 >> timecuda.txt 
wait
./blur-cuda mario.jpg 15 1536 2 1 >> timecuda.txt 
wait

#4k image

./blur-cuda mario4k.jpg 3 192 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 5 192 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 13 192 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 15 192 1 1 >> timecuda.txt 
wait

./blur-cuda mario4k.jpg 3 384 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 5 384 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 13 384 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 15 384 1 1 >> timecuda.txt 
wait

./blur-cuda mario4k.jpg 3 768 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 5 768 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 13 768 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 15 768 1 1 >> timecuda.txt 
wait

./blur-cuda mario4k.jpg 3 1536 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 5 1536 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 13 1536 1 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 15 1536 1 1 >> timecuda.txt 
wait

#4k image, 2 blocks

./blur-cuda mario4k.jpg 3 192 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 5 192 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 13 192 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 15 192 2 1 >> timecuda.txt 
wait

./blur-cuda mario4k.jpg 3 384 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 5 384 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 13 384 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 15 384 2 1 >> timecuda.txt 
wait

./blur-cuda mario4k.jpg 3 768 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 5 768 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 13 768 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 15 768 2 1 >> timecuda.txt 
wait

./blur-cuda mario4k.jpg 3 1536 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 5 1536 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 13 1536 2 1 >> timecuda.txt 
wait
./blur-cuda mario4k.jpg 15 1536 2 1 >> timecuda.txt 
wait


