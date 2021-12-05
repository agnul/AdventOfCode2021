def parse_input(fname)
  File.readlines(fname).collect { |l| l.chomp.to_i(2) }
end

def count_ones(words, bit)
  words.count { |w| (w & bit).positive? }
end

def select_by(words, word_size, cond)
  hi_bit = 1 << (word_size - 1)
  selected = words.dup
  (0...word_size).each do |i|
    bit = hi_bit >> i
    ones = count_ones(selected, bit)
    if cond.call(ones, selected.length)
      selected.keep_if { |r| (r & bit).positive? }
    else
      selected.keep_if { |r| (r & bit).zero? }
    end
    break unless selected.length > 1
  end
  selected[0]
end

def part_one(words, word_size)
  half = words.length / 2
  hi_bit = 1 << (word_size - 1)
  gamma = 0
  epsilon = 1
  (0...word_size).each do |i|
    bit = hi_bit >> i
    c = count_ones(words, bit)
    if c > half
      gamma |= bit
    else
      epsilon |= bit
    end
  end
  gamma * epsilon
end

def part_two(words, word_size)
  most_common = ->(ones, count) { ones >= (count + 1) / 2 }
  least_common = ->(ones, count) { ones < (count + 1) / 2 }
  oxy = select_by(words, word_size, most_common)
  co2 = select_by(words, word_size, least_common)
  oxy * co2
end

test_words = %w[00100 11110 10110 10111 10101 01111 00111 11100 10000 11001 00010 01010].map { |n| n.to_i(2) }
puts "#{part_one(test_words, 5)}, #{part_two(test_words, 5)}"

words = parse_input('../inputs/day_03.txt')
puts "#{part_one(words, 12)}, #{part_two(words, 12)}"
