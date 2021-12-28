require 'set'

def parse_input(fname)
  graph = Hash.new { |hash, key| hash[key] = [] }
  File.readlines(fname).map(&:chomp).each do |line|
    a, b = line.split('-')
    graph[a] << b unless b == 'start'
    graph[b] << a unless a == 'start'
  end
  graph
end

def count_paths(graph, start, finish)
  stack = [[start, Set[start]]]
  count = 0
  until stack.empty?
    node, visited = stack.pop
    if node == finish
      count += 1
      next
    end

    graph[node].each do |n|
      next if visited.include?(n) && /^[a-z]+$/ =~ n

      stack << [n, visited | Set[n]]
    end
  end
  count
end

def count_paths_2(graph, start, finish)
  stack = [[start, Set[start], false]]
  count = 0
  until stack.empty?
    node, visited, doubled_back = stack.pop
    if node == finish
      count += 1
      next
    end

    graph[node].each do |n|
      if !visited.include?(n) || /^[A-Z]+$/ =~ n
        stack << [n, visited | Set[n], doubled_back]
        next
      end

      next if doubled_back

      stack << [n, visited, true]
    end
  end
  count
end

def part_one(graph)
  count_paths(graph, 'start', 'end')
end

def part_two(graph)
  count_paths_2(graph, 'start', 'end')
end

test_graph = parse_input('../inputs/day_12_test.txt')
puts "#{part_one(test_graph)}, #{part_two(test_graph)}"

graph = parse_input('../inputs/day_12.txt')
puts "#{part_one(graph)}, #{part_two(graph)}"
