import ctypes

myC = ctypes.CDLL("./myCfile.so")  # .dll for WINDOWS
myC.remove_color.argtypes = [ctypes.c_char_p, ctypes.c_int]

filename = input("please enter filename: ")
print("[0 for gray] -- [1 for red] -- [2 for green] -- [3 for blue]")
mode = int(input("please enter [0,1,2,3]: "))

filename_bytes = filename.encode("utf-8")
result = myC.remove_color(filename_bytes, mode)

if result == 1:
    print("Success!")
else:
    print("failed somewhere in c-code...")
