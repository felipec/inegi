$ingresos = []
$ingresos_pc = []

open('ncv_concentrado_2014_concil_2010.csv').each_with_index do |l,i|
  next if i == 0
  cols = l.split(',')

  factor = cols[8].to_i
  integ = cols[13].to_i
  ingreso = cols[23].to_f

  # por hogar
  $ingresos << [ingreso, factor]

  # per capita
  $ingresos_pc << [ingreso / integ, factor * integ]
end
