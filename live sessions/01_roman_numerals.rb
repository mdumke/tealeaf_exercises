# extends the Fixnum class to convert an arabic number to a roman numeral
class Fixnum
  def to_roman
    thousands + hundreds + tens + ones
  end

  private

  def thousands
    'M' * (self / 1000)
  end

  def hundreds
    ([''] + %w(C CC CCC CD D DC DCC DCCC CM))[self % 1000 / 100]
  end

  def tens
    ([''] + %w(X XX XX XL L LX LXX LXXX CX))[self % 100 / 10]
  end

  def ones
    ([''] + %w(I II III IV V VI VII VIII IX))[self % 10]
  end
end
