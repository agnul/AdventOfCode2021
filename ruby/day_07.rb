def simple_cost(from, to)
  (to - from).abs
end

def compound_cost(from, to)
  n = (to - from).abs
  n * (n + 1) / 2
end

def min_cost(subs, cost_fn)
  min, max = subs.minmax
  (min..max).map { |to| subs.sum { |from| method(cost_fn).call(from, to) } }.min
end

def part_one(subs)
  min_cost(subs, :simple_cost)
end

def part_two(subs)
  min_cost(subs, :compound_cost)
end

test_subs = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]
puts "#{part_one(test_subs)}, #{part_two(test_subs)}"

subs = File.readlines('../inputs/day_07.txt')[0].split(',').map(&:to_i)
puts "#{part_one(subs)}, #{part_two(subs)}"
