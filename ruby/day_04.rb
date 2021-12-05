class BingoCard
  def initialize(rows)
    @numbers = {}
    @not_crossed = []
    @row_crosses = [0] * 5
    @col_crosses = [0] * 5

    rows.each_with_index do |row, i|
      row.split.each_with_index do |num, j|
        @numbers[num.to_i] = [i, j]
        @not_crossed << num.to_i
      end
    end
  end

  def cross(num)
    return unless @numbers.key?(num)

    i, j = @numbers[num]
    @not_crossed.delete(num)
    @row_crosses[i] += 1
    @col_crosses[j] += 1
  end

  def bingo?
    @row_crosses.count(5).positive? || @col_crosses.count(5).positive?
  end

  def score(last_number)
    last_number * @not_crossed.sum
  end

  def reset!
    @not_crossed = @numbers.keys
    @row_crosses = [0] * 5
    @col_crosses = [0] * 5
  end
end

def parse_input(fname)
  lines = File.readlines(fname)
  calls = lines[0].chomp.split(',').map(&:to_i)
  rows = []
  cards = []
  lines[2..].each do |line|
    rows << line
    if line.chomp.empty?
      cards << BingoCard.new(rows)
      rows.clear
    end
  end
  [calls, cards]
end

def part_one(numbers, cards)
  cards.each(&:reset!)
  numbers.each do |n|
    cards.each do |c|
      c.cross(n)
      return c.score(n) if c.bingo?
    end
  end
end

def part_two(numbers, cards)
  cards.each(&:reset!)
  scores = []
  numbers.each do |n|
    cards.each do |c|
      unless c.bingo?
        c.cross(n)
        scores << c.score(n) if c.bingo?
      end
    end
  end
  scores[-1]
end

numbers, cards = parse_input('../inputs/day_04.txt')

puts "#{part_one(numbers, cards)}, #{part_two(numbers, cards)}"
