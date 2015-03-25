#include "Sobel.h"


void Sobel_Gold(unsigned int* pic, int* result, int xsize, int ysize, int thresh) {

	int magnitude, sum1, sum2;

	for (int i = 1; i < ysize - 1; i++) {
		for (int j = 1; j < xsize - 1; j++) {

			int offset = i*xsize + j;

			sum1 = pic[xsize * (i - 1) + j + 1] - pic[xsize*(i - 1) + j - 1]
				+ 2 * pic[xsize * (i)+j + 1] - 2 * pic[xsize*(i)+j - 1]
				+ pic[xsize * (i + 1) + j + 1] - pic[xsize*(i + 1) + j - 1];

			sum2 = pic[xsize * (i - 1) + j - 1] + 2 * pic[xsize * (i - 1) + j] + pic[xsize * (i - 1) + j + 1]
				- pic[xsize * (i + 1) + j - 1] - 2 * pic[xsize * (i + 1) + j] - pic[xsize * (i + 1) + j + 1];

			magnitude = sum1*sum1 + sum2*sum2;

			if (magnitude > thresh)
				result[offset] = 255;
			else
				result[offset] = 0;
		}
	}
}