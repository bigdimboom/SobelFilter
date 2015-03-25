#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include "string.h"

//PPM Reader
unsigned int *read_ppm(char *filename, int * xsize, int * ysize, int *maxval);
//PPM Writer
void write_ppm(char *filename, int xsize, int ysize, int maxval, int *pic);
//For Comparsion
void Sobel_Gold(unsigned int* pic, int* result, int xsize, int ysize, int thresh);