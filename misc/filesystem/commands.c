#include "filesystem.h"

// This file implements an algorhithm finding a fitting
// It works by keeping track of all the sectors that are full
// with a bitmap. Because every sector is 512 bytes large and only
// one bit is needed to represent the file in the bitmap. Parsing the
// bit map could be a bit slow because because computers work on bits.
// Luckily to find a free sector in the bitmap, one does only have to
// look for a byte that is less than 0xFF. Only then it has to identify
// the correct bit

// GEELEDDDDD
//


int findEmptySector()
{ // this function scans through the bitmap for unoccupied sectors
	while (sectBitmap)

}
