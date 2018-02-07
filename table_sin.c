#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int main() {
	int i, j, k;
	int x;
	char iInBin[7] = {'0'};
	char xInBin[7] = {'0'};
	for (i = 0 ; i < 64 ; i++) {
		x  = lrint(31 * sinf(2 * 3.14 * i / 64));
		for (j = 6 ; j >= 0 ; j--) {
			k = i >> j; 
			iInBin[5 - j] = (k & 1) + '0';
		}
		iInBin[6] = '\0';

		if (x < 0) {
			xInBin[0] = '1';
		} else {
			xInBin[0] = '0';
		}
		for (j = 5 ; j > 0 ; j--) {
			k = abs(x) >> j; 
			xInBin[5 - j + 1] = (k & 1) + '0';
		}
		xInBin[6] = '\0';
		printf("\t\t\t\twhen \"%s\" => SIN <= \"%s\";\n", iInBin, xInBin);
	}
	return 0;
}
