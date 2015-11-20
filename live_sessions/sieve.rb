class Sieve
  attr_accessor :range, :cursor

  def initialize(limit)
    @range = [*(2..limit)]
  end

  def primes
    self.cursor = 0

    until cursor >= range.size
      delete_multiples
      update_cursor
    end

    range.compact
  end

  private

  def delete_multiples
    step_size = range[cursor]
    index = cursor + step_size

    while index < range.size
      range[index] = nil
      index += step_size
    end
  end

  def update_cursor
    while cursor < range.size
      self.cursor += 1
      return cursor unless range[cursor].nil?
    end
  end
end

