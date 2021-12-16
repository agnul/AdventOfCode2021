def parse_input(fname)
  lines = File.readlines(fname).map(&:chomp)

  template = lines[0]
  rules = {}
  lines[2..].each do |l|
    source, dst = l.split(' -> ')
    rules[source] = dst
  end
  [template, rules]
end

def rewrite(str, rules)
  rewritten = ''
  (str.size - 1).times do |i|
    rewritten << str[i]
    rewritten << rules[str[i, 2]] if rules.key?(str[i, 2])
  end
  rewritten << str[-1]
end

def count_pairs(counts, rules)
  new_counts = Hash.new(0)
  counts.each do |p, c|
    if rules[p]
      new_counts["#{p[0]}#{rules[p]}"] += c
      new_counts["#{rules[p]}#{p[1]}"] += c
    end
  end
  new_counts
end

def part_one(template, rules)
  str = template
  10.times { str = rewrite(str, rules) }
  counts = Hash.new(0)
  str.chars.each { |c| counts[c] += 1 }
  min, max = counts.values.minmax
  max - min
end

def part_two(template, rules)
  pair_counts = Hash.new(0)
  (template.size - 1).times { |i| pair_counts[template[i, 2]] += 1 }
  40.times { pair_counts = count_pairs(pair_counts, rules) }
  counts = Hash.new(0)
  pair_counts.each { |p, c| counts[p[0]] += c }
  counts[template[-1]] += 1
  min, max = counts.values.minmax
  max - min
end

template, rules = parse_input('../inputs/day_14_test.txt')
puts "#{part_one(template, rules)}, #{part_two(template, rules)}"

template, rules = parse_input('../inputs/day_14.txt')
puts "#{part_one(template, rules)}, #{part_two(template, rules)}"
