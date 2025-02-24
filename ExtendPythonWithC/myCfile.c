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
  if(img == NULL){
    exit(1);
  }
  stbi_write_png("output.png",width,height,channels, img, width * channels);
  
  stbi_image_free;
}
