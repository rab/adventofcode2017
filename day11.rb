# --- Day 11: Hex Ed ---
#
# Crossing the bridge, you've barely reached the other side of the stream when a program comes up
# to you, clearly in distress.  "It's my child process," she says, "he's gotten lost in an
# infinite grid!"
#
# Fortunately for her, you have plenty of experience with infinite grids.
#
# Unfortunately for you, it's a hex grid.
#
# The hexagons ("hexes") in this grid are aligned such that adjacent hexes can be found to the
# north, northeast, southeast, south, southwest, and northwest:
#
#   \ n  /
# nw +--+ ne
#   /    \
# -+      +-
#   \    /
# sw +--+ se
#   / s  \
#
# You have the path the child process took. Starting where he started, you need to determine the
# fewest number of steps required to reach him. (A "step" means to move from the hex you are in to
# any adjacent hex.)
#
# For example:
#
# ne,ne,ne is 3 steps away.
# ne,ne,sw,sw is 0 steps away (back where you started).
# ne,ne,s,s is 2 steps away (se,se).
# se,sw,se,sw,sw is 3 steps away (s,s,sw).
#

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day, 2017).strip

# puts "solving day #{day} from input:\n#{input}"

class Step
  TRANSLATE = {
    # d  => [ a, b, c],
    'n'  => [ 1, 0, 0],
    'ne' => [ 0, 0,-1],
    'se' => [ 0, 1 ,0],
    's'  => [-1, 0, 0],
    'sw' => [ 0, 0, 1],
    'nw' => [ 0,-1, 0],
  }

  def self.from_dir(dir)
    puts "from_dir(#{dir.inspect})" if $DEBUG
    new(* TRANSLATE[dir])
  end

  def initialize(a, b, c)
    @a, @b, @c = a, b, c
  end
  attr_reader :a, :b, :c

  def +(other)
    if other.is_a?(Step)
      self.class.new(a + other.a, b + other.b, c + other.c)
    else
      self + Step.new(other)
    end
  end

  def simple
    t = [@a, @b, @c].min
    [@a, @b, @c].map {|d| d - t }.max
  end

  def to_s
    "Step<#{a},#{b},#{c}>"
  end
end

raw = input.split(/,/).map {|dir| Step.from_dir(dir) }

puts "Part1:", raw.reduce(:+).simple

current, max = Step.new(0,0,0), 0
raw.each do |step|
  current += step
  max = [max, current.simple].max
end

puts "Part2:", max
