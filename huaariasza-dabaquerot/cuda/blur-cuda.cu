#include <stdio.h>
#include <math.h>
// For the CUDA runtime routines (prefixed with "cuda_")
#include <cuda_runtime.h>

#include <cv.h>
#include <cxcore.h>
#include <highgui.h>

#include <ctime>
#include <cstdlib>
#include <iostream>

using namespace cv;
using namespace std;

int threads;
int kernel_size;
int indexes_count;
int blocks_per_grid;

template <typename T>
string Str(const T & t)
{
	ostringstream os;
	os << t;
	return os.str();
}


static inline void _safe_cuda_call(cudaError err, const char* msg, const char* file_name, const int line_number)
{
	if(err != cudaSuccess)
	{
		fprintf(stderr,"%s\n\nFile: %s\n\nLine Number: %d\n\nReason: %s\n", msg,file_name, line_number, cudaGetErrorString(err));
		std::cin.get();
		exit(EXIT_FAILURE);
	}
}

#define SAFE_CALL(call,msg) _safe_cuda_call((call),(msg),__FILE__,__LINE__)

__global__ void blur_img_kernel(short int* dRed, short int* dGreen, short int* dBlue, bool* dEdited, int cols, int rows, int kernel, int blockSize)
{	
	const int xIndex = blockIdx.x * blockDim.x + threadIdx.x;
	
	int startX = 0;
	int startY = 0;
	int endX = cols;
	int endY = rows;

	double total = 0;				
	int subindex = 0;
	int vectIndex = 0;

	double averageR = 0;
	double averageG = 0;
	double averageB = 0;

	int startBlockX = xIndex * blockSize;
	int endBlockX = (xIndex + 1) * blockSize;

	if(endBlockX > cols)
		endBlockX = cols;

	for(int i = startBlockX; i < endBlockX; i++)
	{
		if(i >= cols) continue;

		for(int j = 0; j < rows; j++)
		{
			total = 0;				
			subindex = 0;
			vectIndex = i + (j * cols);

			averageR = 0;
			averageG = 0;
			averageB = 0;

			if(dEdited[vectIndex] == true) continue;

			startX = 0;
			if(i - (kernel - 1) / 2  > 0)
				startX = i - (kernel - 1) / 2;

			startY = 0;
			if(j - (kernel - 1) / 2  > 0)
				startY = j - (kernel - 1) / 2;

			endX = cols;
			if(i + (kernel - 1) / 2  < cols)
				endX = i + (kernel - 1) / 2;

			endY = rows;
			if(j + (kernel - 1) / 2  < rows)
				endY = j + (kernel - 1) / 2;

			if(kernel == 1)
			{
				averageR = dRed[vectIndex];
				averageG = dGreen[vectIndex];
				averageB = dBlue[vectIndex];
				total = 1;
			}

			for(int k = startX; k <= endX; k++)
			{
				for(int k2 = startY; k2 <= endY; k2++)
				{
				    	subindex = k + (k2 * cols);
					averageR = averageR + (double)dRed[subindex];
			    		averageG = averageG + (double)dGreen[subindex];
			    		averageB = averageB + (double)dBlue[subindex];
					total = total + 1;
				}
			}

			dRed[vectIndex] = (short int)(averageR / total);
			dGreen[vectIndex] = (short int)(averageG / total);
			dBlue[vectIndex] = (short int)(averageB / total);
			dEdited[vectIndex] = true;
		}
	}
}


void make_blur(const cv::Mat& input, cv::Mat& output)
{	
	int rows = input.rows;
	int cols = input.cols;
	int kernel = kernel_size;
	int imgSize = input.rows * input.cols;
	int indexes = blocks_per_grid * threads;
	int blockSize = ceil((double)cols / (double)indexes);


	short int *h_red = new short int[imgSize];
	short int *h_green = new short int[imgSize];
	short int *h_blue = new short int[imgSize];

     	short int *d_red, *d_green, *d_blue;

	bool *h_edited = new bool[imgSize];

	bool *d_edited;

	Mat inputCopy = input.clone();

	int colorSize = sizeof(short int) * imgSize; 
	int editedSize = sizeof(bool) * imgSize;

	int index = 0;
	for(int i = 0; i < cols; i++)
    	{		
        	for(int j = 0; j < rows; j++)
        	{
			index = i + (j * cols);
			Vec3b vect = inputCopy.at<Vec3b>(Point(i, j));
		    	h_red[index] = (short int)vect[0];
		    	h_green[index] = (short int)vect[1];
		        h_blue[index] = (short int)vect[2];
			h_edited[index] = false;
        	}
    	}

	inputCopy.release();
     
	SAFE_CALL(cudaMalloc<short int>(&d_red, colorSize), "CUDA Malloc Failed");
	SAFE_CALL(cudaMalloc<short int>(&d_green, colorSize), "CUDA Malloc Failed");
	SAFE_CALL(cudaMalloc<short int>(&d_blue, colorSize), "CUDA Malloc Failed");
	SAFE_CALL(cudaMalloc<bool>(&d_edited, editedSize), "CUDA Malloc Failed");

	//Copy data from OpenCV input image to device memory
	SAFE_CALL(cudaMemcpy(d_red, h_red, colorSize, cudaMemcpyHostToDevice), "CUDA Memcpy Host To Device Failed");	
	SAFE_CALL(cudaMemcpy(d_green, h_green, colorSize, cudaMemcpyHostToDevice), "CUDA Memcpy Host To Device Failed");
	SAFE_CALL(cudaMemcpy(d_blue, h_blue, colorSize, cudaMemcpyHostToDevice), "CUDA Memcpy Host To Device Failed");
	SAFE_CALL(cudaMemcpy(d_edited, h_edited, editedSize, cudaMemcpyHostToDevice), "CUDA Memcpy Host To Device Failed");

	//Launch the blur conversion kernel
	blur_img_kernel<<<blocks_per_grid, threads>>>(d_red, d_green, d_blue, d_edited, cols, rows, kernel, blockSize);

	//Synchronize to check for any kernel launch errors
	SAFE_CALL(cudaDeviceSynchronize(), "Kernel Launch Failed");

	//Copy back data from destination device meory to OpenCV output image
	SAFE_CALL(cudaMemcpy(h_red, d_red, colorSize, cudaMemcpyDeviceToHost), "CUDA Memcpy Host To Device Failed");
	SAFE_CALL(cudaMemcpy(h_green, d_green, colorSize, cudaMemcpyDeviceToHost), "CUDA Memcpy Host To Device Failed");
	SAFE_CALL(cudaMemcpy(h_blue, d_blue, colorSize, cudaMemcpyDeviceToHost), "CUDA Memcpy Host To Device Failed");

	//Free the device memory
	SAFE_CALL(cudaFree(d_red), "CUDA Free Failed");
	SAFE_CALL(cudaFree(d_green), "CUDA Free Failed");
	SAFE_CALL(cudaFree(d_blue), "CUDA Free Failed");
	SAFE_CALL(cudaFree(d_edited), "CUDA Free Failed");

	Mat outputCopy = output.clone();

	Vec3d outVect;
	int index2 = 0;

    	for(int io = 0; io < cols; io++)
	{
		for(int jo = 0; jo < rows; jo++)
		{
			index2 = io + (jo * cols);
			outVect = Vec3d((double)h_red[index2]/255.0, (double)h_green[index2]/255.0, (double)h_blue[index2]/255.0);
			output.at<Vec3d>(Point(io, jo)) = outVect;
		}
	}

	free(h_red);
	free(h_green);
	free(h_blue);
	free(h_edited);
}

int main(int argc, char** argv)
{
	char* image_name;
	image_name = (char *)malloc(sizeof(char) * 256);

	int isTesting = 0;

	sscanf(argv[1], "%s", image_name);
	sscanf(argv[2], "%i", &kernel_size);
	sscanf(argv[3], "%i", &threads);	
	sscanf(argv[4], "%i", &blocks_per_grid);
	sscanf(argv[5], "%i", &isTesting);

	int start_s = clock();

	Mat input = imread(Str("img/") + image_name, 1);
	if (input.empty())
	{
		cout << "error: image not read from file\n\n";
		return(0);
	}

	if (kernel_size % 2 == 0)
	{
		cout << "error: arg 2 kernel size must be odd\n\n";
		return(0);
	}

	if (threads % blocks_per_grid != 0)
	{
		cout << Str(threads % blocks_per_grid) + " error: args 3 and 4 number of threads(3) must be divisible in blocks per grid(4)\n\n";
		return(0);
	}

	int rows = input.rows;
	int cols = input.cols;

	cv::Mat output(rows, cols, CV_64FC3);
	make_blur(input, output);

	if(isTesting == 0)
	{
		namedWindow("Input", CV_WINDOW_NORMAL);
		namedWindow("Output", CV_WINDOW_NORMAL);
		cv::imshow("Input", input);
		cv::imshow("Output",output);
		cv::waitKey();
	}
	
	int stop_s = clock();

	input.release();
	output.release();
	
	cout << cols << "x";
	cout << rows << "\t";
	cout << threads << "\t";
	cout << blocks_per_grid << "\t";
	cout << kernel_size << "\t";
    	cout << (stop_s-start_s)/double(CLOCKS_PER_SEC)*1000 << " ms" << endl;

	return 0;
}
