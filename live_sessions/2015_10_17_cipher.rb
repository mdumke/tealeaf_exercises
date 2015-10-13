class Cipher
  ASCII_OFFSET = 'a'.ord

  attr_reader :key

  def initialize(key = nil)
    format_check(key)

    @key = key || random_key
  end

  def encode(plaintext)
    plaintext.map { |char, idx| shift_char(char, distance(idx), &:+) }
  end

  def decode(ciphertext)
    ciphertext.map { |char, idx| shift_char(char, distance(idx), &:-) }
  end

  private

  def shift_char(char, distance, &direction)
    (direction.call(alphabet_index(char), distance) % 26 + ASCII_OFFSET).chr
  end

  def distance(index)
    alphabet_index(key[index % key.size])
  end

  def alphabet_index(character)
    character.ord - ASCII_OFFSET
  end

  def random_key
    100.times.collect { [*('a'..'z')].sample }.join
  end

  def format_check(key)
    fail(ArgumentError, 'emtpy key') if key == ''
    fail(ArgumentError, 'No numbers or uppercase letters') if key =~ /[A-Z0-9]/
  end
end

class String
  def map(&block)
    each_char
      .with_index
      .map { |char, index| block.call(char, index) }
      .join
  end
end
