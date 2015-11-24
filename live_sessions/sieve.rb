class Sieve
  def initialize(limit)
    @numbers = [*(2..limit)]
  end

  def primes
    primes = []

    while (prime = @numbers.delete_at(0))
      primes << prime
      @numbers.delete_if { |number| number % prime == 0 }
    end

    primes
  end
end

