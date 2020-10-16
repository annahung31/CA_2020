#include <stdio.h>

unsigned long long int fibonacci(int);



int main () {
    unsigned long long int ret;

    for (int i = 0; i < 94; i++) {
        ret = fibonacci(i);
        printf("%llu\n", ret);
    }

    return 0;
}
