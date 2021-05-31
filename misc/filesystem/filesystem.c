#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "filesystem.h"


char * disk;

// These are cached in RAM but a disk representation is present as well
inode sb_cache[SUPERBLOCK_SIZE];
char sectBitmap[TOTAL_SECTORS/8];


int main()
{
	// create pseudo disk
	disk = calloc(TOTAL_SECTORS, SECTOR_SIZE);

	// Figure out how to represent the used sectors of the SB in bitmap
	// The size of the superblock is set to SUPERBLOCK_SIZE*sizeof(inode)
	const sbSizeInBytes = SUPERBLOCK_SIZE*sizeof(inode); // size in bytes of superblock
	
	// Next step is to find the exact number of sectors it takes up
	unsigned char usedSBSectorsAsBitmap(unsigned char) ceil( (double)sbSizeInBytes/512 ); // <- this can be undefined behavior if we cast doubles to chars but this should be a compile time constant. But the C preprocessor does not allow float arithmetic, thats why this value is defined at runtime
	// It is important to note that if we only use a char as the usedSBSectorsAsBitmap type the
	// limit of inodes that can be held in the superblock is limited quite a bit.
	// But right now we dont want to deal with endiannes issues.
	
	


	char cmdBuffer[FILE_NAME_LEN];
	// user interaction
	for (;;){
		fgets(cmdBuffer, FILE_NAME_LEN, stdin);
		if (strcmp(cmdBuffer, "exit\n") == 0){
			break;
		}
		else if (strcmp(cmdBuffer, "ls\n") == 0){
			for (int i=0; i < SUPERBLOCK_SIZE; i++){
				if (sb_cache[i].fname[0] != 0){
					printf("%s",sb_cache[i].fname);
				}
			}
		}
		else if (strcmp(cmdBuffer, "touch\n") == 0){
			int freeEntry = getFreeInode();
			if (freeEntry != -1){
				puts("What should be the filename? ");
				fgets(cmdBuffer, FILE_NAME_LEN, stdin);
				// check if file already exists
				if (getInodeNumber(cmdBuffer) != -1){
					printf("%s already exists\n", cmdBuffer);
					continue;
				}
				strncpy(sb_cache[freeEntry].fname, cmdBuffer, FILE_NAME_LEN);
				sb_cache[freeEntry].size = 1;
				puts("done\n");
			}
			else {
				puts("Not enough space\n");
			}
		}
		else {
			printf("Invalid command: %s\nUse touch, del, ls or exit\n", cmdBuffer);
		}



	}


	return 0;
}

// This function writes the whole sb_cache to the disk
void writeToSuperblock(void)
{
	// writeSector(0, sb_cache); <--- not yet implemented
	memcpy(disk, sb_cache, SUPERBLOCK_SIZE);
}


int getInodeNumber(char * filename)
{
	for (int i = 0; i < SUPERBLOCK_SIZE; i++){
		if (strcmp(sb_cache[i].fname, filename) == 0){
			return i;
		}
	}
	return -1;
	// FILE NOT FOUND
}

int getFreeInode(void)
{
	for (int i = 0; i < SUPERBLOCK_SIZE; i++){
		if (sb_cache[i].fname[0] == 0){
			return i;
		}
	}
	return -1;
}



