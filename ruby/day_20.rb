require 'set'

class Image
  def initialize(lines)
    @bits = lines[0]
    @pixels = Set.new
    lines[2..].each_with_index do |l, i|
      l.chars.each_with_index do |c, j|
        @pixels.add([i, j]) if c == '#'
      end
    end
  end

  def bounds
    min_r, max_r = @pixels.map { |coords| coords[0] }.minmax
    min_c, max_c = @pixels.map { |coords| coords[1] }.minmax
    [min_r, max_r, min_c, max_c]
  end

  def enhance!(rounds, debug=false)
    if debug
      puts "Starting image\n"
      print
    end

    background = '.'
    rounds.times do |i|
      do_enhance!(background)
      if debug
        puts "After round #{i}\n"
        print
      end
      background = i.even? ? @bits[0] : @bits[-1]
    end
  end

  def do_enhance!(background)
    new_pixels = Set.new
    min_r, max_r, min_c, max_c = bounds
    (min_r-1..max_r+1).each do |r|
      (min_c-1..max_c+1).each do |c|
        bit = 0
        (r - 1..r + 1).each do |rr|
          (c - 1..c + 1).each do |cc|
            new_bit = if rr < min_r || rr > max_r || cc < min_c || cc > max_r
                        background == '.' ? 0 : 1
                      else
                        @pixels.include?([rr, cc]) ? 1 : 0
                      end
            bit = (bit << 1) + new_bit
          end
        end
        new_pixels.add([r, c]) if @bits[bit] == '#'
      end
    end
    @pixels = new_pixels
  end

  def pixel_count
    @pixels.size
  end

  def print
    min_r, max_r, min_c, max_c = bounds
    (min_r..max_r).each do |r|
      line = ''
      (min_c..max_c).each do |c|
        line << (@pixels.include?([r, c]) ? '#' : '.')
      end
      puts line
    end
  end
end

def parse_input(fname)
  lines = File.readlines(fname).map(&:chomp)

  Image.new(lines)
end

def part_one(image, debug=false)
  image.enhance!(2, debug)
  image.pixel_count
end

def part_two(image)
  image.enhance!(50)
  image.pixel_count
end

test_image = parse_input('../inputs/day_20_test.txt')
puts "#{part_one(test_image, true)}, #{part_two(test_image)}"

image = parse_input('../inputs/day_20.txt')
puts "#{part_one(image)}, #{part_two(image)}"
