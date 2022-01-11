def next_explosion(num)
  depth = 0
  (0...num.size).each do |i|
    case num[i]
    when '['
      depth += 1
    when ']'
      depth -= 1
    when /\d+/
      return i if depth > 4
    end
  end
  nil
end

def explode(num, pos)
  m = /(\d+),(\d+)/.match(num[pos..])
  return num unless m

  a, b = m[1..].map(&:to_i)
  pre = num[0, pos - 1].sub(/(\d+)(\D+)$/) { |_| "#{$1.to_i + a}#{$2}" }
  post = m.post_match[1..].sub(/(\D+)(\d+)/) { |_| "#{$1}#{$2.to_i + b}" }

  "#{pre}0#{post}"
end

def next_split(num)
  num =~ /\d{2,}/
end

def split(num, pos)
  match = /\d{2}/.match(num, pos)
  n = match[0].to_i
  q, r = n.divmod(2)
  "#{match.pre_match}[#{q},#{q + r}]#{match.post_match}"
end

def add(a, b)
  "[#{a},#{b}]"
end

def sf_reduce(num)
  while true
    if (nx = next_explosion(num))
      num = explode(num, nx)
    elsif (ns = next_split(num))
      num = split(num, ns)
    else
      break
    end
  end
  num
end

def magnitude(num)
  while (m = num.match(/\[(\d+),(\d+)\]/))
    l, r = m[1..].map(&:to_i)
    num = num.sub(/\[(\d+),(\d+)\]/, ((3 * l) + (2 * r)).to_s)
  end
  num
end

def part_one(numbers)
  magnitude(numbers.reduce { |s, n| sf_reduce(add(s, n)) })
end

def part_two(numbers)
  numbers.permutation(2).map { |a, b| magnitude(sf_reduce(add(a, b))).to_i }.max
end

test_numbers = File.readlines('../inputs/day_18_test.txt').map(&:chomp)
puts "#{part_one(test_numbers)}, #{part_two(test_numbers)}"
numbers = File.readlines('../inputs/day_18.txt').map(&:chomp)
puts "#{part_one(numbers)}, #{part_two(numbers)}"
