import ctypes  # .dll for WINDOWS

print ("[C] for CPU -- [G] for GPU")
type = input("please enter [C,G]: ")
if type == "C":
    myC = ctypes.CDLL("./C.so")
elif type == "G":
    myC = ctypes.CDLL("./Cuda.so")
else:
    print("wrong input! exiting...")
    quit() # exit

myC.remove_color.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_char_p]

filename = input("please enter filename: ") # without .png
filename = "./i_images/" + filename + ".png" #input file logic 
filename_bytes = filename.encode("utf-8")

print("[0 for gray] -- [1 for red] -- [2 for green] -- [3 for blue]")
mode = int(input("please enter [0,1,2,3]: ")) # mode for color removal

output = input("please enter output directory: ") # output dir
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
