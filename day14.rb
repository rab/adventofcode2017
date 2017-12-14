# --- Day 14: Disk Defragmentation ---

# Suddenly, a scheduled job activates the system's disk defragmenter. Were the situation
# different, you might sit and watch it for a while, but today, you just don't have that kind of
# time. It's soaking up valuable system resources that are needed elsewhere, and so the only
# option is to help it finish its task as soon as possible.
#
# The disk in question consists of a 128x128 grid; each square of the grid is either free or
# used. On this disk, the state of the grid is tracked by the bits in a sequence of knot hashes.
#
# A total of 128 knot hashes are calculated, each corresponding to a single row in the grid; each
# hash contains 128 bits which correspond to individual grid squares. Each bit of a hash indicates
# whether that square is free (0) or used (1).
#
# The hash inputs are a key string (your puzzle input), a dash, and a number from 0 to 127
# corresponding to the row.  For example, if your key string were flqrgnkx, then the first row
# would be given by the bits of the knot hash of flqrgnkx-0, the second row from the bits of the
# knot hash of flqrgnkx-1, and so on until the last row, flqrgnkx-127.
#
# The output of a knot hash is traditionally represented by 32 hexadecimal digits; each of these
# digits correspond to 4 bits, for a total of 4 * 32 = 128 bits. To convert to bits, turn each
# hexadecimal digit to its equivalent binary value, high-bit first: 0 becomes 0000, 1 becomes
# 0001, e becomes 1110, f becomes 1111, and so on; a hash that begins with a0c2017... in
# hexadecimal would begin with 10100000110000100000000101110000... in binary.
#
# Continuing this process, the first 8 rows and columns for key flqrgnkx appear as follows, using
# # to denote used squares, and . to denote free ones:
#
# ##.#.#..-->
# .#.#.#.#
# ....#.#.
# #.#.##.#
# .##.#...
# ##..#..#
# .#...#..
# ##.#.##.-->
# |      |
# V      V
#
# In this example, 8108 squares are used across the entire 128x128 grid.
#
# Given your actual key string, how many squares are used?
#

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day, 2017).chomp

if $DEBUG
  input = 'flqrgnkx'
end

puts "solving day #{day} from input:\n#{input}"

# From Day 10's Knot Hash

def knot_codes(input, row)
  seed = [ 17, 31, 73, 47, 23 ]
  "#{input}-#{row}".each_char.map(&:ord).concat seed
end

def byte_twist(list, lengths)
  size = list.size
  pos = 0
  skip = 0

  64.times do
    lengths.each do |length|
      # print "\n[#{pos},#{length},#{skip}]: #{list.inspect} => " if $DEBUG
      list.rotate!( pos) unless pos.zero?
      list[0, length] = list[0, length].reverse
      list.rotate!(-pos) unless pos.zero?

      # print list.inspect if $DEBUG
      pos = (pos + length + skip) % size
      skip = (skip + 1) % size
      # puts " w/ [#{pos},#{skip}]" if $DEBUG
    end
  end
  list
end

used_squares = 0
full_grid = []                  # eventually a 128x128 grid of {0|1}
(0..127).each do |row|
  sparse_hash = byte_twist((0..255).to_a, knot_codes(input, row))
  dense_hash = sparse_hash.each_slice(16).map {|sl| sl.reduce(:^) }
  # dense_hash.map {|h| "%02x"%h }.join
  full_row = []
  dense_hash.each.with_index do |h,i|
    binary = "%08b"%h
    if $DEBUG && row < 24 && i < 3
      print binary[0,8].tr('01','.#')
    end
    used_squares += binary.count('1')
    full_row.concat binary.each_char.map(&:to_i)
  end
  puts if $DEBUG && row < 24
  full_grid << full_row
end

puts "Part1:", used_squares

# --- Part Two ---
# Now, all the defragmenter needs to know is the number of regions. A region is a group of used
# squares that are all adjacent, not including diagonals. Every used square is in exactly one
# region: lone used squares form their own isolated regions, while several adjacent squares all
# count as a single region.
#
# In the example above, the following nine regions are visible, each marked with a distinct digit:
#
# 11.2.3..-->
# .1.2.3.4
# ....5.6.
# 7.8.55.9
# .88.5...
# 88..5..8
# .8...8..
# 88.8.88.-->
# |      |
# V      V
# Of particular interest is the region marked 8; while it does not appear contiguous in this small
# view, all of the squares marked 8 are connected when considering the whole 128x128 grid. In
# total, in this example, 1242 regions are present.
#
# How many regions are present given your key string?

def neighbors(x,y)
  valid = 0..127
  [[x,y-1],[x,y+1],[x-1,y],[x+1,y]].select {|(h,v)| valid.cover?(h) && valid.cover?(v)}
end

def hvfill(grid, x, y)
  fill = grid[x][y]
  queue = neighbors(x,y)

  until queue.empty?
    x, y = queue.shift
    if grid[x][y] == 1
      grid[x][y] = fill
      queue.concat neighbors(x,y)
    end
  end
end

# puts full_grid.map(&:size) 

regions = 0
x, y = 0, 0 # Starting at full_grid[x=0][y=0]
loop do
  puts "full_grid[#{x}][#{y}]" if $DEBUG
  if full_grid[x][y] == 1       # Finding a 1,
    regions += 1                # * increment regions
    full_grid[x][y] = -regions  # * change it to -regions
    hvfill full_grid, x, y      # * find all connected 1's and also change them to -regions
  end
  # Finding a <1, (original 0 or a region marker <0)
  y += 1                        # * increment y,
  if y == 128                   #   * if y == 128,
    y = 0                       #     reset y=0
    x += 1                      #     and incr. x,
  end
  break if x == 128              #     * if x == 128, stop.
end

puts "Part2:", regions
