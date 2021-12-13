class DepthMap
  attr_reader :rows, :cols

  def initialize(lines)
    @rows = lines.size
    @cols = lines[0].size
    @values = []
    lines.each do |l|
      @values << l.chars.map(&:to_i)
    end
  end

  def at(row, col)
    @values[row][col]
  end

  def flood_fill!(row, col)
    return 0 if @values[row][col] == 9 || @values[row][col] == -1

    @values[row][col] = -1

    size = 1
    size += flood_fill!(row - 1, col) unless row.zero?
    size += flood_fill!(row + 1, col) if row + 1 < @rows
    size += flood_fill!(row, col - 1) unless col.zero?
    size += flood_fill!(row, col + 1) if col + 1 < @cols
    size
  end
end

def parse_input(fname)
  DepthMap.new(File.readlines(fname).map(&:chomp))
end

def local_min?(map, row, col)
  neighbours = [map.at(row, col)]
  neighbours << map.at(row - 1, col) unless row.zero?
  neighbours << map.at(row + 1, col) if row + 1 < map.rows
  neighbours << map.at(row, col - 1) unless col.zero?
  neighbours << map.at(row, col + 1) if col + 1 < map.cols

  map.at(row, col) == neighbours.min && neighbours.sum != (map.at(row, col) * neighbours.size)
end

def part_one(depth_map)
  local_minima = 0
  (0...depth_map.rows).each do |r|
    (0...depth_map.cols).each do |c|
      local_minima += (1 + depth_map.at(r, c)) if local_min?(depth_map, r, c)
    end
  end
  local_minima
end

def part_two(depth_map)
  local_minima = []
  (0...depth_map.rows).each do |r|
    (0...depth_map.cols).each do |c|
      local_minima << [r, c] if local_min?(depth_map, r, c)
    end
  end
  basin_sizes = []
  local_minima.each do |r, c|
    basin_sizes << depth_map.flood_fill!(r, c)
  end
  basin_sizes.sort.last(3).reduce(1) { |p, s| p * s }
end

depth_map = parse_input('../inputs/day_09_test.txt')
puts "#{part_one(depth_map)}, #{part_two(depth_map)}"

depth_map = parse_input('../inputs/day_09.txt')
puts "#{part_one(depth_map)}, #{part_two(depth_map)}"
