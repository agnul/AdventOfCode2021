def parse_input(fname)
  File.readlines(fname).collect do |line|
    dir, count = line.split
    [dir.to_sym, count.to_i]
  end
end

def part_one(directions)
  pos = 0
  depth = 0
  directions.each do |dir, count|
    pos += count if dir == :forward
    depth += count if dir == :down
    depth -= count if dir == :up
  end
  pos * depth
end

def part_two(directions)
  pos = 0
  depth = 0
  aim = 0
  directions.each do |dir, count|
    if dir == :forward
      pos += count
      depth += aim * count
    end
    aim += count if dir == :down
    aim -= count if dir == :up
  end
  pos * depth
end

directions = parse_input('../inputs/day_02.txt')
puts "#{part_one(directions)}, #{part_two(directions)}"
