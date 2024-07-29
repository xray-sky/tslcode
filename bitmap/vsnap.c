/*
 *      vsnap - 
 *              Grab a section of the screen into a verbatim (direct color) sgi rgb file.
 *              for m68k IRIS GL2 operating in indexed color mode
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
#define MAXPAL 1024

int xsize, ysize;
short **img;

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
    getport("vsnap");
    getsize(&xsize,&ysize);
    img = (short **)malloc(ysize*sizeof(short *));
    for(y=0; y<ysize; y++) {
        percentdone((100.0*y)/ysize);
        img[y] = (short *)malloc(xsize*sizeof(short));
        cmov2i(0,y);
        readpixels(xsize,img[y]);
    }
    percentdone(100.0);
    writeit(argv[1]);
}

writeit(filename)
char *filename;
{
    register FILE *oimage;
    register int x, y, z;
    header_t fhead;
    unsigned short r, g, b;
    unsigned char *buf;
    unsigned short pal[MAXPAL][3];

    buf = (unsigned char*)malloc(xsize*sizeof(char));

    /* reading palette is slow; make a copy of it */
    for(x=0; x<MAXPAL; x++) {
      getmcolor(x, &r, &g, &b);
      pal[x][0] = r;
      pal[x][1] = g;
      pal[x][2] = b;
    }

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
        for(x=0; x<xsize; x++) {
          buf[x] = (unsigned char)pal[img[y][x]][z];
        }
        fwrite(buf, sizeof(char), xsize, oimage);
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

