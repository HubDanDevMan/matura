#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define SECTOR_SIZE	512
#define TOTAL_SECTORS	64	
#define SUPERBLOCK_SIZE 8 	// Amount of files that can be stored in FS

#define FILE_NAME_LEN	16


typedef struct {
	char fname[FILE_NAME_LEN];	// filename
	int location;			// start sector
	int size;			// Size in sectors
} inode;



void readSector();
void writeSector();
void writeToSuperblock();
int getInodeNumber(char * filename);
int getFreeInode(void);

char * disk;
inode sb_cache[SUPERBLOCK_SIZE];
int main()
{
	// create pseudo disk and ram
	disk = calloc(TOTAL_SECTORS, SECTOR_SIZE);

	// create superblock on disk and superblock cache in memory
	sb_cache;





	char cmdBuffer[FILE_NAME_LEN];
	// user interaction
	for (;;){
		fgets(cmdBuffer, FILE_NAME_LEN, stdin);
		if (strcmp(cmdBuffer, "exit\n") == 0){
			break;
		}
		else if (strcmp(cmdBuffer, "ls\n") == 0){
			for (int i=0; i < SUPERBLOCK_SIZE; i++){ 
				printf("%s\n",sb_cache[i].fname);
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



