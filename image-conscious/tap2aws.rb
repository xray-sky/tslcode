#! /usr/bin/env ruby
#
# converts tape image files in Eric Smith's "tapedump" format
# to IBM P/390 AWSTAPE format
#


tap = File.open(ARGV[0])
if File.exist?(ARGV[1])
  warn "#{ARGV[1]} exists"
  exit 1
else
  aws = File.open(ARGV[1], File::CREAT|File::TRUNC|File::WRONLY)
end

AWStapmark = 0x40
AWSrecmark = 0xa0
lastblksz  = 0

while tap do
  blksz = tap.read(4).unpack('L<')[0]
  if blksz == 0
    aws.write([ [blksz], [lastblksz], [AWStapmark] ].map { |f| f.pack('s') }.join)
  else
    aws.write([ [blksz], [lastblksz], [AWSrecmark] ].map { |f| f.pack('s') }.join)
    aws.write(tap.read(blksz))
    if tap.read(4).unpack('L<')[0] != blksz
      warn "mismatched block - corrupt input?"
    end
  end
  lastblksz = blksz
end
aws.close
