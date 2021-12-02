def parse_input(fname)
  File.readlines(fname).collect do |l|
    d, c = l.split
    [d.to_sym, c.to_i]
  end
end

def part_one(directions)
  x = 0
  y = 0
  directions.each do |d, c|
    x += c if d == :forward
    y += c if d == :down
    y -= c if d == :up
  end
  x * y
end

def part_two(directions)
  x = 0
  y = 0
  aim = 0
  directions.each do |d, c|
    if d == :forward
      x += c
      y += aim * c
    end
    aim += c if d == :down
    aim -= c if d == :up
  end
  x * y
end

directions = parse_input('data/2.txt')
puts "#{part_one(directions)}, #{part_two(directions)}"
