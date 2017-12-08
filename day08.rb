# --- Day 8: I Heard You Like Registers ---
#
# You receive a signal directly from the CPU. Because of your recent assistance with jump
# instructions, it would like you to compute the result of a series of unusual register
# instructions.
#
# Each instruction consists of several parts: the register to modify, whether to increase or
# decrease that register's value, the amount by which to increase or decrease it, and a
# condition. If the condition fails, skip the instruction without modifying the register. The
# registers all start at 0. The instructions look like this:
#
# b inc 5 if a > 1
# a inc 1 if b < 5
# c dec -10 if a >= 1
# c inc -20 if c == 10
#
# These instructions would be processed as follows:
#
#
# Because a starts at 0, it is not greater than 1, and so b is not modified.
# a is increased by 1 (to 1) because b is less than 5 (it is 0).
# c is decreased by -10 (to 10) because a is now greater than or equal to 1 (it is 1).
# c is increased by -20 (to -10) because c is equal to 10.
#
# After this process, the largest value in any register is 1.
#
# You might also encounter <= (less than or equal to) or != (not equal to). However, the CPU
# doesn't have the bandwidth to tell you what all the registers are named, and leaves that to you
# to determine.
#
# What is the largest value in any register after completing the instructions in your puzzle
# input?
#

require_relative 'input'
require 'pp'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day, 2017)

puts "solving day #{day} from input: #{input.count(%{\n})} instructions"

registers = Hash.new {|h,reg| h[reg] = 0 }
peak = nil
parser = /\A(\w+) (inc|dec) (-?\d+) if (\w+) (<|<=|==|!=|>=|>) (-?\d+)$/
input.each_line(chomp: true) do |instr|
  dreg, op, opval, creg, cmp, cval = parser.match(instr).captures
  cval = cval.to_i
  cmp = cmp.to_sym

  if registers[creg].send(cmp, cval)
    opval = opval.to_i
    case op
    when 'inc'
      registers[dreg] += opval
    when 'dec'
      registers[dreg] -= opval
    else
      raise "Unknown op '#{op}' in: #{instr}"
    end
  end

  maximum = registers.values.max
  if peak.nil? || maximum > peak
    peak = maximum
  end
end

maximum = registers.values.max
puts "Part1: #{registers.key(maximum)} has:", maximum

# --- Part Two ---
#
# To be safe, the CPU also needs to know the highest value held in any register during this
# process so that it can decide how much memory to allocate to these operations. For example, in
# the above instructions, the highest value ever held was 10 (in register c after the third
# instruction was evaluated).

puts "Part2: max value ever:", peak
