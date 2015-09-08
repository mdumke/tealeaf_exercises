NUMERAL_SYMBOLS = {
  1 => %w(I V X),
  10 => %w(X L C),
  100 => %w(C D M)
}

# extends the Fixnum class to convert an arabic number to a roman numeral
class Fixnum
  def to_roman
    thousands + places(100) + places(10) + places(1)
  end

  private

  def thousands
    'M' * (self / 1000)
  end

  # returns a numeral string for the given place
  def places(place)
    ([''] + %w(a aa aaa ab b ba baa baaa ac))[self / place % 10]
      .gsub(/a/, NUMERAL_SYMBOLS[place][0])
      .gsub(/b/, NUMERAL_SYMBOLS[place][1])
      .gsub(/c/, NUMERAL_SYMBOLS[place][2])
  end
end
