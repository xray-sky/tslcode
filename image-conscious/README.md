# image-conscious

Assorted simple tools for manipulating various types of disk and tape image files.

## bdd.pl

write variable-record-length files to physical tape - can be used with "mapped" dumps produced by `tapeimage.sh`

## dmkmap.c

print a sector map of a dmk format floppy disk image file

hacked up source from the `libdmk` project

## imageconscious.rb

rough prototype framework for an overly ambitious project to manipulate assorted kinds of archive media formats

## simh2sdhawk.rb

converts `simh` format tape image files to Strobe Data Hawk `filetape` format

## tap2aws.rb

converts tape image files in Eric Smith's `tapedump` format to IBM P/390 `AWSTAPE` format

## tapeimage.sh

automates dumping physical tape files to disk, optionally preserving block and/or label metadata. primarily for use with Solaris 2.x

variable-record-length tapes dumped with this tool may be re-created with `bdd.pl`.

## uncptape.rb

extracts individual tape files from US Army AI Center `copytape` format tape image container files
tape blocking is not preserved.

## unod.rb

translate an octal dump (unix `od` style) back to a binary file. works with Gould GNIX (VALID SCALDstation 4BSD) `od`
and may or may not cope with `od` output from any other system.
