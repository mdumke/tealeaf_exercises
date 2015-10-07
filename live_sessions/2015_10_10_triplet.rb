class Triplet
  def self.where(options = {})
    triplets = []

    possible_values(options) do |a, b, c|
      triplet = Triplet.new(a, b, c)

      next unless triplet.pythagorean?
      next unless triplet.sum == options[:sum] if options[:sum]

      triplets << triplet
    end

    triplets
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

  def self.possible_values(options)
    min = options[:min_factor] || 1
    max = options[:max_factor]

    min.upto(max) do |a|
      a.upto(max) do |b|
        b.upto(max) do |c|
          yield a, b, c
        end
      end
    end
  end
end
