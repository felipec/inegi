$ingresos = []
$ingresos_pc = []
$ingresos_trab_pc = []

# CPI: Ago-Nov 2018 -> Abr 2020
$deflator = (101.288 / 105.755) * 100

open('concentradohogar.csv').each_with_index do |l,i|
  next if i == 0
  cols = l.split(',')

  factor = cols[7].to_i
  integ = cols[12].to_i
  ingreso = cols[22].to_f

  ocupados = cols[19].to_i
  ingtrab = cols[23].to_i

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
