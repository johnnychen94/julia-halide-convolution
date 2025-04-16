#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libconv.h"
#include "buffer.h"

int main()
{
    // Create a 4x4 buffer for the output gradient
    int rows = 4;
    int cols = 4;
    double *data = (double *)malloc(rows * cols * sizeof(double));
    memset(data, 0, rows * cols * sizeof(double)); // Initialize with zeros

    // Create a Halide buffer from the data
    CBuffer *buf = create_buffer_from_bytes_2d_f64((unsigned char *)data, rows, cols);
    if (!buf)
    {
        fprintf(stderr, "Failed to create buffer\n");
        free(data);
        return 1;
    }

    // Call the gradient2d function
    int result = gradient2d_f64(buf);
    if (result != 0)
    {
        fprintf(stderr, "Error executing gradient2d_f64: %d\n", result);
        destroy_buffer(buf);
        free(data);
        return 1;
    }

    // Print the resulting gradient
    printf("Gradient output:\n");
    for (int i = 0; i < rows; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            double val = buffer_getindex_2d_f64(buf, i, j);
            printf("%6.2f ", val);
        }
        printf("\n");
    }

    // Clean up
    destroy_buffer(buf);
    free(data);

    return 0;
}
