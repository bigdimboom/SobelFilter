
#include "Sobel.h"
#include <assert.h>

#define DEFAULT_THRESHOLD  4000

//#define DEFAULT_FILENAME "BWstop-sign.ppm"
#define DEFAULT_FILENAME "haha.ppm"

void ComputeOnGPU(int* source, int* result, int xsize, int ysize, int thresh);
bool CompareResults(int* result1, int* result2, int ssize, int ysize);

int main(int argc, char **argv)
{
	int thresh = DEFAULT_THRESHOLD;
	char *filename;
	filename = _strdup(DEFAULT_FILENAME);

	if (argc > 1) {
		if (argc == 3)  { // filename AND threshold
			filename = _strdup(argv[1]);
			thresh = atoi(argv[2]);
		}
		if (argc == 2) { // default file but specified threshhold
			thresh = atoi(argv[1]);
		}
		fprintf(stderr, "file %s threshold %d\n", filename, thresh);
	}

	int xsize, ysize, maxval;
	unsigned int *pic = read_ppm(filename, &xsize, &ysize, &maxval);

	int numbytes = xsize * ysize * 3 * sizeof(int);
	int *result_CPU = (int *)malloc(numbytes);
	int *result_GPU = (int *)malloc(numbytes);
	if (!result_CPU || !result_GPU) {
		fprintf(stderr, "sobel() unable to malloc %d bytes\n", numbytes);
		exit(-1); // fail
	}

	int *out_c = result_CPU;
	int *out_g = result_GPU;

	//Init results : all black
	for (int col = 0; col < ysize; col++) {
		for (int row = 0; row < xsize; row++) {
			*out_c++ = 0;
			*out_g++ = 0;
		}
	}

	//the Real Meat
	Sobel_Gold(pic, result_CPU, xsize, ysize, thresh);
	//Compute On Device
	ComputeOnGPU((int*)pic, result_GPU, xsize, ysize, thresh);

	if (!CompareResults(result_CPU, result_CPU, xsize, ysize)){
		write_ppm("result_error.ppm", xsize, ysize, 255, result_GPU);
		fprintf(stderr, "error result, failed\n");
	}

	fprintf(stdout, "sobel success\n");

	write_ppm("result.ppm", xsize, ysize, 255, result_CPU);

	free(result_CPU);
	free(result_GPU);
	free(pic);

	return EXIT_SUCCESS;
}

void ComputeOnGPU(int* source, int* result, int xsize, int ysize, int thresh)
{
	assert(source != NULL && result != NULL);

	int size = xsize * ysize * sizeof(int);
	int *d_source = 0;
	int *d_result = 0;

	cudaError_t error;

	error = cudaMalloc((void**)&d_source, size);
	error = cudaMalloc((void**)&d_result, size);

	if (error != cudaSuccess)
	{
		fprintf(stderr, "can not allocate cuda memory\n");
	}

	cudaMemcpy(d_source, source, size, cudaMemcpyHostToDevice);

	//Kernel Launch




	//End Kernel
	cudaMemcpy(result, d_result, size, cudaMemcpyDeviceToHost);

	cudaFree(d_source);
	cudaFree(d_result);
}

bool CompareResults(int* result1, int* result2, int xsize, int ysize)
{
	//Testing to see if it's correct.
	int error = 0;
	for (int i = 0; i < xsize*ysize; ++i) {
		if (result1[i ] != result2[ i ]) {
			++error;
		}
	}
	if (!error) {
		return true;
	}

	fprintf(stderr, "Difference: %d\n", error);

	return false;
}