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

template <typename T>
string Str(const T & t)
{
	ostringstream os;
	os << t;
	return os.str();
}

struct Block
{
   int block_id;
   Mat block_image;
};

/*   calcula el promedio del kernel en el pixel (x,y)  */
Vec3d getKernel(Mat original, int kernel, int x, int y)
{
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

   cv::Rect rect = cv::Rect(startY, startX, endY - startY, endX - startX);

   // kernelMat copia de la sección del tamaño del kernel de la imagen original
   Mat kernelMat = cv::Mat(original, rect);

   double averageR = 0;
   double averageG = 0;
   double averageB = 0;

   for(int k = 0; k < kernelMat.rows; k++)
   {
      for(int k2 = 0; k2 < kernelMat.cols; k2++)
      {
         averageR = averageR + (double) kernelMat.at<Vec3b>(k, k2)[0];
         averageG = averageG + (double) kernelMat.at<Vec3b>(k, k2)[1];
         averageB = averageB + (double) kernelMat.at<Vec3b>(k, k2)[2];
      }
   }
   double total = kernelMat.cols * kernelMat.rows;
   return Vec3d(averageR/total, averageG/total, averageB/total);
}


/*   calcula la matriz con el efecto blur   */
Mat makeBlur(Mat original, int kernel)
{
   if(kernel % 2 == 0 || kernel < 3)
      return original;

   //inicializo matriz que almacena imagen con efecto de blur con 1's
   Mat mBlur = cv::Mat::ones(original.rows - (kernel - 1), original.cols, CV_64FC3);

   int rows = original.rows - (kernel - 1);
   int cols = original.cols;

   Mat mCopy = original.clone();

   Vec3d pixel;

   for(unsigned i = 0; i < rows; i++)
   {
      for(unsigned j = 0; j < cols; j++)
      {
         pixel = getKernel(original, kernel, i + (kernel - 1) / 2, j);
         mBlur.at<Vec3d>(i,j)[0] = ((Vec3d)pixel)[0]/255;
         mBlur.at<Vec3d>(i,j)[1] = ((Vec3d)pixel)[1]/255;
         mBlur.at<Vec3d>(i,j)[2] = ((Vec3d)pixel)[2]/255;
      }
   }
   return mBlur;
}

int main(int argc, char** argv)
{
	int isTesting = 0;
	char* image_name = (char *)malloc(sizeof(char) * 256);

	// Tamaño de kernel, número de bloques en que se divide la imagen, nombre de la imagen
	sscanf( argv[1], "%s", image_name );
	sscanf( argv[2], "%i", &kernel_size );
	sscanf( argv[3], "%i", &blocks );
	sscanf( argv[4], "%i", &isTesting);

	Mat input = imread(Str("img/") + image_name, 1);
	if (input.empty())
	{
		cout << "error: image not read from file\n\n";
		return(0);
	}

	free(image_name);

	int blockheigth = 0;

	int rows = input.rows;
	int cols = input.cols;

	vector < Mat > blockImages;
	if(blocks == 1)
	{
		blockImages.push_back(input);
	}
	else
	{
		for (int i = 0; i < input.rows; i = i + input.rows / blocks)
		{
			if (i + input.rows / blocks >= input.rows)
				blockheigth = input.rows - i;
			else
				blockheigth = ceil(input.rows / blocks);

			if(i > 0)
				i = i - (kernel_size - 1) / 2;

			cv::Rect rect = cv::Rect(0, i, input.cols, blockheigth + (kernel_size - 1) / 2);
			blockImages.push_back(cv::Mat(input, rect));
		}
	}

	int start_s = clock();

	omp_set_dynamic(0);
	omp_set_num_threads(blocks);

	vector <Block> bluredImages;
	std::vector<Block>::iterator it;
	int id = 0;
	it = bluredImages.begin();
	struct Block returnBlocks[blockImages.size()];
	#pragma omp parallel
	{
		#pragma omp for
		for(unsigned i = 0; i < blockImages.size(); i++)
		{
			returnBlocks[i].block_id = i;
			returnBlocks[i].block_image = makeBlur(blockImages.at(i), kernel_size);
			bluredImages.push_back(returnBlocks[i]);
		}
	}

	//imagen con el efecto terminado
	Mat Final;
	vector <Mat> bluredResult;
	for(int i = 0; i < blockImages.size(); i++)
	{
		bluredResult.push_back(returnBlocks[i].block_image);
	}

	int stop_s = clock();

	for(unsigned i = 0; i < bluredResult.size(); i++)
	{
		if (bluredResult.at(i).empty())
			continue;

		if(i == 1)
			vconcat(bluredResult.at(i-1), bluredResult.at(i), Final);
		else if(i > 1)
			vconcat(Final, bluredResult.at(i), Final);
	}

	if(isTesting == 0)
	{
		namedWindow("Input", CV_WINDOW_NORMAL);
		namedWindow("Output", CV_WINDOW_NORMAL);
		cv::imshow("Input", input);
		
		if(!Final.empty())
			imshow("Output", Final);
		else
			imshow("Output", bluredResult.at(0));

		cv::waitKey();
	}

	cout << cols << "x";
	cout << rows << "\t";
	cout << blocks << "\t";
	cout << kernel_size << "\t";
	cout << (stop_s-start_s)/double(CLOCKS_PER_SEC)*1000 << " ms" << endl;
	return 0;
}
