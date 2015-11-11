class Series
  def initialize(series)
    @series = series.chars.map(&:to_i)
  end

  def slices(length)
    fail(ArgumentError, 'input is too big') if length > @series.size
    0.upto(@series.size - length).map { |idx| @series.slice(idx, length) }
  end
end

