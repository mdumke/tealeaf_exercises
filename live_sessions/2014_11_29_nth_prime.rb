class Array
  # returns true if given number is in array
  # ASSUMES: array is sorted in ascending order
  def number_in_sorted?(number)
    number_in_sorted_helper(0, self.length, number)
  end

  private

  # recursive implementation of a bisection search
  def number_in_sorted_helper(lo, hi, number)
    middle = lo + (hi - lo) / 2

    # base cases
    return false if hi - lo <= 0
    return true if self[middle] == number

    # recursive step
    if self[middle] < number
      number_in_sorted_helper(middle + 1, hi, number)
    else
      number_in_sorted_helper(lo, middle, number)
    end
  end
end

class Prime
  @@primes = [2]

  def self.nth(n)
    raise ArgumentError if n < 1

    # quick check: has nth prime already been computed?
    return @@primes[n - 1] if @@primes.length >= n

    # otherwise, check by starting at the highest prime known
    start = @@primes[-1] + 1
    current_prime = @@primes.length

    start.upto(200000) do |i|
      if i % 10000 == 0
        puts "i = #{i}, last prime = #{@@primes[-1]}"
      end

      if prime?(i)
        current_prime += 1
        @@primes << i

        return i if current_prime == n
      end
    end

    puts "out of range"
  end

  # returns true if the given number is a prime number
  def self.prime?(number)
    return false if number <= 1

    # order of check matters
    #return true if @@primes.include?(number)
    return true if @@primes.number_in_sorted?(number)
    return false if number < @@primes[-1]

    (2...number).each do |i|
      return false if number % i == 0
    end

    true
  end
end
