#ifndef _GIFENCODER_H_
#define _GIFENCODER_H_

#define MAX_COLORS 256

#include "stdio.h"

typedef struct _imageStruct {
	int width;
	int height;
	char *pixels;
	char *colors;
	int numColors;
	char minCodeSize;
} imageStruct;

typedef struct _dictionaryStruct {
	int index;
	char* key;
} Dicionario;

imageStruct* GIFEncoder(unsigned char *data, int width, int height);
void RGB2Indexed(unsigned char *data, imageStruct* image);
int nextPower2(int n);
char numBits(int n);
void GIFEncoderWrite(imageStruct* image, char* outputFile);
void writeGIFHeader(imageStruct* image, FILE* file);
//
void writeImageBlockHeader(imageStruct* image, FILE* file);
Dicionario* create(int size);
Dicionario* fill(Dicionario* dic, int *dicPos, int ncolors, int clearCode, int end);
int ndigits(int n);
int searchDic(Dicionario* dic, int dicPos, char* key);
void insertInDict(Dicionario *dic, int dicPos, char* key);
Dicionario* doubleSpace(Dicionario *dic, int size);
void LZWCompress(FILE* file, int minCodeSize, char* pixels, int npixels, int ncolors);

#endif