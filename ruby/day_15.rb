require 'set'
require './priority_queue'

def parse_input(fname)
  lines = File.readlines(fname).map(&:chomp)
  lines.reduce([]) do |grid, line|
    grid << line.chars.map(&:to_i)
  end
end

def neighbours(r, c, rows, cols)
  res = []
  res << [r, c - 1] if c.positive?
  res << [r - 1, c] if r.positive?
  res << [r, c + 1] if c < cols - 1
  res << [r + 1, c] if r < rows - 1
  res
end

def dijkstra(grid)
  rows = grid.size
  cols = grid[0].size
  source = [0, 0]
  destination = [rows - 1, cols - 1]

  distances = Hash.new(1e9)
  distances[source] = 0

  visited = Set[]

  queue = PriorityQueue.new
  queue << Element.new(source, 0)

  until queue.empty?
    node, distance = queue.pop.to_a

    return distance if node == destination

    next if visited.include?(node)

    visited.add(node)

    r, c = node
    neighbours(r, c, rows, cols).each do |n|
      next if visited.include?(n)

      nr, nc = n
      new_distance = distance + grid[nr][nc]
      if new_distance < distances[n]
        distances[n] = new_distance
        queue << Element.new(n, new_distance)
      end
    end
  end
end

def expand(grid)
  width = grid.size
  grid.each_index do |r|
    4.times do
      grid[r] += grid[r][-width..].map { |v| v < 9 ? v + 1 : 1 }
    end
  end
  4.times do
    grid += grid[-width..].map { |r| r.map { |v| v < 9 ? v + 1 : 1 } }
  end
  grid
end

def part_one(grid)
  dijkstra(grid)
end

def part_two(grid)
  large_grid = expand(grid)
  dijkstra(large_grid)
end

test_grid = parse_input('../inputs/day_15_test.txt')
puts "#{part_one(test_grid)}, #{part_two(test_grid)}"

grid = parse_input('../inputs/day_15.txt')
puts "#{part_one(grid)}, #{part_two(grid)}"
