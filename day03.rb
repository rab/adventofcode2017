# --- Day 3: Spiral Memory ---
#
# You come across an experimental new kind of memory stored on an infinite two-dimensional grid.
#
# Each square on the grid is allocated in a spiral pattern starting at a location marked 1 and
# then counting up while spiraling outward. For example, the first few squares are allocated like
# this:
#
# 17  16  15  14  13
# 18   5   4   3  12
# 19   6   1   2  11
# 20   7   8   9  10
# 21  22  23---> ...
#
# While this is very space-efficient (no squares are skipped), requested data must be carried back
# to square 1 (the location of the only access port for this memory system) by programs that can
# only move up, down, left, or right. They always take the shortest path: the Manhattan Distance
# between the location of the data and square 1.
#
# For example:
#
# Data from square 1 is carried 0 steps, since it's at the access port.
# Data from square 12 is carried 3 steps, such as: down, left, left.
# Data from square 23 is carried only 2 steps: up twice.
# Data from square 1024 must be carried 31 steps.
#
# How many steps are required to carry the data from the square identified in your puzzle input
# all the way to the access port?
#

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = 289326 # Input.for_day(day, 2017)

puts "solving day #{day} from input:\n#{input}"

tests = { 1 => 0, 12 => 3, 23 => 2, 1024 => 31 }

def steps_for(location)
  minimum = Math.sqrt(location).ceil.to_i/2
  ring = minimum*2+1
  # maximum = minimum + ring/2
  # [minimum, ring, maximum]
  edge_centers(ring).map {|c| (location - c).abs }.min + minimum
end

def edge_centers(ring)
  lr = ring**2
  ll = lr - ring + 1
  ul = ll - ring + 1
  ur = ul - ring + 1
  [ur, ul, ll, lr].map {|_| _-ring/2 }
end

tests.each do |location,expected|
  print "From #{location}, expected #{expected}"
  if (actual = steps_for(location)) == expected
    puts " √"
  else
    puts ", but got #{actual}"
  end
end

puts "Part1: ", steps_for(input)

# --- Part Two ---

# As a stress test on the system, the programs here clear the grid and then store the value 1 in
# square 1. Then, in the same allocation order as shown above, they store the sum of the values in
# all adjacent squares, including diagonals.

# So, the first few squares' values are chosen as follows:

# Square 1 starts with the value 1.
# Square 2 has only one adjacent filled square (with value 1), so it also stores 1.
# Square 3 has both of the above squares as neighbors and stores the sum of their values, 2.
# Square 4 has all three of the aforementioned squares as neighbors and stores the sum of their values, 4.
# Square 5 only has the first and fourth squares as neighbors, so it gets the value 5.

# Once a square is written, its value does not change. Therefore, the first few squares would
# receive the following values:

# 147  142  133  122   59
# 304    5    4    2   57
# 330   10    1    1   54
# 351   11   23   25   26
# 362  747  806 '880' '931' --->   ...

# What is the first value written that is larger than your puzzle input?

# Your puzzle input is still 289326.

def expand!(original)
  from = original.size
  original.map! {|row|
    row.unshift 0
    row << 0
  }
  original.unshift(Array.new(from+2) {0})
  original << Array.new(from+2) {0}
end

# starting from the position at the right edge of zeroes and the penultimate row, move up and
# around counter-clockwise filling in with sums, stopping with the first sum exceeding target. If
# the last zero is filled, expand the grid and recurse.
def fill_until(grid, target)
  limit = grid.size - 1
  row, column = limit - 1, limit
  # Four sides to do:
  # a b c
  # d • e
  # f g h

  # Right:
  row.downto(0) do |x|
    grid[x][limit] = [
      grid[x-1][limit-1].to_i, # a
      grid[x-1][limit  ].to_i, # b
      # grid[x-1][limit+1].to_i, # c
      grid[x  ][limit-1].to_i, # d
      # grid[x  ][limit+1].to_i, # e
      grid[x+1][limit-1].to_i, # f
      grid[x+1][limit  ].to_i, # g
      # grid[x+1][limit+1].to_i, # h
    ].sum
    return grid[x][limit] if grid[x][limit] > target
  end

  # a b c
  # d • e
  # f g h
  # Top:
  (column-1).downto(0) do |y|
    grid[0][y] = [
      # grid[0-1][y-1].to_i, # a
      # grid[0-1][y  ].to_i, # b
      # grid[0-1][y+1].to_i, # c
      # y.zero? ? 0 : grid[0  ][y-1].to_i, # d
      grid[0  ][y+1].to_i, # e
      y.zero? ? 0 : grid[0+1][y-1].to_i, # f
      grid[0+1][y  ].to_i, # g
      grid[0+1][y+1].to_i, # h
    ].sum
    return grid[0][y] if grid[0][y] > target
  end

  # a b c
  # d • e
  # f g h
  # Left:
  1.upto(limit) do |x|
    grid[x][0] = [
      # grid[x-1][0-1].to_i, # a
      grid[x-1][0  ].to_i, # b
      grid[x-1][0+1].to_i, # c
      # grid[x  ][0-1].to_i, # d
      grid[x  ][0+1].to_i, # e
      # 0.zero? ? x : grid[x+1][0-1].to_i, # f
      # grid[x+1][0  ].to_i, # g
      x == limit ? 0 : grid[x+1][0+1].to_i, # h
    ].sum
    return grid[x][0] if grid[x][0] > target
  end

  # a b c
  # d • e
  # f g h
  # Bottom:
   1.upto(limit) do |y|
    grid[limit][y] = [
      y.zero? ? 0 : grid[limit-1][y-1].to_i, # a
      grid[limit-1][y  ].to_i, # b
      grid[limit-1][y+1].to_i, # c
      y.zero? ? 0 : grid[limit  ][y-1].to_i, # d
      # grid[limit  ][y+1].to_i, # e
      # grid[limit+1][y-1].to_i, # f
      # grid[limit+1][y  ].to_i, # g
      # grid[limit+1][y+1].to_i, # h
    ].sum
    return grid[limit][y] if grid[limit][y] > target
  end

  expand! grid
  return fill_until(grid, target)
end

require 'pp'
# pp grid

# pp expand!(grid)

# 147  142  133  122   59
# 304    5    4    2   57
# 330   10    1    1   54
# 351   11   23   25   26
# 362  747  806 '880' '931' --->   ...

# 1.upto(100) do |target|
#   grid = [[1]]
#   expand! grid
#   puts "\nexpecting #{target} => #{fill_until(grid, target)}"
#   pp grid
# end

grid = [[1]]
expand! grid
puts "Part2: ", fill_until(grid, input)
