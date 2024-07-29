#!/usr/bin/env perl
# -------------------------
# Prints header info for SGI .rgb image
#

@headerFieldID = ("MAGIC","STORAGE","BPC","DIMENSION","XSIZE","YSIZE","ZSIZE","PIXMIN","PIXMAX","DUMMY","IMAGENAME","COLORMAP","DUMMY2");
%headerFieldLen = ('MAGIC',2,'STORAGE',1,'BPC',1,'DIMENSION',2,'XSIZE',2,'YSIZE',2,'ZSIZE',2,'PIXMIN',4,'PIXMAX',4,'DUMMY',4,'IMAGENAME',80,'COLORMAP',4,'DUMMY2',404);

$filename = $ARGV[0];

sysopen (IMAGE_1, $filename, 0);	# mode 0: read only

foreach (@headerFieldID) {
	sysread(IMAGE_1, $headerData{$_}, $headerFieldLen{$_});
	}

foreach (@headerFieldID) {
	print "$_ : ";
	print (vec($headerData{$_}, 0, (8 * $headerFieldLen{$_}) ));
	print "\n";
	}

print "$headerData{'IMAGENAME'}\n";

close (IMAGE_1);
