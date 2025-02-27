#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

// stb_import
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image/stb_image_write.h"

#define RED 0
#define GREEN 1
#define BLUE 2

extern "C" {
    int remove_color(const char *input, int mode, const char *o_dir);
}


// CUDA Error checking macro
#define CUDA_CHECK(call) \
    { \
        cudaError_t err = call; \
        if (err != cudaSuccess) { \
            printf("CUDA error in %s at line %d: %s\n", __FILE__, __LINE__, cudaGetErrorString(err)); \
            exit(EXIT_FAILURE); \
        } \
    }

// CUDA Kernel for grayscale conversion
__global__ void grayscaleKernel(unsigned char *img, unsigned char *gray_img, int width, int height, int channels) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int total_pixels = width * height;
    
    if (idx < total_pixels) {
        int i = idx * channels;
        gray_img[idx] = (unsigned char)((img[i] + img[i + 1] + img[i + 2]) / 3);
    }
}

// CUDA Kernel to remove a specific color
__global__ void removeColorKernel(unsigned char *img, int width, int height, int channels, int color) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int total_pixels = width * height;

    if (idx < total_pixels) {
        img[idx * channels + color] = 0;  // Set the specified color channel to 0
    }
}

// Function to handle grayscale conversion using CUDA
int remove_all(int width, int height, int channels, unsigned char *img, const char *o_dir) {
    int img_size = width * height * channels;
    int gray_img_size = width * height;
    
    unsigned char *d_img, *d_gray_img;
    unsigned char *gray_img = (unsigned char *)malloc(gray_img_size);

    if (!gray_img) return -2;

    // Allocate device memory
    CUDA_CHECK(cudaMalloc((void **)&d_img, img_size));
    CUDA_CHECK(cudaMalloc((void **)&d_gray_img, gray_img_size));

    // Copy input image to device
    CUDA_CHECK(cudaMemcpy(d_img, img, img_size, cudaMemcpyHostToDevice));

    // Launch CUDA kernel
    int threadsPerBlock = 256;
    int blocksPerGrid = (width * height + threadsPerBlock - 1) / threadsPerBlock;
    grayscaleKernel<<<blocksPerGrid, threadsPerBlock>>>(d_img, d_gray_img, width, height, channels);
    CUDA_CHECK(cudaDeviceSynchronize());

    // Copy result back to host
    CUDA_CHECK(cudaMemcpy(gray_img, d_gray_img, gray_img_size, cudaMemcpyDeviceToHost));

    // Save output image
    char output[256];
    sprintf(output, "./%s/out_gray.png", o_dir);
    stbi_write_png(output, width, height, 1, gray_img, width);

    // Free memory
    cudaFree(d_img);
    cudaFree(d_gray_img);
    free(gray_img);

    return 1;
}

// Function to remove a color channel using CUDA
int remove_rgb(int width, int height, int channels, unsigned char *img, int color, const char *o_dir) {
    int img_size = width * height * channels;
    
    unsigned char *d_img;
    CUDA_CHECK(cudaMalloc((void **)&d_img, img_size));
    CUDA_CHECK(cudaMemcpy(d_img, img, img_size, cudaMemcpyHostToDevice));

    // Launch CUDA kernel
    int threadsPerBlock = 256;
    int blocksPerGrid = (width * height + threadsPerBlock - 1) / threadsPerBlock;
    removeColorKernel<<<blocksPerGrid, threadsPerBlock>>>(d_img, width, height, channels, color);
    CUDA_CHECK(cudaDeviceSynchronize());

    // Copy result back to host
    CUDA_CHECK(cudaMemcpy(img, d_img, img_size, cudaMemcpyDeviceToHost));

    // Save output image
    char output[256];
    sprintf(output, "./%s/out_rgb.png", o_dir);
    stbi_write_png(output, width, height, channels, img, width * channels);

    // Free memory
    cudaFree(d_img);

    return 1;
}

// Main function to process image
int remove_color(const char *input, int mode, const char *o_dir) {
    int width, height, channels;
    unsigned char *img = stbi_load(input, &width, &height, &channels, 0);

    if (img == NULL) return -1;

    int result;
    if (mode == 0) {
        result = remove_all(width, height, channels, img, o_dir);
    } else if (mode == 1) {
        result = remove_rgb(width, height, channels, img, RED, o_dir);
    } else if (mode == 2) {
        result = remove_rgb(width, height, channels, img, GREEN, o_dir);
    } else if (mode == 3) {
        result = remove_rgb(width, height, channels, img, BLUE, o_dir);
    } else {
        result = 2;
    }

    stbi_image_free(img);
    return result;
}

// Main function for testing
int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("Usage: %s <input_image> <mode> <output_dir>\n", argv[0]);
        return -1;
    }

    const char *input = argv[1];
    int mode = atoi(argv[2]);
    const char *o_dir = argv[3];

    int status = remove_color(input, mode, o_dir);
    if (status == 1) {
        printf("Image processed successfully.\n");
    } else {
        printf("Error processing image. Code: %d\n", status);
    }

    return 0;
}

