class Series
  attr_reader :series

  def initialize(series)
    @series = series.chars.map(&:to_i)
  end

  def slices(slice_size)
    validate_input(slice_size)

    0.upto(series.size - slice_size)
     .map { |position| series.slice(position, slice_size) }
  end

  private

  def validate_input(size)
    fail(ArgumentError, 'too big') if size > series.size
  end
end

