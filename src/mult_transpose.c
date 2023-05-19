#include <stdio.h>
#include <sys/time.h>
#include <time.h>
#include <stdlib.h>


#ifndef SIZE
#error SIZE undefined [Use -DSIZE=<SIZE> to resolve] 
#endif


// Define range of numbers for matrix ... 
#define MIN -100
#define MAX 100


void init(int (*matrix)[SIZE]);
void mult(int (*matrix_first)[SIZE], int (*matrix_second)[SIZE], int (*matrix_result)[SIZE]);
void transpose(int (*matrix)[SIZE]);
long long unsigned milliseconds_now(void);


int main(void)
{
    int matrix_first[SIZE][SIZE];
    int matrix_second[SIZE][SIZE];
    int matrix_result[SIZE][SIZE]= { 0 };

    init(matrix_first); 
    init(matrix_second);

    // Measure time ...
    long long unsigned start, end, result;
    start = milliseconds_now();
    mult(matrix_first, matrix_second, matrix_result); 
    end = milliseconds_now(); 
    result = end - start;

    // Some silly operations in order to fool compiler ...
    matrix_first[0][0] = matrix_first[1][0];
    matrix_first[0][1] = matrix_first[1][1];

    matrix_second[0][0] = matrix_second[1][0];
    matrix_second[0][1] = matrix_second[1][1];

    matrix_result[0][0] = matrix_result[1][0];
    matrix_result[0][1] = matrix_result[1][1];

    printf("%llu\n", result);

    return 0;
}


void init(int (*matrix)[SIZE])
{
    srand(time(NULL));
    for (size_t i = 0; i < SIZE; i++)
        for (size_t j = 0; j < SIZE; j++)
            matrix[i][j] = (rand() % (MAX - MIN + 1)) + MIN;
}


long long unsigned milliseconds_now(void)
{
    struct timeval val;
    if (gettimeofday(&val, NULL))
        return (unsigned long long) - 1; 
    return val.tv_sec * 1000ULL + val.tv_usec / 1000ULL;
}


void mult(int (*matrix_first)[SIZE], int (*matrix_second)[SIZE], int (*matrix_result)[SIZE])
{
    transpose(matrix_second);
    for (size_t i = 0; i < SIZE; i++)
        for (size_t j = 0; j < SIZE; j++)
            for (size_t k = 0; k < SIZE; k++)
                matrix_result[i][j] += matrix_first[i][k] * matrix_second[j][k];
    transpose(matrix_second);
}


void transpose(int (*matrix)[SIZE])
{
    for (size_t i = 0; i < SIZE; i++)
        for (size_t j = i + 1; j < SIZE; j++)
        {
            int temp = matrix[i][j];
            matrix[i][j] = matrix[j][i]; 
            matrix[j][i] = temp;
        }
}
