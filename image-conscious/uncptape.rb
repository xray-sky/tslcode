#! /usr/bin/env ruby
#
# unpacks tape image files in US Army AI Center "copytape" (.tap) format 
# into individual files. tape blocking not preserved.
#


tap = File.open(ARGV[0])
filenum = 0
outf = File.open("file.#{filenum}", 'w')

while tap do
  cmd = tap.read(9)
  case cmd
  when 'CPTP:BLK ' # block
    # read blocksize
    blksz = tap.read(7).to_i # to_i will ditch the trailing \n for us
    outf.write tap.read(blksz)
    # format apparently specifies a newline after block data
    warn "out of phase reading block data!" if tap.read(1) != "\n"
  when "CPTP:MRK\n" # file mark
    filenum += 1
    outf.close
    outf = File.open("file.#{filenum}", 'w')
  when "CPTP:EOT\n"
    exit(0)
  else
    warn "eek! unexpected command #{cmd.inspect}"
    exit(1)# if outf.eof?
  end
end
