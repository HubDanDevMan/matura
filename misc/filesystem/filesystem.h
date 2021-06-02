#ifndef FILESYSTEM_H
#define FILESYSTEM_H

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

void writeToSuperblock(void);
int getInodeNumber(char * filename);
int getFreeInode(void);

extern char * disk;
extern inode sb_cache[SECTOR_SIZE]; // because the cache has to be written to disk it should be conveniently sized like a sector

#endif
