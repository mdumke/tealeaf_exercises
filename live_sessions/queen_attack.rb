class Queens
  attr_accessor :white, :black

  def initialize(white: [0, 3], black: [7, 3])
    fail(ArgumentError, 'Cannot occupy same field') if white == black

    @white = white
    @black = black
  end

  def attack?
    row_attack? || column_attack? || diagonal_attack?
  end

  def to_s
    board = Array.new(8) { Array.new(8, '_') }

    board[white[0]][white[1]] = 'W'
    board[black[0]][black[1]] = 'B'

    board.map { |row| row.join(' ') }.join("\n")
  end

  private

  def row_attack?
    white[1] == black[1]
  end

  def column_attack?
    white[0] == black[0]
  end

  def diagonal_attack?
    (white[0] - black[0]).abs == (white[1] - black[1]).abs
  end
end
