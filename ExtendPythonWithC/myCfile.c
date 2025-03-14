#include <stdio.h>
#include <stdlib.h>

// stb_import
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image/stb_image_write.h"

// Macros's for rgb
#define RED 0
#define GREEN 1
#define BLUE 2

// helpter methods to remove_color( ... )
int remove_all(int width, int height, int channels, unsigned char *img, const char *o_dir);
int remove_rgb(int width, int height, int channels, unsigned char *img,int color, const char *o_dir);


int remove_color(const char *input, int mode, const char *o_dir){
  int width,height,channels;
  unsigned char *img = stbi_load(input, &width, &height, &channels, 0);

  // ERROR HANDLING
  if(img == NULL){
    return -1;
  }
  if(mode == 0){
    return remove_all(width,height,channels,img, o_dir);
  }
  if(mode == 1){
    return remove_rgb(width,height,channels,img, RED, o_dir);
  }
  if (mode == 2){
    return remove_rgb(width, height, channels, img, GREEN, o_dir);
  }
  if(mode == 3){
    return remove_rgb(width,height, channels, img, BLUE, o_dir);
  }
  return 2;
}

int remove_all(int width, int height, int channels, unsigned char *img, const char *o_dir){

  size_t img_size = width * height * channels;
  int gray_channels = channels == 4 ? 2 : 1;
  size_t gray_img_size = width * height;
  unsigned char *gray_img = malloc(gray_img_size);

  // ERROR HANDLING
  if(gray_img == NULL){
    return -2;
  }

  for (unsigned char *p = img, *pg = gray_img; p != img + img_size; p += channels, pg += gray_channels){
    *pg = (uint8_t)((*p + *(p + 1) + *(p + 2))/3);
    if(channels == 4){
      *(pg + 1) = *(p + 3); }
  }
  char output[256];
  sprintf(output, "./%s/out_gray.png", o_dir);
  stbi_write_png(output, width, height, gray_channels, gray_img, width * gray_channels);
  
  
  stbi_image_free;
  free(gray_img);
  return 1;
}

int remove_rgb(int width, int height, int channels, unsigned char *img, int color, const char *o_dir){
  size_t img_size = width * height * channels;
  size_t red_img_size = width * height * channels;

  unsigned char *red_img = malloc(red_img_size);

  if(red_img == NULL){
    return -2;
  }
for (unsigned char *p = img, *pr = red_img; p != img + img_size; p += channels, pr += channels) {
    // Copy full pixel (RGB or RGBA)
    memcpy(pr, p, channels);  

    // Set red channel to 0
    pr[color] = 0;
} 
  char output[256];
  sprintf(output, "./%s/out_rgb.png", o_dir);
  stbi_write_png(output, width, height, channels, red_img, width*channels);
  stbi_image_free;
  free(red_img);
  return 1;
}
