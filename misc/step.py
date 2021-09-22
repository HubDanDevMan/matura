import gdb

REDO_LOOP_ADDR = 0x7e41

def stepOnce():
    # print registers
    print("Consecutive 1s since last 0:")
    gdb.execute("i r eax")
    gdb.execute(f"break *{REDO_LOOP_ADDR}")
    gdb.execute("si")
    gdb.execute("continue")

