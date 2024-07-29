#! /usr/bin/env ruby
#
# recreates a binary file from a text file containing an octal dump
# (unix `od` style)
#
# was written specifically to retrieve files from the Gould 9540
# with GNIX (derived from VALID Logic SCALDstation 4BSD) and may
# or may not cope with `od` output from any other system.
#

exit unless ARGV.length == 2

dump = IO.readlines(ARGV[0])
undump = File.new(ARGV[1], File::CREAT|File::TRUNC|File::WRONLY)

lastpos = -16

dump.each do |line|
  next unless /^(?<pos>\d+)\s+(?<bytes>[a-f\d\s]+)$/ =~ line
  pos = pos.to_i(8)
  # 7 digit address wraps at octal 1000000
  gap = (pos - 16 - lastpos) % 010000000
  undump << ([0]*gap).pack('C*') unless gap.zero?
  undump << bytes.scan(/[a-f\d][a-f\d]/).map(&:hex).pack('C*')
  lastpos = pos
end
