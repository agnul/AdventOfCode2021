def evolve(population, days)
  register = []
  (0..8).each { |i| register << population.count(i) }
  days.times do
    register.rotate!(1)
    register[6] += register[-1]
  end
  register.sum
end

def part_one(population)
  evolve(population, 80)
end

def part_two(population)
  evolve(population, 256)
end

test_population = [3, 4, 3, 1, 2]
puts "#{part_one(test_population)}, #{part_two(test_population)}"

population = File.readlines('../inputs/day_06.txt')[0].split(',').map(&:to_i)
puts "#{part_one(population)}, #{part_two(population)}"
