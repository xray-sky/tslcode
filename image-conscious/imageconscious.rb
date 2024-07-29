#! /usr/bin/env ruby
#
#  Image Conscious
#
#  disk image file manipulation
#  rough sketch 20230502 bear@
#
#  intended eventually to grow into a much more ambitious project
#  for now just a very rough outline of some ideas on a common theme
#  reading/writing/interpreting information within assorted format disk image files
#

class DiskBlock
  def initialize(data: nil, status: :normal)
    @data = data
    @status = status
  end

  def length
    @data.nil? ? 0 : @data.length
  end

  def fault!
    @status = :bad
  end

  def fault?
    @status == :bad
  end

  alias :size, :length
end

class DiskImage
  attr_accessor :filename, :sides, :tracks, :sectors, :blocksize, :blocks, :blocks_raw
  def initialize(filename: '', blockcount: nil, sides: 2, tracks: 80, sectors: 18, blocksize: 512)
    @filename = filename
    @heads = sides
    @cylinders = tracks
    @sectors = sectors
    @blocksize = blocksize
    @blocks = File.readable?(filename) ? read : Array.new(blockcount || tracks * sectors * sides)
    @blocks_raw = @blocks
  end

  def read
    @blocks = []
    img = File.open(@filename, mode='rb')
    while block = img.read(@blocksize)
      #@blocks << DiskBlock.new(data: block)
      @blocks << block
    end
    img.close
    @blocks.length
  end

  def merge(mergeimage)
    bad_blocks = []
    fixed_blocks = []
    @blocks.each_with_index do |block, i|
      if block.nil?
        bad_blocks << i
        @blocks[i] = mergeimage.blocks[i]
        fixed_blocks << i unless @blocks[i].nil?
      end
      next if mergeimage.blocks[i].nil?
      warn "data clash on block #{i} ??!" unless @blocks[i] == mergeimage.blocks[i]
    end
    puts "repaired blocks: #{fixed_blocks.inspect}"
    puts "remaining bad blocks: #{bad_blocks.select { |b| !fixed_blocks.include?(b) }.inspect}"
  end

  def load_cwtool_errormap(filename)
    errors = File.readlines(filename).select do |l|
      l.match? /^track\s+\d+:\s/
    end

    @blocks_raw = @blocks.dup if errors.any?
    errors.each do |line|
      track = line.match(/^track\s+(\d+):/)[1].to_i
      line.scan(/\s(\d+)=/).flatten.each do |sector|
        #@blocks[track * @sectors + sector ].fault!
        @blocks[track * @sectors + sector.to_i ] = nil
      end
    end
  end

  def blockoffset(head: 0, cylinder: 0, sector: 0)
    # yep
  end

  def length
    @blocks.length
  end

  alias :size, :length

  class AmigaDD < DiskImage
    def initialize(filename: '')
      super(filename: filename, tracks: 80, sides: 2, sectors: 11)
    end
  end

  class DMK < DiskImage
    def initialize(filename: '')
      @tracks = []
      dmk = File.open(filename, mode='rb')
      @header = DMKHeader.new(data: dmk.read(16))

      while trk = DMKTrack.new(data: dmk.read(track_len))
        @tracks << trk
      end
      dmk.close
    end
  end

  def sides
    @header.single_sided ? 1 : 2
  end

  def track(n, side: 0)
    @tracks[n * sides + side]
  end

  # fix up a dmk image file written by cw2dmk incorrectly compiled with 64-bit longs
  def self.fix_64bit_header(dmkfile)
    file = File.open(dmkfile, mode='r+b')
    data = file.read
    file.rewind
    # TODO maybe put in some kind of sanity check before truncating
    file.seek(12)
    file.truncate(file.size - 8)
    file.write data[20..-1]
    file.close
  end
end

class DMKHeader
  attr_reader :single_sided, :single_density, :rx02, :tracks, :track_len

  def initialize(data: '')
    @raw = data
    (@write_prot, @tracks, @track_len, flags, fill, real) = header.unpack('CCS<CA7L<')
    @single_sided        = !(flags & 16).zero?
    @rx02                = !(flags & 32).zero?
    @single_density      = !(flags & 64).zero?
    @obsolete_no_density = !(flags & 128).zero?
    warn "obsolete header flag 'no_density' set" if @obsolete_no_density
  end

  def writeable?
    @write_prot.zero?
  end

  def writeable!
    @write_prot = 0
  end

  def read_only!
    @write_prot = 255
  end
end

class DMKTrack
  attr_reader :bad
  def initialize(data: '')
    @bad = false
    @raw = data
    @length_raw = data.length
    @idam_pointers = data[0..127]
    @track_data = data[128..-1]
    @sector_order = []
    @sectors = []
  end

  def data(raw: false, bad: false, disk_order: false)
    return @data_raw if raw
    return nil unless good? and bad
    return @sector_order.map { |s| @sectors[s].data(raw: raw, bad: bad) } if disk_order
    @sectors.map { |s| s.data(raw: raw, bad: bad) }
  end

  def sector(n, disk_order: false)

  end

  def good?
    !@bad
  end

  def length(raw: nil)
  end
end

class DMKSector
  def initialize(data: '')
  end
end
