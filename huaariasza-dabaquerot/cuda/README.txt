Blur-effect application

Before start you need to install OpenCV

https://docs.opencv.org/trunk/d7/d9f/tutorial_linux_install.html

and cuda

http://www.nvidia.es/object/cuda-parallel-computing-es.html

once you have everything installed you can proceed to the compilation as described bellow

make

Inside the folder there is a makefile with the compilation of the program, take into account that this program depends on the cuda instalation where you have to set the operative system and GPU architecture so the compilation may not work on other computer, to config your pc do the following:

1 Go to the installation folder of cuda, copy a makefile from one of the examples and replace the one that is inside of the folder cuda of the project.

2 set the installation path of cuda (CUDA_PATH), this variable have to be and absolute path, like the example bellow:

CUDA_PATH ?= /usr/local/cuda-9.0

3 Replace the compilation segment:

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

the compilation segment must indicate the output files and the libraries to import. 

blur-cuda executable name 
blur-cuda.cu program to make the blur effect
--std=c++11 command to use the last version of c++

Execute the application

./blur-cuda mario720.jpg 3 256 1 1

blur-cuda executable name
mario720.jpg image name (inside img folder)
3 kernel size
256 number of threads
1 number of blocks of the GPU
1 variable to change to test mode (if it is equal to 0 the output image will be displayed, in other case only performance data will be displayed)

performance data looks like the example bellow

1280x720	256	1	3	5766.91 ms

1280x720 image size
256 number of threads
1 number of blocks
3 kernel size
5766.91 ms execution time

To evaluate the overall performance you just have to execute the script_ejecutar_todo.sh file, using the command

sh ./script_ejecutar_todo.sh

Once it finishes in the timecuda.txt file a list with the performance for diferent images, number of threads, number of blocks and kernel sizes will be generated.
