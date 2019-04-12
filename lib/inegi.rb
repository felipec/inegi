$ingresos = []
$ingresos_pc = []
$ingresos_trab_pc = []

open('concentradohogar.csv').each_with_index do |l,i|
  next if i == 0
  cols = l.split(',')

  factor = cols[8].to_i
  integ = cols[13].to_i
  ingreso = cols[23].to_f

  ocupados = cols[20].to_i
  ingtrab = cols[25].to_i

  # por hogar
  $ingresos << [ingreso, factor]

  # per capita
  $ingresos_pc << [ingreso / integ, factor * integ]

  # trabajo per capita
  $ingresos_trab_pc << [ingtrab / ocupados, factor * ocupados] unless ingtrab == 0 or ocupados == 0
end
