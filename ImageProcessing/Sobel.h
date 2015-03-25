#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include "string.h"

#include "cuda_runtime.h"
#include "device_launch_parameters.h"


//PPM Reader
unsigned int *read_ppm(char *filename, int * xsize, int * ysize, int *maxval);
//PPM Writer
void write_ppm(char *filename, int xsize, int ysize, int maxval, int *pic);
//For Comparsion
void Sobel_Gold(unsigned int* pic, int* result, int xsize, int ysize, int thresh);
//Device Function
__global__ void Sobel_Kernel(unsigned int* pic, unsigned int* result, int xsize, int ysize, int thresh);