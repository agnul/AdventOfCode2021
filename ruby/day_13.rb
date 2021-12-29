def parse_input(fname)
  lines = File.readlines(fname).map(&:chomp)
  paper = {}
  folds = []
  lines.each do |l|
    /^(\d+),(\d+)$/.match(l) do |m|
      paper[[m[1].to_i, m[2].to_i]] = true
      next
    end
    /fold along ([xy])=(\d+)/.match(l) do |m|
      folds << [m[1], m[2].to_i]
    end
  end
  [paper, folds]
end

def fold_x(paper, fold)
  moved = []
  deleted = []
  paper.each_key do |k|
    x, y = k
    if x > fold
      deleted << k
      moved << [(2 * fold) - x, y]
    end
  end
  moved.each { |m| paper[m] = true }
  deleted.each { |d| paper.delete(d) }
end

def fold_y(paper, fold)
  moved = []
  deleted = []
  paper.each_key do |k|
    x, y = k
    if y > fold
      deleted << k
      moved << [x, (2 * fold) - y]
    end
  end
  moved.each { |m| paper[m] = true }
  deleted.each { |d| paper.delete(d) }
end

def print(paper)
  max_x = paper.keys.map { |x, _| x }.max
  max_y = paper.keys.map { |_, y| y }.max
  (0..max_y).each do |y|
    row = ''
    (0..max_x).each do |x|
      row << (paper.key?([x, y]) ? '#' : ' ')
    end
    puts row
  end
end

def part_one(paper, folds)
  axis, fold = folds.first
  fold_x(paper, fold) if axis == 'x'
  fold_y(paper, fold) if axis == 'y'
  paper.values.size
end

def part_two(paper, folds)
  folds.each do |f|
    axis, fold = f
    fold_x(paper, fold) if axis == 'x'
    fold_y(paper, fold) if axis == 'y'
  end
  print(paper)
end

test_paper, test_folds = parse_input('../inputs/day_13_test.txt')
puts part_one(test_paper, test_folds)
part_two(test_paper, test_folds)

paper, folds = parse_input('../inputs/day_13.txt')
puts part_one(paper, folds)
part_two(paper, folds)
