ValueError = Class.new(StandardError)

class Board
  # replaces empty fields on the board with the number of adjacent mines
  def self.transform(input)
    self.new.transform(input)
  end

  def transform(input)
    @matrix = parse(validate(input))

    each_matrix_position do |x, y, value|
      @matrix[x][y] = count_adjacent_mines(x, y) unless value == '*'
    end

    pretty_format_matrix
  end

  private

  # returns the number of @matrix-fields next to [x, y] with '*'
  def count_adjacent_mines(x, y)
    adjacent_positions(x, y)
      .map { |x, y| @matrix[x][y] }
      .count('*')
  end

  # returns an array of [X, Y] positions, the @matrix-fields next to x and y
  def adjacent_positions(x, y)
    # find positions of neighbors relative to the current position
    neighbors = [-1, 0, 1].repeated_permutation(2).to_a
    neighbors.delete([0, 0])

    # compute absolute positions of neighbors in @matrix
    neighbors
      .map { |offset_x, offset_y| [x + offset_x, y + offset_y] }
      .reject { |x, y| out_of_range(x, y) }
  end

  # returns true if (X, Y) is NOT a valid index of @matrix
  def out_of_range(x, y)
    x < 0 || y < 0 || x >= @matrix.size || y >= @matrix.first.size
  end

  # takes a block any yields every value in @matrix with its x and y index
  def each_matrix_position
    @matrix.each_with_index do |row, i|
      row.each_with_index do |value, j|
        yield [i, j, value]
      end
    end
  end

  # strips away borders and returns a 2-dim array of chars
  def parse(input)
    input
      .map { |str| str.gsub(/\+|-|\|/, '') }
      .reject(&:empty?)
      .map(&:chars)
  end

  # ensures each row has the same length and adheres to the specified format
  def validate(input)
    valid_lengths = input.all? { |str| str.length == input.first.length }
    valid_content = input.all? { |str| str.match(/(^\+-+\+$)|(^\|[ \*]+\|$)/) }

    fail(ValueError) unless valid_lengths && valid_content

    input
  end

  # returns an array of strings, each one a board-row, wrapped in borders
  def pretty_format_matrix
    border = '+' + ('-' * @matrix.first.size) + '+'
    rows = @matrix
      .map { |row| '|' + row.join + '|' }
      .map { |row| row.gsub(/0/, ' ') }

    [border, rows, border].flatten
  end
end

