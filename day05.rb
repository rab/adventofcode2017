# --- Day 5: A Maze of Twisty Trampolines, All Alike ---
#
# An urgent interrupt arrives from the CPU: it's trapped in a maze of jump instructions, and it
# would like assistance from any programs with spare cycles to help find the exit.
#
# The message includes a list of the offsets for each jump. Jumps are relative: -1 moves to the
# previous instruction, and 2 skips the next one. Start at the first instruction in the list. The
# goal is to follow the jumps until one leads outside the list.
#
# In addition, these instructions are a little strange; after each jump, the offset of that
# instruction increases by 1. So, if you come across an offset of 3, you would move three
# instructions forward, but change it to a 4 for the next time it is encountered.
#
# For example, consider the following list of jump offsets:
#
# 0
# 3
# 0
# 1
# -3
#
# Positive jumps ("forward") move downward; negative jumps move upward. For legibility in this example, these offset values will be written all on one line, with the current instruction marked in parentheses. The following steps would be taken before an exit is found:
#
#
# (0) 3  0  1  -3  - before we have taken any steps.
# (1) 3  0  1  -3  - jump with offset 0 (that is, don't jump at all). Fortunately, the instruction is then incremented to 1.
#  2 (3) 0  1  -3  - step forward because of the instruction we just modified. The first instruction is incremented again, now to 2.
#  2  4  0  1 (-3) - jump all the way to the end; leave a 4 behind.
#  2 (4) 0  1  -2  - go back to where we just were; increment -3 to -2.
#  2  5  0  1  -2  - jump 4 steps forward, escaping the maze.
#
# In this example, the exit is reached in 5 steps.
#
# How many steps does it take to reach the exit?
#

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day, 2017)

# puts "solving day #{day} from input:\n#{input}"

maze = input.each_line.map(&:to_i)
# maze = [ 0,3,0,1,-3 ]
position = 0
trapped = 0...maze.size
jumps = 0

begin
  jump = maze[position]
  maze[position] += 1
  position += jump
  jumps += 1
end while trapped === position

puts "Part1:", jumps

# --- Part Two ---
#
# Now, the jumps are even stranger: after each jump, if the offset was three or more, instead
# decrease it by 1. Otherwise, increase it by 1 as before.
#
# Using this rule with the above example, the process now takes 10 steps, and the offset values
# after finding the exit are left as 2 3 2 3 -1.
#
# How many steps does it now take to reach the exit?

maze = input.each_line.map(&:to_i)
# maze = [ 0,3,0,1,-3 ]
position = 0
trapped = 0...maze.size
jumps = 0

begin
  jump = maze[position]
  if jump >= 3
    maze[position] -= 1
  else
    maze[position] += 1
  end
  position += jump
  jumps += 1
end while trapped === position

puts "Part2:", jumps
