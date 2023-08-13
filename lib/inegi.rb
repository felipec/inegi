require_relative 'csv'

$ingresos = []
$ingresos_pc = []
$ingresos_trab_pc = []

# CPI: Aug-Nov 2020 -> Jul 2023
$deflator = (108.403 / 128.832) * 100

csv('concentradohogar.csv', %w[ing_cor factor tot_integ ocupados ingtrab]) do |e|
  _, factor, integ, ocupados, ingtrab = e.map(&:to_i)
  ingreso = e.first.to_f

  # por año ajustado
  ingreso = ingreso * 4 * 100 / $deflator
  ingtrab = ingtrab * 4 * 100 / $deflator

  # por hogar
  $ingresos << [ingreso, factor]

  # per capita
  $ingresos_pc << [ingreso / integ, factor * integ]

  # trabajo per capita
  $ingresos_trab_pc << [ingtrab / ocupados, factor * ocupados] unless ingtrab == 0 or ocupados == 0
end
