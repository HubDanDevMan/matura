def toLBA(C, H,S):
    HPC = 16
    SPT = 63
    return (C * HPC + H) * SPT + (S - 1)

def toCHS(lba):
    HPC = 16
    SPT = 63
    C = lba // (HPC * SPT)
    H = (lba // SPT) % HPC
    S = (lba % SPT) +1
    return (C, H, S)


print(toCHS(2015))
print(toLBA(1,15,63))
