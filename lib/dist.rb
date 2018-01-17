def gen_probs(num, from=0, to=1)
  step = (to - from) / num.to_f
  (1..(num - 1)).map { |e| from + e * step }
end

def average_quantiles(data, probs)
  data = data.sort_by(&:first)

  total_weight = data.map(&:last).reduce(:+)

  cuts = probs.map { |p| total_weight * p }
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
