#!/usr/bin/env ruby

require 'test/unit'

require_relative '../lib/dist'
require_relative '../lib/inegi'

class WQuantilesTests < Test::Unit::TestCase

  def check(data, probs, expected)
    actual = wquantiles(data, probs)
    assert_equal(expected, actual.map { |e| e.round(6) })
  end

  def test_1
    data = [[10, 1], [20, 1]]
    probs = [0.5]
    expected = [15]
    check(data, probs, expected)
  end

  def test_2
    data = [[10, 10], [20, 10]]
    probs = [0.5]
    expected = [15]
    check(data, probs, expected)
  end

  def test_3
    data = [[10, 1], [20, 3]]
    probs = [0.5]
    expected = [20]
    check(data, probs, expected)
  end

  def test_4
    data = [[10, 3], [20, 1]]
    probs = [0.5]
    expected = [10]
    check(data, probs, expected)
  end

  def test_5
    data = [[10, 1], [20, 2]]
    probs = [0.25, 0.5, 0.75]
    expected = [15, 20, 20]
    check(data, probs, expected)
  end

  def test_6
    data = [[10, 1], [20, 1], [30, 1]]
    probs = [0.25, 0.5, 0.75]
    expected = [15, 20, 25]
    check(data, probs, expected)
  end

  def test_7
    data = [[10, 1], [20, 9]]
    probs = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
    expected = [19, 20, 20, 20, 20, 20, 20, 20, 20]
    check(data, probs, expected)
  end

  def test_8
    data = [[10, 1], [20, 99]]
    probs = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
    expected = [20, 20, 20, 20, 20, 20, 20, 20, 20]
    check(data, probs, expected)
  end

  def test_9
    data = [[20, 1], [10, 2], [10, 1]]
    probs = [0.5]
    expected = [10]
    check(data, probs, expected)
  end

  def test_10
    data = [[20, 2], [30, 3], [40, 4], [50, 1], [60, 2], [70, 3], [80, 4], [90, 1], [100, 2], [10, 2], [10, 1]]
    probs = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
    expected = [14, 28, 32, 40, 50, 64, 70, 80, 86]
    check(data, probs, expected)
  end

  def test_split_1
    data = [[10, 1], [20, 1]]
    probs = [0.7]
    expected = [17]
    check(data, probs, expected)
  end

  def test_split_2
    data = [[10, 10], [20, 10]]
    probs = [0.7]
    expected = [20]
    check(data, probs, expected)
  end

  def test_inegi
    probs = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
    expected = [11587.23, 16616.40, 21184.66, 26072.20, 31657.34, 38285.17, 47059.05, 60687.96, 87032.50]
    check($ingresos, probs, expected)
  end

end
