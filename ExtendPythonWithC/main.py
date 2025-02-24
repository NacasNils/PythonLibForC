import ctypes

# Load the shared library
myC = ctypes.CDLL("./myCfile.so")  # Use "myCfile.dll" on Windows
myC.remove_color.argtypes = [ctypes.c_char_p]
filename = input("please enter filename: ")

filename_bytes = filename.encode('utf-8')
result = myC.remove_color(filename_bytes)

# Call the C function
if result == 1:
    print("Success!")
else: 
    print("failed somewhere in c-code...")
