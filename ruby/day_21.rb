def roll(pos, score, rolls)
  middle = (rolls - 1) % 100
  pos = (pos + (middle * 3)) % 10
  score += pos.zero? ? 10 : pos
  [pos, score]
end

def play_deterministic(pos_a, pos_b)
  score_a = 0
  score_b = 0
  rolls = 0
  while score_a < 1000 && score_b < 1000
    rolls += 3
    pos_a, score_a = roll(pos_a, score_a, rolls)
    break unless score_a < 1000

    rolls += 3
    pos_b, score_b = roll(pos_b, score_b, rolls)
  end
  [rolls, score_a, score_b]
end

DIRAC_ROLLS = {
  3 => 1, 4 => 3, 5 => 6,
  6 => 7, 7 => 6, 8 => 3,
  9 => 1
}

def play_dirac(pos_a, score_a, pos_b, score_b, cache = {})
  return [1, 0] if score_a >= 21
  return [0, 1] if score_b >= 21

  wins_a = 0
  wins_b = 0

  DIRAC_ROLLS.each do |roll, permutations|
    new_pos_a = (pos_a + roll) % 10
    new_score_a = score_a + (new_pos_a.zero? ? 10 : new_pos_a)

    unless cache.key?([pos_b, score_b, new_pos_a, new_score_a])
      cache[[pos_b, score_b, new_pos_a, new_score_a]] = play_dirac(pos_b, score_b, new_pos_a, new_score_a, cache)
    end

    other, mine = cache[[pos_b, score_b, new_pos_a, new_score_a]]

    wins_a += permutations * mine
    wins_b += permutations * other
  end
  [wins_a, wins_b]
end

def part_one(pos_a, pos_b)
  rolls, score_a, score_b = play_deterministic(pos_a, pos_b)
  rolls * (score_a < 1000 ? score_a : score_b)
end

def part_two(pos_a, pos_b)
  wins_a, wins_b = play_dirac(pos_a, 0, pos_b, 0)
  wins_a > wins_b ? wins_a : wins_b
end

puts "#{part_one(4, 8)}, #{part_two(4, 8)}"
puts "#{part_one(7, 3)}, #{part_two(7, 3)}"
