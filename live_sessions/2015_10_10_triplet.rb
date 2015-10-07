class Triplet
  def self.where(options)
    result = []

    possible_triplets(options) do |triplet|
      next unless triplet.valid?(options)

      result << triplet
    end

    result
  end

  def self.possible_triplets(options)
    min = options[:min_factor] || 1
    max = options[:max_factor]

    min.upto(max - 1) do |a|
      a.upto(max - 1) do |b|
        b.upto(max) do |c|
          yield Triplet.new(a, b, c)
        end
      end
    end
  end

  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c
  end

  def sum
    @a + @b + @c
  end

  def product
    @a * @b * @c
  end

  def pythagorean?
    @a**2 + @b**2 == @c**2
  end

  def valid?(options)
    pythagorean? && (!options[:sum] || sum == options[:sum])
  end
end
