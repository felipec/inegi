def gen_probs(num, from=0, to=1)
  step = (to - from) / num.to_f
  (1..(num - 1)).map { |e| from + e * step }
end

DECILES = gen_probs(10)
TERCILES = gen_probs(3)
QUARTILES = gen_probs(4)

def wquantiles(data, probs)
  grouped = data.group_by(&:first).map { |a, b| [a, b.reduce(0) { |sum, e| sum + e.last }] }
  values, weights = grouped.sort_by(&:first).transpose

  cum = 0
  cum_weights = weights.map { |e| cum += e }

  sum = weights.reduce(:+)

  probs.map do |p|
    x = 1 + (sum - 1) * p
    mod = x % 1

    k1 = cum_weights.find_index { |e| e >= x.floor }
    k2 = cum_weights.find_index { |e| e >= x.ceil }

    (1 - mod) * values[k1] + (mod) * values[k2]
  end
end

def gini(data)
  sorted = data.sort_by(&:first)
  sum_values = 0
  sum_weights = 0

  # total acumulated value
  total = sorted.each_with_index.map do |(value, weight), i|
    sum_values += value * weight
    sum_weights += weight
    next_weight = i + 1 < sorted.size ? sorted[i + 1].last : 0
    sum_values * (weight + next_weight)
  end.reduce(&:+) / 2

  # normalized gini
  return 1 - 2 * (total / (sum_values.to_f * sum_weights.to_f))
end

def average_quantiles(data, probs)
  data = data.sort_by(&:first)

  total_weight = data.map(&:last).reduce(:+)

  if $inegi
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
