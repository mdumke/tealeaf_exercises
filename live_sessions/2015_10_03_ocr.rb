require 'pry'

class OCR
  DIGIT_PATTERNS = {
    ' _ | ||_|' => '0',
    '     |  |' => '1',
    ' _  _||_ ' => '2',
    ' _  _| _|' => '3',
    '   |_|  |' => '4',
    ' _ |_  _|' => '5',
    ' _ |_ |_|' => '6',
    ' _   |  |' => '7',
    ' _ |_||_|' => '8',
    ' _ |_| _|' => '9'
  }

  def initialize(text)
    @text = text
  end

  # returns a string of digits represented by the text
  def convert
    lines = @text.split("\n\n")
    
    lines
      .map { |number_string| decode_digits(parse_text(number_string)) }
      .join(',')
  end

  private

  # returns an array of strings, each one representing a single digit
  def parse_text(number_string)
    rows_in_triples = number_string
      .split("\n")
      .map { |row| fix_padding(row).scan(/.{3}/) }

    rows_in_triples[0]
      .zip(rows_in_triples[1])
      .zip(rows_in_triples[2])
      .map(&:flatten)
      .map(&:join)
  end

  # returns a string of digits and/or '?'
  def decode_digits(digit_pattern)
    digit_pattern
      .map { |str| DIGIT_PATTERNS[str] || '?' }
      .join
  end

  # adds whitespace until lenght of given string is divisible by 3
  def fix_padding(row)
    return '   ' if row.empty?

    row += case row.size % 3
           when 2 then ' '
           when 1 then '  '
           else ''
           end
  end
end

