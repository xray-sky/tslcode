#! /usr/bin/env ruby
#
# extracts rbak data from Apollo floppy disk block image files
# for piping to rbak -stdin to index/extract
#
# usage:
#  rbakprepfd.rb <imagefile> [ <backup set number> ]
#
#  optional backup set number allows extracting of backup sets
#  other than the first (set number 0). the tape label information
#  printed on stderr will indicate whether there are subesequent
#  backup sets on the medium. 
#

flp = ''
dkimg = File.open(ARGV[0])
fileno = ARGV[1].to_i

def read_track(fh)
  (a,e,b,f,c,g,d,h) = (0..7).map { |t| fh.read(1024) }
  [a,b,c,d,e,f,g,h].join('')
end

# de-interleave
until dkimg.eof? do
  flp << read_track(dkimg)
end
dkimg.close

# data structure on disk:
#  - 1:2 interleave (de-interleaved in read_track())
#  - sector 1 is some kind of disk volume label; irrelevant to rbak
#  - rest of data pays no mind to sector/track boundaries (...mostly)
#  - rbak block size is 8192 bytes
#  - but it actually takes 8300 bytes on disk because of
#    extra layer of data marks
#     + 6 byte record mark:
#        * short (two bytes, BE) : type marker
#             - 0: ANSI "tape" label
#             - 1: rbak file record (less than sector, lead-in)
#             - 2: rbak file record (full sector, (1024 - 6*2) bytes = 1012 bytes)
#             - 3: rbak file record (less than sector, lead-out)
#             - 4: end of "tape" file
#             - 6: pad
#                   . fills to end of sector if insufficient space for subsequent record
#                   . not followed by record length field
#                   . unsure if always appears in pairs (i.e. mark repeats at end of record)
#        * long (four bytes, BE) : record length
#     + record mark repeats at end of record (in opposite order)
#
#  - Each rbak file is preceeded by at least one ANSI label record, followed
#    by a type 4 (EOF) marker
#  - Each file is succeeded by one EOF or EOV ANSI label record.
#  - If there is another rbak set present, the EOF record following the 
#    EOF label will immediately be followed by another ANSI label
#    describing the next rbak set.
#  - and so on.
#
# only the rbak file record data is relevant to rbak. this is emitted
# on stdout, for piping to rbak -stdin. the rest of it is used to
# control the internal state of this program.
#

tpfile = 0
offset = 1024 # skip sector 1, the floppy volume label

while (offset < flp.length) do
  seq = flp[offset..offset+1].unpack('n').first
  (offset += 2 ; next) if seq == 6 # RUNT

  len = flp[(offset+2)..(offset+5)].unpack('N').first
  #warn "flpsz #{flp.length} seq #{seq} len #{len} offset #{offset} remain #{flp.length-offset}"
  case seq
  when 4 then tpfile += 1  # EOF
  when 0
    label = flp[(offset+6)..(offset+len+5)]
    break if label.start_with?('EOV')
    warn "label (#{tpfile/3}): #{label}" unless label.start_with?('EOF')
  else
    print flp[(offset+6)..(offset+len+5)] if ((tpfile / 3) == fileno)
  end
  offset += 12 + len
end
