def csv(path, cols, converter = :itself)
  return enum_for(:csv, path, cols, converter) unless block_given?

  indexes = nil
  File.foreach(path, chomp: true).with_index do |line, i|
    row = line.split(',')
    if i == 0
      indexes = cols.map { |e| row.index(e) }
    else
      yield indexes.map { |e| row[e].public_send(converter) }
    end
  end
end
