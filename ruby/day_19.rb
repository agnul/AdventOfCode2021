require 'set'

I = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
RX = [[1, 0, 0], [0, 0, -1], [0, 1, 0]]
RY = [[0, 0, 1], [0, 1, 0], [-1, 0, 0]]
RZ = [[0, 1, 0], [-1, 0, 0], [0, 0, 1]]

Point3D = Struct.new(:x, :y, :z) do
  def +(other)
    Point3D.new(x + other.x, y + other.y, z + other.z)
  end

  def -(other)
    Point3D.new((x - other.x), y - other.y, z - other.z)
  end

  def distance_squared(other)
    [x - other.x, y - other.y, z - other.z].map { |d| d**2 }.sum
  end

  def dot(vec)
    (vec[0] * x) + (vec[1] * y) + (vec[2] * z)
  end

  def manhattan(other)
    [x - other.x, y - other.y, z - other.z].map(&:abs).sum
  end

  def rotate(r)
    res = []
    r.each do |row|
      res << dot(row)
    end
    Point3D.new(*res)
  end

  def to_s
    "(#{x}, #{y}, #{z})"
  end
end

class Scanner
  attr_reader :id, :beacons, :distances

  def self.parse(lines)
    id = lines.first.scan(/\d+/).first.to_i
    beacons = []
    lines[1..].each do |l|
      coords = l.split(',').map(&:to_i)
      beacons << Point3D.new(*coords)
    end
    Scanner.new(id, beacons)
  end

  def initialize(id, beacons)
    @id = id
    @beacons = beacons
    @distances = {}
    @beacons.combination(2).each do |a, b|
      @distances[a.distance_squared(b)] = [a, b]
    end
  end

  def align_to(ref, rot)
    dist = ref.distances.keys.sort.find_positions { |d| @distances.key?(d) }
    a, b = ref.distances[dist].map { |p| p.rotate(rot) }

    rotations.each do |r|
      rotated = rotate(r)

      c, d = rotated.distances[dist]

      offset = find_position(a, b, c, d)
      return [r, offset] if offset
    end
  end

  def count_overlapping(other)
    mine = Set.new(distances.keys)
    others = Set.new(other.distances.keys)

    (mine & others).size
  end

  def rotate(rot)
    rotated = []
    @beacons.each do |b|
      vec = []
      rot.each_with_index do |r, i|
        vec[i] = b.dot(r)
      end
      rotated << Point3D.new(*vec)
    end
    Scanner.new(id, rotated)
  end

  def find_position(a, b, c, d)
    pos1 = a - c
    pos2 = b - d
    return pos1 if pos1 == pos2

    pos1 = a - d
    pos2 = b - c
    return pos1 if pos1 == pos2

    nil
  end

end

def parse_input(fname)
  lines = File.readlines(fname).map(&:chomp)
  head = 0
  scanners = []
  lines.each_with_index do |ll, i|
    if ll.empty?
      scanners << Scanner.parse(lines[head...i])
      head = i + 1
    end
  end
  scanners << Scanner.parse(lines[head...]) if head < lines.size
  scanners
end

def mul(a, b)
  # A is n * m, B is m * p => C is n * p
  n = a.size
  m = a.first.size
  p = b.first.size
  res = Array.new(n) { Array.new(p) }
  (0...n).each do |i|
    (0...p).each do |j|
      res[i][j] = (0...m).map { |k| (a[i][k] * b[k][j]) }.sum
    end
  end
  res
end

def rotations
  res = Set.new
  (0..3).each do |x|
    (0..3).each do |y|
      (0..3).each do |z|
        r = I
        x.times { r = mul(RX, r) }
        y.times { r = mul(RY, r) }
        z.times { r = mul(RZ, r) }
        res.add(r)
      end
    end
  end
  res
end

Position = Struct.new(:rotation, :translation)

def find_positions(scanners)
  transforms = { 0 => Position.new(I, Point3D.new(0, 0, 0)) }
  until transforms.size == scanners.size
    scanners.combination(2).each do |a, b|
      next unless transforms.key?(a.id) ^ transforms.key?(b.id)
      next unless a.count_overlapping(b) >= 66

      a, b = b, a unless transforms.key?(a.id)

      rot, trans = b.align_to(a, transforms[a.id].rotation)

      transforms[b.id] = Position.new(rot, trans + transforms[a.id].translation)
    end
  end
  transforms
end

def part_one(scanners)
  positions = find_positions(scanners)
  uniq = Set.new(scanners[0].beacons)
  scanners[1..].each do |s|
    rot, trans = *positions[s.id]
    uniq.merge(s.beacons.map { |b| b.rotate(rot) + trans })
  end
  uniq.size
end

def part_two(scanners)
  transforms = find_positions(scanners)
  transforms.keys.combination(2).map { |a, b| transforms[a].translation.manhattan(transforms[b].translation) }.max
end

test_scanners = parse_input('../inputs/day_19_test.txt')
puts "#{part_one(test_scanners)}, #{part_two(test_scanners)}"

scanners = parse_input('../inputs/day_19.txt')
puts "#{part_one(scanners)}, #{part_two(scanners)}"
