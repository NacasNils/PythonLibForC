import ctypes

# Load the shared library
myC = ctypes.CDLL("./myCudaFile.so")  # Use "myCfile.dll" on Windows

# Call the C function
result = myC.add(3, 5)
