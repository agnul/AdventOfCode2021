def parse_input(fname)
  File.readlines(fname).collect { |l| l.chomp.to_i }
end

def part_one(numbers)
  numbers.each_cons(2).count { |a, b| b > a }
end

def part_two(numbers)
  numbers.each_cons(4).count { |a, _, _, b| b > a }
end

depths = parse_input(File.expand_path('../inputs/day_01.txt'))
# puts part_one([199, 200, 208, 210, 200, 207, 240, 269, 260, 263])
puts(part_one(depths))
# puts part_two([199, 200, 208, 210, 200, 207, 240, 269, 260, 263])
puts(part_two(depths))
