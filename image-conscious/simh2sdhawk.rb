#! /usr/bin/env ruby
#
# converts tape image files in Bob Supnik's SIMH format
# to mapped tape files for use with Strobe Data Hawk
#
# low effort/experimental (no attempt to deal productively with
# bad data or other valid non-data record types)
#

raise ArgumentError('need input & output filenames') if ARGV.length < 2

tap = File.open(ARGV[0])
filenum = 0
outf = File.open("#{ARGV[1]}.tap", 'w')
mapf = File.open("#{ARGV[1]}.tix", 'w')

def readmark(tape)
  metadata = tape.read(4).unpack('L<').first
  [ metadata >> 28, metadata & 0x7ffffff ]
end

def writemark(file, n = 1)
  file.write("\xff\xff" * n)
end

until tap.eof? do
  (classn, mval) = readmark(tap)
  case classn
  when 0
    if mval == 0 # tape mark 
      filenum += 1
      writemark mapf
    else # good data record
      outf.write tap.read(mval)
      tap.read(1) if mval%2 > 0
      mapf.write [mval].pack('S<')
      (classn, recl) = readmark(tap)
      warn "out of phase reading block data!" if classn != 0 and mval != recl
    end
  when 8
    warn "bad data record in file #{filenum}"
    if mval > 0
      tap.read(mval)
      tap.read(1) if mval%2 > 0
      (classn, recl) = readmark(tap)
      warn "out of phase reading block data!" if classn != 8 and mval != recl
    end  
  else
    warn "unexpected record class #{classn}"
  end
end
outf.close
mapf.write "\xff\xff\xff\xff\xff\xff"
mapf.close
