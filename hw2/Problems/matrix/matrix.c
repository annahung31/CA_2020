#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <time.h>
#define MOD 1024
#define SIZE 128

void matrix_mul(unsigned short (*)[SIZE], unsigned short (*)[SIZE], unsigned short (*)[SIZE]);

int main () {
    unsigned short A[SIZE][SIZE], B[SIZE][SIZE], C[SIZE][SIZE];
    unsigned long long start, end;

    srand(time(NULL));

    // init
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            A[i][j] = rand() % MOD;

    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            B[i][j] = rand() % MOD;

    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            C[i][j] = 0;


    asm volatile ("rdcycle %0" : "=r" (start));
    // matrix_mul(A, B, C);
    // int i, j;
    // for (int i = 0; i < SIZE; i++){
    //     for (int j = 0; j < SIZE; j++){
    //         for (int k = 0; k < SIZE; k++){
    //             C[i][j] = (C[i][j] + A[i][k] * B[k][j]) % MOD;
    //             printf("%f\n", C[i][j]);
    //         }
    //     }
    // }
        
            
    unsigned short sum;
    int bsize=25;
    int en = bsize * (SIZE/bsize);
    for (int kk = 0; kk < en; kk += bsize) {
        for (int jj = 0; jj < en; jj += bsize) {
	        for (int i = 0; i < SIZE; i++) {
		        for (int j = jj; j < jj+bsize; j++) { // updated 2006/12/19
		            sum = C[i][j];
		            for (int k = kk; k < kk+bsize; k++) {
		                sum = ( sum + A[i][k] * B[k][j]) % MOD;
		            }
		            C[i][j] = sum;
                    
		        }
	        }
        }
    }

    asm volatile ("rdcycle %0" : "=r" (end));


    // check
    unsigned short check[SIZE][SIZE];
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            check[i][j] = 0;
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            for (int k = 0; k < SIZE; k++)
                check[i][j] = (check[i][j] + A[i][k] * B[k][j]) % MOD;

    for (int i = 0; i < SIZE; i++){
        for (int j = 0; j < SIZE; j++){
            // printf("%f, %f \n",check[i][j], C[i][j]);
            assert(check[i][j] == C[i][j]);
        }
    }




    printf("Took %llu cycles\n", end - start);
}
