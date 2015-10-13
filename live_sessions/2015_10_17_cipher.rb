require 'pry'

class Cipher
  ASCII_OFFSET = 'a'.ord

  attr_reader :key

  def initialize(key = nil)
    format_check(key)

    @key = key || random_key
  end

  def encode(plaintext)
    plaintext.map { |char, index| encode_char(char, key_for(index)) }
  end

  def decode(ciphertext)
    ciphertext.map { |char, index| decode_char(char, key_for(index)) }
  end

  private

  def encode_char(char, shift)
    ((pos(char) + pos(shift)) % 26 + ASCII_OFFSET).chr
  end

  def decode_char(char, shift)
    ((pos(char) - pos(shift)) % 26 + ASCII_OFFSET).chr
  end

  def format_check(key)
    fail(ArgumentError, 'emtpy key') if key == ''

    msg = 'Key must be all lowercase letters'
    fail(ArgumentError, msg) if key =~ /[A-Z0-9]/

    true
  end

  def key_for(index)
    key[index % key.size]
  end

  def random_key
    100.times.map { rand('a'.ord..'z'.ord).chr }.join
  end

  def pos(character)
    character.ord - ASCII_OFFSET
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
