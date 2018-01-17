require 'test/unit'

require_relative '../lib/dist'

class AverageQuantilesTests < Test::Unit::TestCase

  def check(data, probs, expected)
    actual = average_quantiles(data, probs)
    assert_equal(expected, actual.map { |e| e.round(6) })
  end

  def test_1
    data = [[10, 1], [20, 1]]
    probs = [0.5]
    expected = [10, 20]
    check(data, probs, expected)
  end

  def test_2
    data = [[10, 1], [20, 1], [20, 1], [30, 1]]
    probs = [0.5]
    expected = [15, 25]
    check(data, probs, expected)
  end

  def test_3
    data = [[10, 1], [20, 2], [30, 1]]
    probs = [0.5]
    expected = [15, 25]
    check(data, probs, expected)
  end

  def test_4
    data = [[10, 1], [10, 1], [10, 1]]
    probs = [0.5]
    expected = [10, 10]
    check(data, probs, expected)
  end

  def test_5
    data = [[20, 1], [20, 1], [50, 1]]
    probs = [0.5]
    expected = [20, 40]
    check(data, probs, expected)
  end

  def test_6
    data = [[10, 1], [20, 1], [30, 1], [40, 1]]
    probs = [0.25, 0.5, 0.75]
    expected = [10, 20, 30, 40]
    check(data, probs, expected)
  end

  def test_7
    data = [[10, 1], [18, 1], [20, 1], [26, 1], [30, 1], [34, 1], [40, 1], [42, 1]]
    probs = [0.25, 0.5, 0.75]
    expected = [14, 23, 32, 41]
    check(data, probs, expected)
  end

  def test_8
    data = [[20, 2], [30, 3], [40, 4], [50, 1], [60, 2], [70, 3], [80, 4], [90, 1], [100, 2], [10, 2], [10, 1]]
    probs = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
    expected = [10, 18, 30, 38, 42, 58, 70, 78, 82, 98]
    check(data, probs, expected)
  end

end
