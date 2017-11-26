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

//function to convert to string 
template <typename T>
string Str(const T & t)
{
	ostringstream os;
	os << t;
	return os.str();
}

/*   function to safely manage error un cuda memory allocation   */
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


/*   function to compute blur   */
__global__ void blur_img_kernel(short int* dRed, short int* dGreen, short int* dBlue, bool* dEdited, int cols, int rows, int kernel, int blockSize)
{
	//Thread index	
	const int xIndex = blockIdx.x * blockDim.x + threadIdx.x;

	//variables to allocate the edges of the working thread
	int startBlockX = xIndex * blockSize;
	int endBlockX = (xIndex + 1) * blockSize;
	
	//variables to allocate the edges of the kernel
	int startX = 0;
	int startY = 0;
	int endX = cols;
	int endY = rows;

	//Index to modify	
	int vectIndex = 0;

	//variable to iterate over the kernel indexes
	int subindex = 0;

	//variables to compute pixel sum inside the kernel (Red, Green, Blue)
	double averageR = 0;
	double averageG = 0;
	double averageB = 0;

	//cumpute the total of pixels (technically kernel²)
	double total = 0; 

	//handling error on overflow because of the last block exceeds number of cols	
	if(endBlockX > cols)
		endBlockX = cols;

	//iterate over the block of the working thread
	for(int i = startBlockX; i < endBlockX; i++)
	{
		for(int j = 0; j < rows; j++)
		{
			total = 0;				
			subindex = 0;
			vectIndex = i + (j * cols);

			averageR = 0;
			averageG = 0;
			averageB = 0;

			if(dEdited[vectIndex] == true) continue; //control if the pixel was modified by another thread

			//Region compute kernel edges

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
			
			//End Region

			//if kernel is equal to 1 return the pixel as it is
			if(kernel == 1)
			{
				averageR = dRed[vectIndex];
				averageG = dGreen[vectIndex];
				averageB = dBlue[vectIndex];
				total = 1;
			}

			//iterate over the kernel computing pixel RGB sums and total of pixels
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

			//assign average value per channel of color (RGB)
			dRed[vectIndex] = (short int)(averageR / total);
			dGreen[vectIndex] = (short int)(averageG / total);
			dBlue[vectIndex] = (short int)(averageB / total);
			
			//flag to check the current pixel as modified
			dEdited[vectIndex] = true;
		}
	}
}

/*   function to allocate memory, call cuda blur fuction and apply to output the blur effect   */
void make_blur(const cv::Mat& input, cv::Mat& output)
{
	//input variables	
	int rows = input.rows;
	int cols = input.cols;
	int kernel = kernel_size;

	//size of the image (number of pixels
	int imgSize = input.rows * input.cols;

	//number of parallel tasks
	int indexes = blocks_per_grid * threads;

	//size of the block taken of the image per task
	int blockSize = ceil((double)cols / (double)indexes);

	//variables to store RGB pixels in host memory
	short int *h_red = new short int[imgSize];
	short int *h_green = new short int[imgSize];
	short int *h_blue = new short int[imgSize];

	//variables to store RGB pixels in device memory
     	short int *d_red, *d_green, *d_blue;

	//variable to know if a pixel was modified in host memory
	bool *h_edited = new bool[imgSize];

	//variable to know if a pixel was modified in device memory
	bool *d_edited;

	Mat inputCopy = input.clone();

	//size of a pixel color array
	int colorSize = sizeof(short int) * imgSize; 

	//size of a boolean array of the image
	int editedSize = sizeof(bool) * imgSize;

	//iterate over the image pixel to initialize the data of host memory
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
     
	//Region allocate host memory data in device memory

	SAFE_CALL(cudaMalloc<short int>(&d_red, colorSize), "CUDA Malloc Failed");
	SAFE_CALL(cudaMalloc<short int>(&d_green, colorSize), "CUDA Malloc Failed");
	SAFE_CALL(cudaMalloc<short int>(&d_blue, colorSize), "CUDA Malloc Failed");
	SAFE_CALL(cudaMalloc<bool>(&d_edited, editedSize), "CUDA Malloc Failed");

	//End Region

	//Region copy data from OpenCV input image to device memory

	SAFE_CALL(cudaMemcpy(d_red, h_red, colorSize, cudaMemcpyHostToDevice), "CUDA Memcpy Host To Device Failed");	
	SAFE_CALL(cudaMemcpy(d_green, h_green, colorSize, cudaMemcpyHostToDevice), "CUDA Memcpy Host To Device Failed");
	SAFE_CALL(cudaMemcpy(d_blue, h_blue, colorSize, cudaMemcpyHostToDevice), "CUDA Memcpy Host To Device Failed");
	SAFE_CALL(cudaMemcpy(d_edited, h_edited, editedSize, cudaMemcpyHostToDevice), "CUDA Memcpy Host To Device Failed");

	//End Region

	int threads_per_block = threads / blocks_per_grid;

	//launch the blur conversion kernel
	blur_img_kernel<<<blocks_per_grid, threads_per_block>>>(d_red, d_green, d_blue, d_edited, cols, rows, kernel, blockSize);

	//synchronize tu check errors in any kernel
	SAFE_CALL(cudaDeviceSynchronize(), "Kernel Launch Failed");

	//Region retrieve memory from device to host

	SAFE_CALL(cudaMemcpy(h_red, d_red, colorSize, cudaMemcpyDeviceToHost), "CUDA Memcpy Host To Device Failed");
	SAFE_CALL(cudaMemcpy(h_green, d_green, colorSize, cudaMemcpyDeviceToHost), "CUDA Memcpy Host To Device Failed");
	SAFE_CALL(cudaMemcpy(h_blue, d_blue, colorSize, cudaMemcpyDeviceToHost), "CUDA Memcpy Host To Device Failed");

	//End Region

	//Region free the device memory

	SAFE_CALL(cudaFree(d_red), "CUDA Free Failed");
	SAFE_CALL(cudaFree(d_green), "CUDA Free Failed");
	SAFE_CALL(cudaFree(d_blue), "CUDA Free Failed");
	SAFE_CALL(cudaFree(d_edited), "CUDA Free Failed");

	//End Region

	//Region create output image

	Vec3d outVect;
	int index2 = 0;

	//iterate over image size to assign pixel color results in output
    	for(int io = 0; io < cols; io++)
	{
		for(int jo = 0; jo < rows; jo++)
		{
			index2 = io + (jo * cols);
			outVect = Vec3d((double)h_red[index2]/255.0, (double)h_green[index2]/255.0, (double)h_blue[index2]/255.0);
			output.at<Vec3d>(Point(io, jo)) = outVect;
		}
	}

	//End Region

	//Region free host memory
	
	free(h_red);
	free(h_green);
	free(h_blue);
	free(h_edited);

	//End Region
}

int main(int argc, char** argv)
{
	//if there was an error with the input parameters
	if(argc != 5)
	{
		cout << "Missing or incorrect input parameters" << endl;
		cout << "Params:" << endl;
		cout << "1. image name: example mario.jpg" << endl;
		cout << "2. kernel: size odd number example: 17" << endl;
		cout << "3. threads: number of gpu threads that will be used example: 192";
		cout << "4. block2: number of gpu blocks that will be used example: 2";
		cout << "5. is testing: 0 to display images 1 to enable testing mode";
		return 0;
	}

	//variable to store input image name
	char* image_name = (char *)malloc(sizeof(char) * 256);

	//flag to set testing mode(not display image)
	int isTesting = 0;

	//Region capture input params

	sscanf(argv[1], "%s", image_name);
	sscanf(argv[2], "%i", &kernel_size);
	sscanf(argv[3], "%i", &threads);	
	sscanf(argv[4], "%i", &blocks_per_grid);
	sscanf(argv[5], "%i", &isTesting);

	//End Region

	//variable to store start time
	int start_s = clock();

	//Region reading input image in img folder

	Mat input = imread(Str("img/") + image_name, 1);
	if (input.empty())
	{
		cout << "error: image not read from file\n\n";
		return(0);
	}

	//End Region

	//validate that kernel is odd
	if (kernel_size % 2 == 0)
	{
		cout << "error: arg 2 kernel size must be odd\n\n";
		return(0);
	}

	//validate that number of threads is divisible on the number of blocks
	if (threads % blocks_per_grid != 0)
	{
		cout << Str(threads % blocks_per_grid) + " error: args 3 and 4 number of threads(3) must be divisible in blocks per grid(4)\n\n";
		return(0);
	}

	//width and height of the image
	int rows = input.rows;
	int cols = input.cols;

	//create Mat for output image
	cv::Mat output(rows, cols, CV_64FC3);

	//launch function to apply blur
	make_blur(input, output);

	//if testing mode is disabled then show images
	if(isTesting == 0)
	{
		namedWindow("Input", CV_WINDOW_NORMAL);
		namedWindow("Output", CV_WINDOW_NORMAL);
		cv::imshow("Input", input);
		cv::imshow("Output",output);
		cv::waitKey();
	}

	//variable to store end time
	int stop_s = clock();

	//free images memory
	input.release();
	output.release();
	
	//print performance information
	cout << cols << "x";
	cout << rows << "\t";
	cout << threads << "\t";
	cout << blocks_per_grid << "\t";
	cout << kernel_size << "\t";
    	cout << (stop_s-start_s)/double(CLOCKS_PER_SEC)*1000 << " ms" << endl;

	return 0;
}
