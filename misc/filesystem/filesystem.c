#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "filesystem.h"


char * disk;
inode sb_cache[SECTOR_SIZE];
int main()
{
	// create pseudo disk
	disk = calloc(TOTAL_SECTORS, SECTOR_SIZE);






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



