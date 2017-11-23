#include <cv.h>
#include <cxcore.h>
#include <highgui.h>

#include <ctime>
#include <cstdlib>
#include <iostream>
#include<fstream>

#define NUM_THREADS 100

using namespace cv;
using namespace std;

int kernel_size;
int blocks;

struct Block
{
   int block_id;
   Mat *block_image;
};

template <typename T>
string Str(const T & t)
{
	ostringstream os;
	os << t;
	return os.str();
}

/*
    calcula el promedio del kernel en el pixel (x,y)
*/

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


/*
    calcula la matriz con el efecto blur
*/
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

void *wait(void *block)
{
    struct Block *imageBlock = (Block *)malloc(sizeof(struct Block));
    imageBlock = (struct Block *)block;

    int id = imageBlock -> block_id;
    Mat image = *(new Mat(*(imageBlock -> block_image)));

    //Mat result;
    //blur(image, result, Size(25, 25));

    Mat result = makeBlur(image, kernel_size);

    struct Block *returnBlock = (Block *)malloc(sizeof(struct Block));
    returnBlock = (struct Block *)block;

    returnBlock -> block_id = id;
    returnBlock -> block_image = new Mat(result);

	pthread_exit(returnBlock);
	return(0);
}

int main(int argc, char** argv)
{
    char* image_name;

	// Tamaño de kernel, número de bloques en que se divide la imagen, nombre de la imagen
	sscanf( argv[1], "%s", image_name );
	sscanf( argv[2], "%i", &kernel_size );
	sscanf( argv[3], "%i", &blocks );

    int start_s = clock();
    Mat src = imread(image_name, 1);
	namedWindow("Original Image", CV_WINDOW_AUTOSIZE);
	namedWindow("Blur_Final", CV_WINDOW_AUTOSIZE);

	if (src.empty())
	{
		cout << "error: image not read from file\n\n";
		return(0);
	}

	imshow("Original Image", src);

	Mat dst;
	Mat blured;
	int blockheigth = 0;

	int rows = src.rows;
	int cols = src.cols;

	vector < Mat > blockImages;
	if(blocks == 1)
	{
        blockImages.push_back(src);
	}
	else
	{
        for (int i = 0; i < src.rows; i = i + src.rows / blocks)
        {
            if (i + src.rows / blocks >= src.rows)
                blockheigth = src.rows - i;
            else
                blockheigth = ceil(src.rows / blocks);

            if(i > 0)
                i = i - (kernel_size - 1) / 2;

            cv::Rect rect = cv::Rect(0, i, src.cols, blockheigth + (kernel_size - 1) / 2);
            blockImages.push_back(cv::Mat(src, rect));

            //imshow("blockImage" + Str(i), cv::Mat(src, rect));
        }
	}

	//Sección de hilos

    pthread_t threads[NUM_THREADS];
    struct Block *blocks_t[NUM_THREADS];
    struct Block *blocks_b[NUM_THREADS];

	pthread_attr_t attr;
	void *status;
	int rc;

    //se inician hilos que llaman a la función wait para cada bloque de la imagen original
	for(unsigned i = 0; i < blockImages.size(); i++)
	{
        blocks_t[i] = (Block *)malloc(sizeof(struct Block));
        (blocks_t[i])-> block_id = i;
        (blocks_t[i])-> block_image = &blockImages.at(i);

		rc = pthread_create( &threads[i], NULL, wait, (void *)blocks_t[i] );

		if (rc)
		{
			cout << "Error:unable to create thread," << rc << endl;
			exit(-1);
		}
	}

    //Se almacena la respuesta de los hilos en el vector bluredImages
	vector < Mat > bluredImages;

	pthread_attr_destroy(&attr);
	for (unsigned i = 0; i < blockImages.size(); i++)
	{
		rc = pthread_join(threads[i], &status);
		if (rc)
		{
			cout << "Error:unable to join," << rc << endl;
			exit(-1);
		}

        blocks_b[i] = (Block *)malloc(sizeof(struct Block));
        blocks_b[i] = (struct Block *)status;

        Mat image = *(new Mat(*(blocks_b[i] -> block_image)));

        //cout << "Main: completed thread id :" << blocks_b[i] -> block_id << endl;

		bluredImages.push_back(image);
	}

    //imagen con el efecto terminado
    Mat Final;

	for(unsigned i = 0; i < bluredImages.size(); i++)
	{
        if (bluredImages.at(i).empty())
            continue;

        if(i == 1)
            vconcat(bluredImages.at(i-1), bluredImages.at(i), Final);
        else if(i > 1)
            vconcat(Final, bluredImages.at(i), Final);

        //imshow("blur_" + i, bluredImages.at(i));
	}

    if(!Final.empty())
        imshow("Blur_Final", Final);
    else
        imshow("Blur_Final", bluredImages.at(0));

	int stop_s = clock();

    //cout << "Execution time: " << (stop_s-start_s)/double(CLOCKS_PER_SEC)*1000 << " ms."<< endl;

	int c = waitKey(200000);
	if (c == 27)
		return 0;

    //src.release();
    //Final.release();

    cout << cols << "x";
	cout << rows << "\t";
	cout << blocks << "\t";
	cout << kernel_size << "\t";
    cout << (stop_s-start_s)/double(CLOCKS_PER_SEC)*1000 << " ms" << endl;
}
