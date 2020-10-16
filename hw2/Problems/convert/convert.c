#include <stdio.h>
#include <stdlib.h>
#define SIZE 15

int convert(char *);

int main()
{
    char input[SIZE];
    int out;

    while (scanf("%s", input) != EOF) {
        out = convert(input);
	printf("%d\n", out);
    }

    return 0;
}

