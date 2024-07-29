/*
 *      vrsnap - 
 *              Grab a section of the screen into a verbatim (direct color) sgi rgb file.
 *              for m68k IRIS GL2 operating in direct color mode
 *
 *                              r.stricklin - 2017
 *
 */
#include <stdio.h>
#include "image.h"
#include "gl.h"
#include "device.h"
#include "port.h"

typedef struct {
	short magic;			/*   2 -- 474 for SGI image */
	char storage;			/*   1 -- 0 for raw, 1 for RLE */
	char bpc;			/*   1 -- bytes/channel; 1 or 2 */
	unsigned short dimension;	/*   2 -- 3 for real images */
	unsigned short xsize;		/*   2 -- width in pixels */
	unsigned short ysize;		/*   2 -- height in pixels */
	unsigned short zsize;		/*   2 -- number of channels */
	long pixmin;			/*   4 -- minimum pixel value (0) */
	long pixmax;			/*   4 -- maximum pixel value (255) */
	char empty[4];			/*   4 -- not used */
	char imagename[80];		/*  80 -- 79 chars + null. NCU. */
	long colormap;			/*   4 -- 0 for RGB */
	char pad[404];			/* 404 -- should be set to 0 */
} header_t;

#define MAGIC  474

int xsize, ysize;
char **img_R;
char **img_G;
char **img_B;

main(argc,argv)
int argc;
char **argv;
{
    register int y;

    if( argc<2 ) {
        fprintf(stderr,"usage: snap <outfile> [xsize [ysize]]\n");
        exit(1);
    } 
    if(argc >= 3) {
        ysize = xsize = atoi(argv[2]);
        if(argc == 4)
            ysize = atoi(argv[3]);
        prefsize(xsize,ysize);
    }
    getport("vrsnap");
    getsize(&xsize,&ysize);
    img_R = (char **)malloc(ysize*sizeof(char *));
    img_G = (char **)malloc(ysize*sizeof(char *));
    img_B = (char **)malloc(ysize*sizeof(char *));
    for(y=0; y<ysize; y++) {
        percentdone((100.0*y)/ysize);
        img_R[y] = malloc(xsize);
        img_G[y] = malloc(xsize);
        img_B[y] = malloc(xsize);
        cmov2i(0,y);
        readRGB(xsize,img_R[y], img_G[y], img_B[y]);
    }
    percentdone(100.0);
    writeit(argv[1]);
}

writeit(filename)
char *filename;
{
    register FILE *oimage;
    register int y, z;
    header_t fhead;
    unsigned char *buf;

    oimage = fopen(filename,"w");
    if( oimage == NULL ) {
        fprintf(stderr,"imged: can't create output file %s\n",filename);
        exit(0);
    }

    fhead.magic = MAGIC;
    fhead.storage = 0;
    fhead.bpc = 1;
    fhead.dimension = 3;
    fhead.xsize = xsize;
    fhead.ysize = ysize;
    fhead.zsize = 3;
    fhead.pixmin = 0;
    fhead.pixmax = 255;
    /*fhead.imagename = "foo\0";*/
    fhead.colormap = 0;

    writeheader(fhead, oimage);
    
    for(z=0; z<3; z++) {
      for(y=0; y<ysize; y++) {
        switch(z) {
         case 0:
           fwrite(img_R[y], sizeof(char), xsize, oimage);
           break;
         case 1:
           fwrite(img_G[y], sizeof(char), xsize, oimage);
           break;
         case 2:
           fwrite(img_B[y], sizeof(char), xsize, oimage);
           break;
        }
      }
    }

    fclose(oimage);
    percentdone(100.0);
}

writeshort(val, fileh)
unsigned short val;
FILE* fileh;
{
	unsigned char buf[2];
	
	buf[0] = val >> 8;
	buf[1] = val;
	
	fwrite(buf, 2, 1, fileh);
}
	
writelong(val, fileh)
unsigned long val;
FILE* fileh;
{
	unsigned char buf[4];
	
	buf[0] = val >> 24;
	buf[1] = val >> 16;
	buf[2] = val >> 8;
	buf[3] = val;
	
	fwrite(buf, 4, 1, fileh);
}

writeheader(header, fileh) 
header_t header;
FILE* fileh;
{
	writeshort(header.magic, fileh);
	fwrite(&header.storage, 1, 1, fileh);
	fwrite(&header.bpc, 1, 1, fileh);
	writeshort(header.dimension, fileh);
	writeshort(header.xsize, fileh);
	writeshort(header.ysize, fileh);
	writeshort(header.zsize, fileh);
	writelong(header.pixmin, fileh);
	writelong(header.pixmax, fileh);
	fwrite(header.empty, 4, 1, fileh);
	fwrite(header.imagename, 80, 1, fileh);
	writelong(header.colormap, fileh);
	fwrite(header.pad, 404, 1, fileh);
}

