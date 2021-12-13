require 'set'

TWO_SEGMENTS = 2
THREE_SEGMENTS = 3
FOUR_SEGMENTS = 4
FIVE_SEGMENTS = 5
SIX_SEGMENTS = 6
SEVEN_SEGMENTS = 7
KNOWN_DIGIT_SIZES = [2, 3, 4, 7]

Display = Struct.new(:signals, :digits)

def parse_input(fname)
  displays = []
  File.readlines(fname).map(&:chomp).each do |line|
    left, right = line.split('|')
    signals = left.split.map { |sig| Set.new(sig.chars) }
    digits = right.split.map { |dgt| Set.new(dgt.chars) }

    displays << Display.new(signals, digits)
  end
  displays
end

def bin_signals(display)
  bins = Hash.new { |_, _| [] }
  (TWO_SEGMENTS..SEVEN_SEGMENTS).each do |seg_count|
    bins[seg_count] += display.signals.filter { |d| d.size == seg_count }
  end
  bins
end

def find_wiring(bins)
  wiring = {
    1 => bins[TWO_SEGMENTS].first,
    4 => bins[FOUR_SEGMENTS].first,
    7 => bins[THREE_SEGMENTS].first,
    8 => bins[SEVEN_SEGMENTS].first
  }
  wiring[6] = find_six(bins)
  wiring[9] = find_nine(bins)
  wiring[0] = (bins[SIX_SEGMENTS] - [wiring[6], wiring[9]]).first
  wiring[3] = find_three(bins)
  wiring[2] = find_two(bins)
  wiring[5] = (bins[FIVE_SEGMENTS] - [wiring[3], wiring[2]]).first
  wiring
end

def find_six(bins)
  one = bins[TWO_SEGMENTS].first
  bins[SIX_SEGMENTS].find { |s| (one & s).size  == 1 }
end

def find_nine(bins)
  four = bins[FOUR_SEGMENTS].first
  bins[SIX_SEGMENTS].find { |s| (four & s).size == 4 }
end

def find_three(bins)
  one = bins[TWO_SEGMENTS].first
  bins[FIVE_SEGMENTS].find { |s| (one & s).size == 2 }
end

def find_two(bins)
  four = bins[FOUR_SEGMENTS].first
  bins[FIVE_SEGMENTS].find { |s| (four & s).size == 2 }
end

def decode(display, wiring)
  display.reduce(0) { |num, digit| (num * 10) + wiring.key(digit) }
end

def part_one(displays)
  displays.sum { |display| display.digits.count { |d| KNOWN_DIGIT_SIZES.include? d.size } }
end

def part_two(displays)
  displays.reduce(0) do |sum, display|
    bins = bin_signals(display)
    wiring = find_wiring(bins)
    sum + decode(display.digits, wiring)
  end
end

test_displays = parse_input('../inputs/day_08_test.txt')
puts "#{part_one(test_displays)}, #{part_two(test_displays)}"

displays = parse_input('../inputs/day_08.txt')
puts "#{part_one(displays)}, #{part_two(displays)}"
