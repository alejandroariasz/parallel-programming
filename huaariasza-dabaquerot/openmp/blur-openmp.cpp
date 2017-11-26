#include <omp.h>
#include <cv.h>
#include <cxcore.h>
#include <highgui.h>

#include <ctime>
#include <cstdlib>
#include <iostream>
#include <fstream>

using namespace cv;
using namespace std;

int kernel_size;
int blocks;

//function to convert to string 
template <typename T>
string Str(const T & t)
{
	ostringstream os;
	os << t;
	return os.str();
}

//struct to store partitions blocks been aware of the threadId (id, image)
struct Block
{
	int block_id;
	Mat block_image;
};

/*   compute average on a pixel (x,y) according to the kernel   */
Vec3d getKernel(Mat original, int kernel, int x, int y)
{

	//Region compute kernel edges

   	int startX = 0;
   	if(x - (kernel - 1) / 2  > 0)
      		startX = x - (kernel - 1) / 2;

	int startY = 0;
	if(y - (kernel - 1) / 2  > 0)
		startY = y - (kernel - 1) / 2;

	int endX = original.rows;
	if(x + (kernel - 1) / 2  < original.rows)
		endX = x + (kernel - 1) / 2;

	int endY = original.cols;
	if(y + (kernel - 1) / 2  < original.cols)
		endY = y + (kernel - 1) / 2;

	//End Region

	//new rect of the kernel size
   	cv::Rect rect = cv::Rect(startY, startX, endY - startY, endX - startX);

	// kernelMat select a portion of the original image with the size of the kernel
	Mat kernelMat = cv::Mat(original, rect);

	//variables to compute pixel sum inside the kernel (Red, Green, Blue)
	double sumR = 0;
	double sumG = 0;
	double sumB = 0;

	//iterate over the kernel computing pixel RGB sums
	for(int k = 0; k < kernelMat.rows; k++)
	{
		for(int k2 = 0; k2 < kernelMat.cols; k2++)
		{
			sumR = sumR + (double) kernelMat.at<Vec3b>(k, k2)[0];
			sumG = sumG + (double) kernelMat.at<Vec3b>(k, k2)[1];
			sumB = sumB + (double) kernelMat.at<Vec3b>(k, k2)[2];
		}
	}

	//total of pixels in the kernel	
	double total = kernelMat.cols * kernelMat.rows;

	//return a vect (RGB pixel) with the average computed (blur)
	return Vec3d(sumR/total, sumG/total, sumB/total);
}


/*   returns a Mat with the blur effect applied   */
Mat makeBlur(Mat original, int kernel)
{
	//validate that kernel is odd and greater then 1
	if(kernel % 2 == 0 || kernel < 3)
		return original;

	//Mat to store blur result initialized with ones
	Mat mBlur = cv::Mat::ones(original.rows - (kernel - 1), original.cols, CV_64FC3);

	//edge values on rows in order to correct edges problems the partitioned image has one aditional kernel 
	int rows = original.rows - (kernel - 1);
	int cols = original.cols;

	Mat mCopy = original.clone();

	Vec3d pixel;

	//iterate over image size to assign pixel color results in mBlur
	for(unsigned i = 0; i < rows; i++)
	{
		for(unsigned j = 0; j < cols; j++)
		{
			//function to compute blur on a pixel 
			pixel = getKernel(original, kernel, i + (kernel - 1) / 2, j);
			//assing any channel color (RGB) to mBlur
			mBlur.at<Vec3d>(i,j)[0] = ((Vec3d)pixel)[0]/255;
			mBlur.at<Vec3d>(i,j)[1] = ((Vec3d)pixel)[1]/255;
			mBlur.at<Vec3d>(i,j)[2] = ((Vec3d)pixel)[2]/255;
		}
	}
   	return mBlur;
}

int main(int argc, char** argv)
{
	//if there was an error with the input parameters
	if(argc != 4)
	{
		cout << "Missing or incorrect input parameters" << endl;
		cout << "Params:" << endl;
		cout << "1. image name example: mario.jpg" << endl;
		cout << "2. kernel size odd number example: 17" << endl;
		cout << "3. threads number of openmp threads that will be used example: 8";
		cout << "4. is testing 0 to display images 1 to enable testing mode";
		return 0;
	}

	//flag to set testing mode(not display image)
	int isTesting = 0;

	//variable to store input image name
	char* image_name = (char *)malloc(sizeof(char) * 256);

	//Region capture input params

	sscanf( argv[1], "%s", image_name );
	sscanf( argv[2], "%i", &kernel_size );
	sscanf( argv[3], "%i", &blocks );
	sscanf( argv[4], "%i", &isTesting);

	//End Region

	//Region reading input image in img folder

	Mat input = imread(Str("img/") + image_name, 1);
	if (input.empty())
	{
		cout << "error: image not read from file\n\n";
		return(0);
	}

	//End Region

	//free image name
	free(image_name);

	//variable to compute the height of each partitioned block	
	int blockheigth = 0;

	//width and height of the image
	int rows = input.rows;
	int cols = input.cols;

	//vector to store the partitioned blocks of the image
	vector < Mat > blockImages;

	//if blocks is equal to 1 add the whole image (1 thread)
	if(blocks == 1)
	{
		blockImages.push_back(input);
	}
	else
	{
		//variable to add half of the kernel in each side of the block
		int kernelDiff = (kernel_size - 1) / 2;
		
		//variables to store edges of the block adding half of the kernel in each side
		int startRect = 0;
		int endREct = 0;

		//iterate over the image incrementing by the size of each block
		for (int i = 0; i < input.rows; i = i + input.rows / blocks)
		{
			//compute blockheight controlling values grater than the number of rows
			if (i + input.rows / blocks >= input.rows)
				blockheigth = input.rows - i;
			else
				blockheigth = ceil(input.rows / blocks);

			//if block is not at the beggining add half of the kernel
			if(i > 0) startRect = i - kernelDiff;

			//if block is not at the end add half of the kernel
			if(i + input.rows / blocks < input.rows) 
				endRect = blockheigth + kernelDiff;
			else
				endRect = input.rows;

			//new rect of the block + kernel size
			cv::Rect rect = cv::Rect(0, startRect, input.cols, endRect);
			
			//add block to block images
			blockImages.push_back(cv::Mat(input, rect));
		}
	}

	//variable to store start time
	int start_s = clock();

	//set num of threads and force to work with them
	omp_set_dynamic(0);
	omp_set_num_threads(blocks);

	//vector to store block of the original image once the blur is applied
	vector <Block> bluredImages;

	//array of struct block to store blured images and ids 
	struct Block returnBlocks[blockImages.size()];

	//parallel region
	#pragma omp parallel
	{
		//iterate to compute blur on each block
		#pragma omp for
		for(unsigned i = 0; i < blockImages.size(); i++)
		{
			//assign block id
			returnBlocks[i].block_id = i;
			//assign blur block (function to apply blur)
			returnBlocks[i].block_image = makeBlur(blockImages.at(i), kernel_size);
			//add block with blur effect 
			bluredImages.push_back(returnBlocks[i]);
		}
	}

	//mat to store the final result
	Mat Final;

	//vector to store the generated blocks
	vector <Mat> bluredResult;

	//iterate to store blocks on the vector in order
	for(int i = 0; i < blockImages.size(); i++)
	{
		bluredResult.push_back(returnBlocks[i].block_image);
	}

	//variable to store end time
	int stop_s = clock();

	//iterate in order to concatenate block in final
	for(unsigned i = 0; i < bluredResult.size(); i++)
	{
		if (bluredResult.at(i).empty()) continue;

		//concatenate blocks in final (two block are needed)
		if(i == 1)
			vconcat(bluredResult.at(i-1), bluredResult.at(i), Final);
		else if(i > 1)
			vconcat(Final, bluredResult.at(i), Final);
	}

	//if testing mode is disabled then show images
	if(isTesting == 0)
	{
		namedWindow("Input", CV_WINDOW_NORMAL);
		namedWindow("Output", CV_WINDOW_NORMAL);
		cv::imshow("Input", input);

		//if there was only one block it wasn't necessary the concatenation iteration so final is empty 		
		if(!Final.empty())
			imshow("Output", Final);
		else
			imshow("Output", bluredResult.at(0));

		cv::waitKey();
	}

	//free image memory
	input.release();

	//print performance information
	cout << cols << "x";
	cout << rows << "\t";
	cout << blocks << "\t";
	cout << kernel_size << "\t";
	cout << (stop_s-start_s)/double(CLOCKS_PER_SEC)*1000 << " ms" << endl;

	return 0;
}
