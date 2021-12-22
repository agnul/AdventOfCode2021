Instruction = Struct.new(:cmd, :x_range, :y_range, :z_range)

def parse_range(str)
  min, max = str.split('..').map(&:to_i)
  (min..max)
end

def parse_input(fname)
  File.readlines(fname).reduce([]) do |instructions, line|
    cmd, ranges = line.split
    x_range, y_range, z_range = ranges.split(',').map { |r| parse_range(r[2..]) }

    instructions << Instruction.new(cmd, x_range, y_range, z_range)
  end
end

def out_of_range?(instr)
  return true if instr.x_range.min < -50 || instr.x_range.max > 50
  return true if instr.y_range.min < -50 || instr.y_range.max > 50
  return true if instr.z_range.min < -50 || instr.z_range.max > 50

  false
end

def part_one(boot_sequence)
  cubes = {}
  boot_sequence.each do |instr|
    next if out_of_range?(instr)

    instr.x_range.each do |x|
      instr.y_range.each do |y|
        instr.z_range.each do |z|
          cubes[[x, y, z]] = instr.cmd == 'on' ? 1 : -1
        end
      end
    end
  end
  cubes.values.count(1)
end

boot_sequence = parse_input('../inputs/day_22.txt')
puts part_one(boot_sequence).to_s

