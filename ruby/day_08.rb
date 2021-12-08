def part_one(lines)
  wires = []
  display = []
  lines.map do |l|
    w, d = l.split('|')
    wires += w.split
    display += d.split
  end
  display.count { |d| [2, 4, 3, 7].include? d.size }
end

lines = File.readlines('../inputs/day_08.txt').map(&:chomp)
puts "#{part_one(lines)}"
