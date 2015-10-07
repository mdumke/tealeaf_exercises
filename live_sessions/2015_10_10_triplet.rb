class Triplet
  def self.where(options = {})
    fail(ArgumentError, ':max_factor missing') unless options[:max_factor]

    Triplet.new.where(options)
  end

  def initialize(a = nil, b = nil, c = nil)
    @a, @b, @c = [a, b, c]
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

  def where(options = {})
    min = options[:min_factor] || 1
    max = options[:max_factor]
  
    triplets = []
  
    permutations(min, max) do |a, b, c|
      t = Triplet.new(a, b, c)
      triplets << t if t.pythagorean?
    end

    triplets.select! { |t| t.sum == options[:sum] } if options[:sum]
    triplets
  end

  private

  def permutations(min, max)
    a = min
    
    while a < max
      b = a

      while b < max
        c = b

        while c <= max
          yield a, b, c

          c += 1
        end

        b += 1
      end
    
      a += 1
    end
  end
end
