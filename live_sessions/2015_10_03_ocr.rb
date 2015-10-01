require 'pry'

class OCR
  DIGITS = {
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

  def convert
    lines = @text.split("\n\n")

    lines.map do |numbers|
      rows = numbers
        .split("\n")
        .map { |row| fix_padding(row).scan(/.{1,3}/) }
      
      digits = rows[0]
        .zip(rows[1])
        .zip(rows[2])
        .map(&:flatten)
        .map(&:join)
  
      digits
        .map { |number_string| DIGITS[number_string] || '?' }
        .join
    end.join(',')
  end

  private

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

