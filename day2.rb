def parse_input(fname)
  File.readlines(fname).collect(&:chomp)
end

def part_one(directions)
  x, y = 0, 0
  directions.each do |dir|
    d, c = dir.split
    case d
    when 'forward'
      x += c.to_i
    when 'down'
      y += c.to_i
    when 'up'
      y -= c.to_i
    end
  end
  x * y
end

def part_two(directions)
  x, y, aim = 0, 0, 0
  directions.each do |dir|
    d, c = dir.split
    case d
    when 'forward'
      x += c.to_i
      y += aim * c.to_i
    when 'down'
      aim += c.to_i
    when 'up'
      aim -= c.to_i
    end
  end
  x * y
end

directions = parse_input('data/2.txt')
puts "#{part_one(directions)}, #{part_two(directions)}"
