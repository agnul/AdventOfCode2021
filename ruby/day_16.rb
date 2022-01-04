Packet = Struct.new(:version, :type, :data) do
  def eval
    case type
    when 0
      data.reduce(0) { |sum, pkt| sum + pkt.eval }
    when 1
      data.reduce(1) { |prod, pkt| prod * pkt.eval }
    when 2
      data.map(&:eval).min
    when 3
      data.map(&:eval).max
    when 4
      data
    when 5
      data.first.eval > data.last.eval ? 1 : 0
    when 6
      data.first.eval < data.last.eval ? 1 : 0
    when 7
      data.first.eval == data.last.eval ? 1 : 0
    else
      raise "Invalid packet type #{type}."
    end
  end
end

class BitStream
  def self.from_bits(bits)
    new(bits)
  end

  def self.from_hex(hex)
    bits = [hex].pack('H*').unpack1('B*')
    new(bits)
  end

  def initialize(bits)
    @bits = bits
    @offset = 0
  end

  def read_packet
    version = decode(3)
    type = decode(3)
    return Packet.new(version, type, literal) if type == 4

    case (id = decode(1))
    when 0
      sub = BitStream.from_bits(read(decode(15)))
      Packet.new(version, type, sub.read_packets)
    when 1
      children = []
      decode(11).times do
        children << read_packet
      end
      Packet.new(version, type, children)
    else
      raise "Invalid type ID #{id}."
    end
  end

  def read_packets
    packets = []
    packets << read_packet until available < 4
    packets
  end

  def literal
    lit = ''
    done = false
    until done
      buf = read(5)
      done = buf[0] == '0'
      lit << buf[1..]
    end
    lit.to_i(2)
  end

  def decode(count)
    read(count).to_i(2)
  end

  def read(count)
    len = count > available ? available : count
    bits = @bits[@offset, len]
    @offset += len
    bits
  end

  def reset!
    @offset = 0
  end

  def available
    @bits.size - @offset
  end
end

def parse_input(fname)
  hex = File.readlines(fname).map(&:chomp).first

  BitStream.from_hex(hex)
end

def sum_versions(packet)
  return packet.version if packet.type == 4

  packet.data.reduce(packet.version) { |sum, pkt| sum + sum_versions(pkt) }
end

def part_one(bits)
  sum_versions(bits.read_packet)
end

def part_two(bits)
  bits.reset!
  bits.read_packet.eval
end

# test_bits = ['D2FE28'].pack('H*').unpack1('B*')
# puts BitStream.new(test_bits).read_packet.inspect

bits = parse_input('../inputs/day_16.txt')
puts "#{part_one(bits)}, #{part_two(bits)}"
