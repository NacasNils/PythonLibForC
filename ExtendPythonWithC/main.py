import ctypes  # .dll for WINDOWS

myC = ctypes.CDLL("./myCfile.so")

myC.remove_color.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_char_p]

filename = input("please enter filename: ")
print("[0 for gray] -- [1 for red] -- [2 for green] -- [3 for blue]")
mode = int(input("please enter [0,1,2,3]: "))
output = input("please enter output directory: ")
filename = "./i_images/" + filename + ".png"
filename_bytes = filename.encode("utf-8")
output_bytes = output.encode("utf-8")
result = myC.remove_color(filename_bytes, mode, output_bytes)

if result == 1:
    print("Success!")
elif result == 2:
    print("wrong number input")
elif result == -1:
    print("input .png is NULL")
else:
    print("output .png is NULL (really strange should never happen.)")
