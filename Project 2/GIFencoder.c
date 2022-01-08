#include "GIFencoder.h"
#include "BitFile.h"
#include "math.h"
#include "stdlib.h"
#include "stdio.h"
#include "string.h"

// conversão de um objecto do tipo Image numa imagem indexada
imageStruct* GIFEncoder(unsigned char *data, int width, int height) {
	
	imageStruct* image = (imageStruct*)malloc(sizeof(imageStruct));
	image->width = width;
	image->height = height;

	//converter para imagem indexada
	RGB2Indexed(data, image);

	return image;
}
		
//conversão de lista RGB para indexada: máximo de 256 cores
void RGB2Indexed(unsigned char *data, imageStruct* image) {
	int x, y, colorIndex, colorNum = 0;
	char *copy;

	image->pixels = (char*)calloc(image->width*image->height, sizeof(char));
	image->colors = (char*)calloc(MAX_COLORS * 3, sizeof(char));
	
	
	for (x = 0; x < image->width; x++) {
		for (y = 0; y < image->height; y++) {
			for (colorIndex = 0; colorIndex < colorNum; colorIndex++) {
				if (image->colors[colorIndex * 3] == (char)data[(y * image->width + x)*3] && 
					image->colors[colorIndex * 3 + 1] == (char)data[(y * image->width + x)*3 + 1] &&
					image->colors[colorIndex * 3 + 2] == (char)data[(y * image->width + x)*3 + 2])
					break;
			}

			if (colorIndex >= MAX_COLORS) {
				printf("Demasiadas cores...\n");
				exit(1);
			}

			image->pixels[y * image->width + x] = (char)colorIndex;

			if (colorIndex == colorNum) 
			{
				image->colors[colorIndex * 3]	  = (char)data[(y * image->width + x)*3];
				image->colors[colorIndex * 3 + 1] = (char)data[(y * image->width + x)*3 + 1];
				image->colors[colorIndex * 3 + 2] = (char)data[(y * image->width + x)*3 + 2];
				colorNum++;
			}
		}
	}

	//define o número de cores como potência de 2 (devido aos requistos da Global Color Table)
	image->numColors = nextPower2(colorNum);

	//refine o array de cores com base no número final obtido
	copy = (char*)calloc(image->numColors*3, sizeof(char));
	memset(copy, 0, sizeof(char)*image->numColors*3);
	memcpy(copy, image->colors, sizeof(char)*colorNum*3);
	image->colors = copy;

	image->minCodeSize = numBits(image->numColors - 1);
	if (image->minCodeSize == (char)1)  //imagens binárias --> caso especial (pág. 26 do RFC)
		image->minCodeSize++;
}
		
//determinação da próxima potência de 2 de um dado inteiro n
int nextPower2(int n) {
	int ret = 1, nIni = n;
	
	if (n == 0)
		return 0;
	
	while (n != 0) {
		ret *= 2;
		n /= 2;
	}
	
	if (ret % nIni == 0)
		ret = nIni;
	
	return ret;
}
		
//número de bits necessário para representar n
char numBits(int n) {
	char nb = 0;
	
	if (n == 0)
		return 0;
	
	while (n != 0) {
		nb++;
		n /= 2;
	}
	
	return nb;
}

//---- Função para escrever imagem no formato GIF, versão 87a
//// COMPLETAR ESTA FUNÇÃO
void GIFEncoderWrite(imageStruct* image, char* outputFile) {
	
	FILE* file = fopen(outputFile, "wb");
	char trailer;

	//Escrever cabeçalho do GIF
	writeGIFHeader(image, file);
	
	//Escrever cabeçalho do Image Block
	// CRIAR FUN‚ÌO para ESCRITA do IMAGE BLOCK HEADER!!!
	//Sugest‹o da assinatura do mŽtodo a chamar:
	//
	writeImageBlockHeader(image, file);
	
	/////////////////////////////////////////
	//Escrever blocos com 256 bytes no m‡ximo
	/////////////////////////////////////////
	//CODIFICADOR LZW AQUI !!!! 
	//Sugest‹o de assinatura do mŽtodo a chamar:
	//
	LZWCompress(file, image->minCodeSize, image->pixels, image->width*image->height, image->numColors);
	
	
	fprintf(file, "%c", (char)0);
	
	//trailer
	trailer = 0x3b;
	fprintf(file, "%c", trailer);
	
	fclose(file);
}
	
//--------------------------------------------------
//gravar cabeçalho do GIF (até global color table)
void writeGIFHeader(imageStruct* image, FILE* file) {

	int i;
	char toWrite, GCTF, colorRes, SF, sz, bgci, par;

	//Assinatura e versão (GIF87a)
	char* s = "GIF87a";
	for (i = 0; i < (int)strlen(s); i++)
		fprintf(file, "%c", s[i]);	

	//Ecrã lógico (igual à da dimensão da imagem) --> primeiro o LSB e depois o MSB
	fprintf(file, "%c", (char)( image->width & 0xFF));
	fprintf(file, "%c", (char)((image->width >> 8) & 0xFF));
	fprintf(file, "%c", (char)( image->height & 0xFF));
	fprintf(file, "%c", (char)((image->height >> 8) & 0xFF));
	
	//GCTF, Color Res, SF, size of GCT
	GCTF = 1;
	colorRes = 7;  //número de bits por cor primária (-1)
	SF = 0;
	sz = numBits(image->numColors - 1) - 1; //-1: 0 --> 2^1, 7 --> 2^8
	toWrite = (char) (GCTF << 7 | colorRes << 4 | SF << 3 | sz);
	fprintf(file, "%c", toWrite);

	//Background color index
	bgci = 0;
	fprintf(file, "%c", bgci);

	//Pixel aspect ratio
	par = 0; // 0 --> informação sobre aspect ratio não fornecida --> decoder usa valores por omissão
	fprintf(file, "%c",par);

	//Global color table
	for (i = 0; i < image->numColors * 3; i++)
		fprintf(file, "%c", image->colors[i]);
}

void writeImageBlockHeader(imageStruct* image, FILE* file){

	
	char lctFlag, interfaceFlag, sortFlag, reserved, sizeLCT;
	char flags;

	/* ################### DEBUG ########################

	file = stdout;
	//Image Separator
	fprintf(file, "Image Separator: %d\n", (char)(0x2C));

	//Image Left Position
	fprintf(file, "Left position: %d%d\n", (char)(0),(char) (0));

	//Image Top Position
	fprintf(file, "Top position %d%d\n", (char)(0),(char) (0));

	//Width
	fprintf(file, "Width %d\n", (char)(image->width & 0xFF));
	fprintf(file, "Width %d\n", (char)((image->width >> 8) & 0xFF));

	//Height
	fprintf(file, "Height %d\n", (char)( image->height & 0xFF));
	fprintf(file, "Height %d\n", (char)((image->height >> 8) & 0xFF));

	//flags
	lctFlag = 0;
	interfaceFlag = 0;
	sortFlag = 0;
	reserved = 0;
	sizeLCT = 0;

	flags = (char) (lctFlag << 7 | interfaceFlag << 6 | sortFlag << 5 | reserved << 3 | sizeLCT);
	fprintf(file, "Flags %d\n", flags);

	fprintf(file, "Code size %d\n", (char)(image->minCodeSize));
	*/

	// Image Separator
	fprintf(file, "%c", (char)(0x2C));

	//Image Left Position 2bytes
	fprintf(file, "%c%c", (char)(0),(char) (0));

	// Image Top Position 2bytes
	fprintf(file, "%c%c", (char)(0),(char) (0));

	//Width
	fprintf(file, "%c", (char)( image->width & 0xFF));
	fprintf(file, "%c", (char)((image->width >> 8) & 0xFF));

	//Height
	fprintf(file, "%c", (char)( image->height & 0xFF));
	fprintf(file, "%c", (char)((image->height >> 8) & 0xFF));

	//flags
	lctFlag = 0;
	interfaceFlag = 0;
	sortFlag = 0;
	reserved = 0;
	sizeLCT = 0;

	flags = (char) (lctFlag << 7 | interfaceFlag << 6 | sortFlag << 5 | reserved << 3 | sizeLCT);
	fprintf(file, "%c", flags);

	fprintf(file, "%c", (char)(image->minCodeSize));
	
}	

Dicionario* create(int size){

	Dicionario* tmp;

	tmp = malloc(size*sizeof(Dicionario));

	return tmp;
}

Dicionario* fill(Dicionario* dic, int *dicPos, int ncolors, int clearCode, int end){

	int i;


	for(i = 0; i < ncolors; i++){
		dic[i].index = i;
		dic[i].key = malloc(ndigits(i) * sizeof(char));
		sprintf(dic[i].key, "%d", i);
	}

	//clearCode
	dic[i].index = i;
	dic[i].key = malloc(ndigits(clearCode) * sizeof(char));
	sprintf(dic[i].key, "%d", clearCode);
	//endOfInformation
	i++;
	dic[i].index = i;
	dic[i].key = malloc(ndigits(end) * sizeof(char));
	sprintf(dic[i].key, "%d", end);
	i++;
	(*dicPos) = i;

}

int ndigits(int n){
	int ndigits = 0;

	do{
		ndigits++;
	}while((n = n / 10) != 0);

	return ndigits;
}

int searchDic(Dicionario* dic, int dicPos, char* key){

	int i;

	for(i = 0; i < dicPos; i++){
		if(strcmp(dic[i].key, key) == 0){
			return i;
		}
	}

	return -1;
}

void insertInDic(Dicionario *dic, int dicPos, char* key){

	dic[dicPos].index = dicPos;
	dic[dicPos].key = malloc(sizeof(*key));
	strcpy(dic[dicPos].key, key);

}

Dicionario* doubleSpace(Dicionario *dic, int size){

	return (Dicionario*) realloc(dic, size * sizeof(Dicionario));
}

void LZWCompress(FILE* file, int minCodeSize, char* pixels, int npixels, int ncolors){
	int imgPos = 0;													// posição na imagem
	int dicPos = 0; 												// nº de elementos no dicionário
	int dicSize = pow(2, minCodeSize + 1);								// tamanho do dicionário
	int clearCode, end, pos;
	char* c;
	char temp[4096];
	char buffer[4096];
	Dicionario* dic;
	bitStream* stream = bitFile(file);

	if( (dic = create(dicSize)) == NULL ){ 						
		perror("While creating dictionary\nExiting...\n");
		return;
	}

	clearCode = pow(2, minCodeSize);								// clear code
	end = pow(2, minCodeSize) + 1;									// end of information
	fill(dic, &dicPos, ncolors, clearCode, end); // inicia com o alfabeto

	sprintf(buffer, "%d", pixels[imgPos++]);

	writeBits(stream, clearCode, numBits(dicPos - 1));

	for(; imgPos < npixels; imgPos++){
		c = malloc(ndigits(imgPos) * sizeof(char));
		sprintf(c, "%d", pixels[imgPos]);

		strcpy(temp, buffer);										// temp = buffer + "," + c
		strcat(temp, ",");
		strcat(temp, c);											// buffer permanece intacto

		if(dicPos == dicSize){									//sempre que necessário o espaço do dicionário é duplicado
			if(dicSize < 4096){
				dicSize = dicSize * 2;
				dic = doubleSpace(dic, dicSize);
			}
		}

		if(searchDic(dic, dicPos, temp) != -1){			// se (buffer + c) existir no dicionário concatena-os e continua
			strcat(buffer, ",");
			strcat(buffer, c);
		} else {	 	 										// caso contrario insere no dicionario (buffer + c)

			pos = searchDic(dic, dicPos, buffer);

			writeBits(stream, pos, numBits(dicPos - 1));

			if(dicPos < 4096){									// ao chegar aos 4096 elementos o dicionário é congelado
				insertInDic(dic, dicPos, temp);
				dicPos++;
			}

			strcpy(buffer, c);
		}
		free(c);												// liberta a memória ocupada por c
	}
	writeBits(stream, end, numBits(dicPos - 1));

	free(dic);
	flush(stream);
}



