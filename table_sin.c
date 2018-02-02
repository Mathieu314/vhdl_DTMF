#include <stdio.h>
#include <math.h>


int main() {
	int i;
	int x;
	for (i = 0 ; i < 64 ; i++) {
		x  = lrint(31 * sinf(2 * 3.14 * i / 64));
		printf("%d\n", x);
	}
	return 0;
}
