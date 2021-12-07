class BingoCard
  BINGO = 5
  ROWS = (0..4)
  COLS = (0..4)

  def initialize(rows)
    @numbers = {}
    @crossed = [0] * (ROWS.size * COLS.size)

    rows.each_with_index do |row, i|
      row.split.each_with_index do |num, j|
        @numbers[num.to_i] = (i * COLS.size) + j
      end
    end
  end

  def cross(num)
    return unless @numbers.key?(num)

    @crossed[@numbers[num]] = 1
  end

  def bingo?
    horiz = ROWS.any? { |r| @crossed[row(r)].sum == BINGO }
    vert = COLS.any? { |c| @crossed[col(c)].sum == BINGO }
    horiz || vert
  end

  def score(last_number)
    last_number * @numbers.keys.each_with_index.sum { |n, i| @crossed[i].zero? ? n : 0 }
  end

  def reset!
    @crossed = [0] * (ROWS.size * COLS.size)
  end

  private

  def row(r)
    first = r * COLS.size
    last = (r + 1) * COLS.size
    (first...last)
  end

  def col(c)
    (c...(ROWS.size * COLS.size)).step(ROWS.size)
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
