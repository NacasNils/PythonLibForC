import ctypes

# Load the shared library
myC = ctypes.CDLL("./myCfile.so")  # Use "myCfile.dll" on Windows
filename = input("please enter filename: ")

# Call the C function
result = myC.remove_color(filename)
print(result)
