# loads files into superblock
import struct

DATA_AREA_START = 12
SUPERBLOCK_OFFSET = 512*4

# index = which inode it should use
# fname = filename

def addToSuperblock(index, fname, location, content):
    if index >= 32 or len(fname) > 24:
        print("Non conforming values")
        exit(-1)
    with open("flamingos.bin", "rb") as f:
        c = list(f.read(-1))
    pre = c[:SUPERBLOCK_OFFSET]
    superblock = c[SUPERBLOCK_OFFSET:SUPERBLOCK_OFFSET + 1024]
    post = c[SUPERBLOCK_OFFSET+1024:DATA_AREA_START * 512]
    data = c[DATA_AREA_START * 512:]
    
    # filename
    for i,char in enumerate(fname):
        superblock[ (index*32) + i ] = char
    # size
    size = struct.pack("<I", len(content))  # convert size to little endian struct
    for i,char in enumerate(size):
        superblock[ (index*32) + 23 + i ] = char
    # location
    loc = struct.pack("<I", location)
    for i,char in enumerate(loc):
        superblock[ (index*32) + 27 + i ] = char
    
    # data
    for i,char in enumerate(content):
        data[ location + i ] = char
    
    # MODIFY BITMAP!!!

    l = pre + superblock + post + data
    ### !!!! somehow file grows by n * 1440 per iteration  
    with open("flamingos.bin", "wb") as f:
        x = b"".join([i.to_bytes(1, byteorder="little") for i in l])
        f.write(x)


    

with open("file01.txt", "rb") as f:
    d = f.read(-1)
addToSuperblock(0, b"Replaced.lol", 12*512, d)
