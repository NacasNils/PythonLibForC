#include <stdio.h>
#include <stdlib.h>

// stb_import
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image/stb_image_write.h"



int remove_color(const char *input){
  int width,height,channels;
  unsigned char *img = stbi_load(input, &width, &height, &channels, 0);

  // ERROR HANDLING
  if(img == NULL){
    return -1;
    exit(1);
  }

  size_t img_size = width * height * channels;
  int gray_channels = channels == 4 ? 2 : 1;
  size_t gray_img_size = width * height;
  unsigned char *gray_img = malloc(gray_img_size);

  // ERROR HANDLING
  if(gray_img == NULL){
    return -1;
    exit(1);
  }

  for (unsigned char *p = img, *pg = gray_img; p != img + img_size; p += channels, pg += gray_channels){
    *pg = (uint8_t)((*p + *(p + 1) + *(p + 2))/3);
    if(channels == 4){
      *(pg + 1) = *(p + 3);
    }
  }

  stbi_write_png("./output.png", width, height, gray_channels, gray_img, width * gray_channels);
  
  
  stbi_image_free;
  free(gray_img);
  return 1;
}
