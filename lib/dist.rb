# Generates a list of probabilities.
#
# To generate quartiles (1/4, 2/4, 3/4):
#     gen_probs(4)
#
def gen_probs(num, from=0, to=1)
  step = (to - from) / num.to_f
  ((from + step)...to).step(step).to_a
end

DECILES = gen_probs(10)
TERCILES = gen_probs(3)
QUARTILES = gen_probs(4)

# Calculates weighted quantiles.
#
# The +data+ is a list of pairs of values and their corresponding weight:
#     [10, 4], [20, 3], [30, 2]
#
def wquantiles(data, probs=QUARTILES)
  grouped = data.group_by(&:first).map { |a, b| [a, b.reduce(0) { |sum, e| sum + e.last }] }
  values, weights = grouped.sort_by(&:first).transpose

  sum = 0
  cum_weights = weights.map { |e| sum += e }

  probs.map do |prob|
    h = 1 + (sum - 1) * prob
    mod = h % 1

    k1 = cum_weights.find_index { |e| e >= h.floor }
    k2 = cum_weights.find_index { |e| e >= h.ceil }

    (1 - mod) * values[k1] + (mod) * values[k2]
  end
end

# Calculates the Gini coefficient.
#
# The +data+ is a list of pairs of values and their corresponding weight:
#     [10, 4], [20, 3], [30, 2]
#
def gini(data)
  sorted = data.sort_by(&:first)
  sum_values = 0
  sum_weights = 0

  # total acumulated value
  total = sorted.each_with_index.map do |(value, weight), i|
    sum_values += value * weight
    sum_weights += weight
    next_weight = (i + 1 < sorted.size) ? sorted[i + 1].last : 0
    sum_values * (weight + next_weight)
  end.reduce(&:+) / 2

  # normalized gini
  return 1 - 2 * (total / (sum_values.to_f * sum_weights.to_f))
end

# Calculates means per group.
#
# The +data+ is a list of pairs of values and their corresponding weight:
#     [10, 4], [20, 3], [30, 2]
#
# This would generate _five_ means for _four_ quantiles.
#
def wmean_quantiles(data, probs=QUARTILES)
  data = data.sort_by(&:first)

  total_weight = data.map(&:last).reduce(:+)

  if $inegi
    # The INEGI splits the data by integers of the total size divided by ten.
    # If the total size is 109, the chunks would be: 10, 10, 10, 10, 10, 10, 10, 10, 10, 19
    quantile_size = total_weight / (probs.count + 1)
    cuts = (1..probs.count).map { |e| e * quantile_size }
  else
    cuts = probs.map { |p| total_weight * p }
  end

  cuts << total_weight

  quantiles = []
  sum = cut = cum_weight = 0

  data.each do |value, weight|
    cum_weight += weight

    if cum_weight >= cuts[cut]
      cur_cut = cuts[cut]
      prev_cut = cut > 0 ? cuts[cut - 1] : 0

      # chunk weight
      weight = cur_cut - (cum_weight - weight)

      quantiles[cut] = (sum + (value * weight)) / (cur_cut - prev_cut)

      # remaining weight
      weight = cum_weight - cur_cut

      sum = 0
      cut += 1
    end

    sum += value * weight
  end

  quantiles
end

def wmedian(data)
  wquantiles(data, [0.5])[0]
end

def wmean(data)
  wmean_quantiles(data, [])[0]
end
