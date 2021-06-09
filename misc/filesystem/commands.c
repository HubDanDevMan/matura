#include "filesystem.h"

// This file implements an algorhithm finding a fitting
// It works by keeping track of all the sectors that are full
// with a bitmap. Because every sector is 512 bytes large and only
// one bit is needed to represent the file in the bitmap. Parsing the
// bit map could be a bit slow because because computers work on bits.
// Luckily to find a free sector in the bitmap, one does only have to
// look for a byte that is less than 0xFF. Only then it has to identify
// the correct bit




int findEmptySectors(int sectorsNeeded)
{ // this function scans through the bitmap for sectorsNeeded consecutive unoccupied sectors
	int i = 0, j = 0;
	while (sectBitmap[i] == 0xff){
		i++;
		if (i == TOTAL_SECTORS){ return -2;}	// Disk is completely full 
		// calculate which bits are free
	}

	// sectBitmap contains free space
	// sectorsNeeded
	// parse byte for free bits
	unsigned char res = parseByte(sectBitmap[i]);
	
}




unsigned char parseByte(char byte){
	/* 
	 * identify 1100011i
	 */

	char highestFree = 0, bit;
	for (int i = 0; i<8; i++){
		//bittest
		val = byte >> i; // parse until
		bit = val & 1;
		if (bit == 0)
			highestFree++;
			flag = 1;
			// check next bit is used, if so sector is full
			if ((byte >> i+1) & 1 == 1){
				return highestFree; 	// NOTE THIS ONLY RETURNS
							// THE NUMBER; NOT THE BIT OFFSET
							// Register should hold the correct bit
							// offset in ASM implementation
			}
	}
}
