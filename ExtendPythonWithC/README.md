## How to run.
#### !!! WARNING !!! Should have nvidia gpu with cuda-support to run with gpu !!! 
1. pull/ clone repo
2. compile with
   -> gcc -shared -o C.so myCfile.c -fPIC
   -> nvcc -shared -o Cuda.cu myCudafile.cu -Xcompiler -fPIC 
3. run with
   -> python3 main.py
4. args
   -> filename: filename without .png
   -> color to be removed (or grayscale)
   -> output directory (recommend o_images)
