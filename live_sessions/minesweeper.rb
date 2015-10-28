class Board
  # adds adjacent-mines-counters to empty fields
  def self.transform(input)
    Board.new.transform(input)
  end

  def transform(input)
    validate(input)
    @matrix = strip_borders(input)

    each_matrix_position do |x, y, value|
      @matrix[x][y] = count_adjacent_mines(x, y) unless value == '*'
    end

    print_view
  end

  private

  def count_adjacent_mines(x, y)
    adjacent_positions(x, y)
      .map { |x, y| @matrix[x][y] }
      .count('*')
  end

  def adjacent_positions(x, y)
    offsets = [-1, 0, 1].repeated_permutation(2).to_a
    offsets.delete([0, 0])

    offsets
      .map { |off_x, off_y| [x + off_x, y + off_y] }
      .reject { |x, y| out_of_range(x, y) }
  end

  def out_of_range(x, y)
    x < 0 || y < 0 || x >= @matrix.size || y >= @matrix.first.size
  end

  def each_matrix_position
    @matrix.each_with_index do |row, i|
      row.each_with_index do |value, j|
        yield [i, j, value]
      end
    end
  end

  def strip_borders(input)
    input
      .map { |str| str.gsub(/\+|-|\|/, '') }
      .reject(&:empty?)
      .map(&:chars)
  end

  def print_view
    border = '+' + ('-' * @matrix.first.size) + '+'
    rows = @matrix.map { |row| ('|' + row.join + '|').gsub(/0/, ' ') }

    [border, rows, border].flatten
  end

  def validate(input)
    same_length = input.all? { |str| str.length == input.first.length }
    valid_strings = input.all? { |str| str.match(/(^\+-+\+$)|(^\|[ \*]+\|$)/) }

    fail(ArgumentError) unless same_length && valid_strings
  end
end

