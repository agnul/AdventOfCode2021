DELIMITER_PAIRS = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }
POINTS_FOR_CHECK = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25_137 }
POINTS_FOR_AUTOCOMPLETE = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }

def opening?(delim)
  DELIMITER_PAIRS.keys.include?(delim)
end

def closing?(delim)
  DELIMITER_PAIRS.values.include?(delim)
end

def syntax_check(line)
  stack = []
  line.chars.each_with_index do |delim, idx|
    if opening?(delim)
      stack.push(delim)
    elsif closing?(delim) && DELIMITER_PAIRS[stack[-1]] == delim
      stack.pop
    else
      return [stack, line.chars[(idx..)]]
    end
  end
  [stack, []]
end

def auto_complete(stack)
  stack.reverse.reduce(0) { |score, tag| score * 5 + POINTS_FOR_AUTOCOMPLETE[DELIMITER_PAIRS[tag]] }
end

def part_one(lines)
  lines.collect { |l| syntax_check(l) }.filter { |_, rest| !rest.empty? }.sum { |_, rest| POINTS_FOR_CHECK[rest[0]] }
end

def part_two(lines)
  scores = lines.collect { |l| syntax_check(l) }.filter { |_, rest| rest.empty? }.collect { |open, _| auto_complete(open) }.sort
  scores[scores.size / 2]
end

test_lines = File.readlines('../inputs/day_10_test.txt').map(&:chomp)
puts "#{part_one(test_lines)}, #{part_two(test_lines)}"

lines = File.readlines('../inputs/day_10.txt').map(&:chomp)
puts "#{part_one(lines)}, #{part_two(lines)}"
