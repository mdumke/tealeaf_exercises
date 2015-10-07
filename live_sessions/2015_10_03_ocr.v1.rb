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
    @text
      .split("\n\n")
      .map { |line| decode_digits(parse_text(line)) }
      .join(',')
  end

  private

  # returns an array of strings, each one representing a single digit
  def parse_text(text)
    row1, row2, row3 = rows_in_triples(text)

    row1.zip(row2, row3).map(&:join)
  end

  # returns an array of rows, each broken into substrings of length 3
  def rows_in_triples(text)
    rows = text.split("\n")

    max_length = rows.map(&:length).max

    rows.map do |row|
      # add padding to fix row-length if necessary
      row += ' ' * (max_length - row.size)
      row.scan(/.{3}/)
    end
  end

  # returns a string of digits and/or '?'
  def decode_digits(encoded_digits)
    encoded_digits
      .map { |str| DIGIT_PATTERNS[str] || '?' }
      .join
  end
end
