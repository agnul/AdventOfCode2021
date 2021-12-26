Cuboid = Struct.new(:state, :x_range, :y_range, :z_range) do
  def range_intersect(r1, r2)
    new_end = [r1.end, r2.end].min
    new_begin = [r1.begin, r2.begin].max
    exclude_end = (r2.exclude_end? && new_end == r2.end) ||
                  (r1.exclude_end? && new_end == r1.end)

    valid = (new_begin <= new_end && !exclude_end)
    valid ||= (new_begin < new_end && exclude_end)
    valid ? Range.new(new_begin, new_end, exclude_end) : nil
  end

  def intersect(other)
    x = range_intersect(x_range, other.x_range)
    y = range_intersect(y_range, other.y_range)
    z = range_intersect(z_range, other.z_range)

    return nil if x.nil? || y.nil? || z.nil?

    Cuboid.new('on', x, y, z)
  end

  def volume
    x_range.size * y_range.size * z_range.size
  end
end

def parse_range(str)
  min, max = str.split('..').map(&:to_i)
  (min..max)
end

def parse_input(fname)
  File.readlines(fname).reduce([]) do |cuboids, line|
    state, ranges = line.split
    x_range, y_range, z_range = ranges.split(',').map { |r| parse_range(r[2..]) }

    cuboids << Cuboid.new(state, x_range, y_range, z_range)
  end
end

def out_of_range?(cuboid)
  return true if cuboid.x_range.min < -50 || cuboid.x_range.max > 50
  return true if cuboid.y_range.min < -50 || cuboid.y_range.max > 50
  return true if cuboid.z_range.min < -50 || cuboid.z_range.max > 50

  false
end

def disjoint_volume(cuboids)
  disjoint_cuboids = []
  cuboids.each do |new|
    disjoint_cuboids.dup.each do |old|
      if (intersection = new.intersect(old))
        intersection.state = 'off' if old.state == 'on'
        disjoint_cuboids << intersection
      end
    end
    disjoint_cuboids << new if new.state == 'on'
  end
  disjoint_cuboids.reduce(0) { |sum, c| sum + (c.state == 'on' ? c.volume : -c.volume) }
end

def part_one(cuboids)
  disjoint_volume(cuboids.reject { |c| out_of_range?(c) })
end

def part_two(cuboids)
  disjoint_volume(cuboids)
end

test_cuboids = parse_input('../inputs/day_22_test.txt')
puts "#{part_one(test_cuboids)}, #{part_two(test_cuboids)}\n"
cuboids = parse_input('../inputs/day_22.txt')
puts "#{part_one(cuboids)}, #{part_two(cuboids)}\n"
