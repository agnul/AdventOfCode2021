class Point
  attr_reader :x, :y

  def initialize(str)
    @x, @y = str.split(',').map(&:to_i)
  end
end

class Segment
  def initialize(seg)
    @from, @to = seg.split('->').map { |p| Point.new(p) }
    @dx = (@to.x - @from.x) <=> 0
    @dy = (@to.y - @from.y) <=> 0
  end

  def straight?
    @dx.zero? || @dy.zero?
  end

  def draw(canvas, part_two: false)
    return unless straight? || part_two

    x = @from.x
    y = @from.y
    canvas[[x, y]] += 1
    until x == @to.x && y == @to.y
      x += @dx
      y += @dy
      canvas[[x, y]] += 1
    end
  end
end

def parse_input(fname)
  File.readlines(fname).map(&:chomp).map { |l| Segment.new(l) }
end

def part_one(segments)
  canvas = Hash.new(0)
  segments.each { |s| s.draw(canvas) }
  canvas.values.count { |p| p > 1 }
end

def part_two(segments)
  canvas = Hash.new(0)
  segments.each { |s| s.draw(canvas, part_two: true) }
  canvas.values.count { |p| p > 1 }
end

segments = parse_input('../inputs/day_05.txt')
puts "#{part_one(segments)}, #{part_two(segments)}"
