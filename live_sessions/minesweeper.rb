ValueError = Class.new(StandardError)

class Board
  # replaces empty fields on the board with the number of adjacent mines
  def self.transform(board)
    self.new.transform(board)
  end

  def transform(board)
    @board = parse(validate(board))

    each_board_position do |x, y, value|
      @board[x][y] = count_adjacent_mines(x, y) unless value == '*'
    end

    pretty_format_board
  end

  private

  # returns the number of @board-fields next to [x, y] with '*'
  def count_adjacent_mines(x, y)
    adjacent_positions(x, y)
      .map { |i, j| @board[i][j] }
      .count('*')
  end

  # returns an array of [X, Y] positions, the @board-fields next to x and y
  def adjacent_positions(x, y)
    # list positions of neighbors relative to the current position
    neighbors = [-1, 0, 1].repeated_permutation(2).to_a
    neighbors.delete([0, 0])

    # compute absolute positions of neighbors on @board
    neighbors
      .map { |offset_x, offset_y| [x + offset_x, y + offset_y] }
      .reject { |i, j| out_of_range(i, j) }
  end

  # returns true if (X, Y) is NOT a valid index of @board
  def out_of_range(x, y)
    x < 0 || y < 0 || x >= @board.size || y >= @board.first.size
  end

  # yields every value on @board together with its x and y index
  def each_board_position
    @board.each_with_index do |row, i|
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
  def pretty_format_board
    border = '+' + ('-' * @board.first.size) + '+'
    rows = @board
           .map { |row| '|' + row.join + '|' }
           .map { |row| row.gsub(/0/, ' ') }

    [border, rows, border].flatten
  end
end
