# --- Day 4: High-Entropy Passphrases ---
#
# A new system policy has been put in place that requires all accounts to use a passphrase instead
# of simply a password. A passphrase consists of a series of words (lowercase letters) separated
# by spaces.
#
# To ensure security, a valid passphrase must contain no duplicate words.
#
# For example:
#
# aa bb cc dd ee is valid.
# aa bb cc dd aa is not valid - the word aa appears more than once.
# aa bb cc dd aaa is valid - aa and aaa count as different words.
#
# The system's full passphrase list is available as your puzzle input. How many passphrases are valid?
#

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day, 2017)

# puts "solving day #{day} from input:\n#{input.count(%{\n})}"

def valid_words?(passphrase)
  words = passphrase.split(' ')
  words.size == words.uniq.size
end

puts "Part1:", input.each_line.select{|_|valid_words?(_)}.size

# --- Part Two ---
#
# For added security, yet another system policy has been put in place. Now, a valid passphrase
# must contain no two words that are anagrams of each other - that is, a passphrase is invalid if
# any word's letters can be rearranged to form any other word in the passphrase.
#
# For example:
#
# abcde fghij is a valid passphrase.
# abcde xyz ecdab is not valid - the letters from the third word can be rearranged to form the first word.
# a ab abc abd abf abj is a valid passphrase, because all letters need to be used when forming another word.
# iiii oiii ooii oooi oooo is valid.
# oiii ioii iioi iiio is not valid - any of these words can be rearranged to form any other word.
#
# Under this new system policy, how many passphrases are valid?

def valid_anagrams?(passphrase)
  words = passphrase.split(' ')
  anagrams = words.map {|_| _.each_char.sort.join }
  words.size == anagrams.uniq.size
end

puts "Part2:", input.each_line.select{|_|valid_anagrams?(_)}.size
