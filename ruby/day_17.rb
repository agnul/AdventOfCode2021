def parse_input(fname)
  bounds = File.readlines(fname).map(&:chomp).first
  x_min, x_max, y_min, y_max = bounds.scan(/-?\d+/).map(&:to_i)
  [(x_min..x_max), (y_min..y_max)]
end

# Dumb way to get the largest triangular number less than x_range.min
# Integer.sqrt(2 * x_range.min) would work too.
def min_vx(x_range)
  vx = 0
  vx += 1 until (vx * (vx + 1) / 2) >= x_range.min
  vx
end

def hit?(v0_x, v0_y, x_range, y_range)
  x = 0
  y = 0
  vx = v0_x
  vy = v0_y
  while x <= x_range.max && y >= y_range.min
    return true if x >= x_range.min && y <= y_range.max

    x += vx
    y += vy

    vx -= 1 if vx.positive?
    vy -= 1
  end
  false
end

def part_one(_, y_range)
  # Because of math
  y_range.min * (y_range.min + 1) / 2
end

def part_two(x_range, y_range)
  count = 0
  (min_vx(x_range)..x_range.max).each do |v0_x|
    (y_range.min..-y_range.min).each do |v0_y|
      count += 1 if hit?(v0_x, v0_y, x_range, y_range)
    end
  end
  count
end

x_range, y_range = parse_input('../inputs/day_17.txt')
# puts part_two(20..30, -10..-5)
puts "#{part_one(x_range, y_range)}, #{part_two(x_range, y_range)}"
