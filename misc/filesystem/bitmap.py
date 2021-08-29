import random

# add BYTE array (array of 8item array)





def findSectorIndex(bitmap, length):
    index = 0
    bitmask = 1
    num1SinceLastZero = 0
    while index < len(bitmap)*8:                    # Iterator of BYTES in BITMAP
        for bitindex in range(8):                   # bt BYTE, bitindex
            if bitmap[index][bitindex] == 1:        # bittest and check CF
                num1SinceLastZero += 1              # increment countOf1SinceLast0
                if num1SinceLastZero == length:     # cmp with desired length
                    return index*8+bitindex-length  # return total bitnumber if equal
            else:                                   # if NOT carry:
                num1SinceLastZero = 0               # set countOf1SinceLast0 to 0
        index += 1                                  # increment BYTE pointer, redo
    return -1                                       # return ERROR

def Main():
    BITMAP_LENGTH = 32 # 32 bytes in bitmap
    BITMAP = [ [random.randint(0,1) for _ in range(8)] for __ in range(BITMAP_LENGTH)]
    print("Bitmap is as follows: ", BITMAP, "looking for 5")
    bitpos = findSectorIndex(BITMAP, 5)
    print("Startposition: ", bitpos)
    print(BITMAP[bitpos//8:])


if __name__ == '__main__':
    Main()
