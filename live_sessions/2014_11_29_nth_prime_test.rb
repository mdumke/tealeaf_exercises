require 'minitest/autorun'
require_relative '2014_11_29_nth_prime'

class TestArray < MiniTest::Unit::TestCase
  def test_positive_numbers
    assert_equal false, [].number_in_sorted?(2)
    assert_equal false, [1].number_in_sorted?(2)
    assert_equal true, [2].number_in_sorted?(2)
    assert_equal true, [1, 2].number_in_sorted?(2)
    assert_equal true, [2, 2].number_in_sorted?(2)
    assert_equal true, [2, 3].number_in_sorted?(2)
    assert_equal false, [2, 3].number_in_sorted?(5)
    assert_equal false, [1, 6].number_in_sorted?(5)
    assert_equal true, [1, 5, 6].number_in_sorted?(5)
  end

  def test_negative_numbers
    assert_equal false, [1, 5, 6].number_in_sorted?(-5)
    assert_equal false, [-7, 5, 6].number_in_sorted?(-5)
    assert_equal true, [-7, -5, 6].number_in_sorted?(-5)
    assert_equal true, [-7, -5, -2, 6].number_in_sorted?(-5)
  end

  def test_big_array
    assert_equal true, [0, 1, 5].number_in_sorted?(5)
    assert_equal true, [*(-10..1000)].number_in_sorted?(997)
  end
end

class TestPrimes < MiniTest::Unit::TestCase
  def test_first
    assert_equal 2, Prime.nth(1)
  end

  def test_second
    assert_equal 3, Prime.nth(2)
  end

  def test_sixth
    assert_equal 13, Prime.nth(6)
  end

  def test_big_prime
    skip # takes about 4 minutes to compute
    assert_equal 104743, Prime.nth(10001)
  end

  def test_weird_case
    assert_raises ArgumentError do
      Prime.nth(0)
    end
  end
end

# test suite for the prime helper method
class PrimeTest < MiniTest::Unit::TestCase
  def test_deals_with_small_input
    assert_equal false, Prime.prime?(-1)
    assert_equal false, Prime.prime?(0)
    assert_equal false, Prime.prime?(1)
  end

  def test_recognizes_primes
    assert_equal true, Prime.prime?(2)
    assert_equal true, Prime.prime?(3)
    assert_equal true, Prime.prime?(5)
    assert_equal true, Prime.prime?(7)
    assert_equal true, Prime.prime?(11)
  end

  def test_recognizes_non_primes
    assert_equal false, Prime.prime?(4)
    assert_equal false, Prime.prime?(6)
    assert_equal false, Prime.prime?(20)
    assert_equal false, Prime.prime?(42)
  end

  def test_recognizes_big_prime
    assert_equal true, Prime.prime?(104743)
  end
end
