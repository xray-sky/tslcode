#! /usr/bin/env ruby
#
# unpacks tape image files in Bob Supnik's SIMH format 
# into individual files. tape blocking not preserved.
#


tap = File.open(ARGV[0])
filenum = 0
outf = File.open("file.#{filenum}", 'w')

while tap do
  break if tap.eof?
  blksz = tap.read(4).unpack('L<')[0]
  if blksz == 0
    filenum += 1
    outf.close
    outf = File.open("file.#{filenum}", 'w')
  else
    outf.write(tap.read(blksz))
    if tap.read(4).unpack('L<')[0] != blksz
      warn "mismatched block - corrupt input?"
    end
  end
end
