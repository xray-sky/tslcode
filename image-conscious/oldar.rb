#! /usr/bin/env ruby
#
# extract v6/v7 archive (library) files
#

ar = File.open(ARGV[0])
magic = ar.read(2).unpack('S<').first

until ar.eof? do

  case magic
  when 0o177555 # v6 - NUXI problem
    (name, date_hi, date_lo, uid, mode, size) = ar.read(16).unpack('A8vvccv')
    mode = 0o644 # "There isn't enough room to store the proper mode, so ar always extracts in mode 666."
  when 0o177545 # v7 - NUXI problem
    (name, date_hi, date_lo, uid, gid, mode, size_hi, size_lo) = ar.read(26).unpack('A14vvccvvv')
    size = (size_hi << 16) + size_lo
  else
    warn "not v6/v7 format"
    ar.close
    exit(1)
  end

  mtime = Time.at (date_hi << 16) + date_lo
  puts "#{mode.to_s(8)}  #{name.ljust(16)}\t#{size.to_s.rjust(12)}  #{uid.to_s.ljust(8)} #{gid.to_s.ljust(8)}\t#{mtime.strftime('%Y-%m-%d %H:%M:%S')}"
  o = File.new(name, 'wb', mode)
  o.write ar.read(size)
  o.close
  File.utime(Time.now, mtime, name)
  ar.read(1) if ar.tell % 2 == 1

end

ar.close
