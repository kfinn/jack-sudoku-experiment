class Board
  attr_reader :rows

  def initialize(rows)
    @rows = rows
  end

  def cells_with_positions
    Enumerator.new do |y|
      rows.each_with_index do |row, row_index|
        row.each_with_index do |cell, column_index|
          y << [cell, Position.new(row_index, column_index)]
        end
      end
    end
  end

  def next_empty_cell_position
    cells_with_positions.detect { |cell, position| cell.blank? }&.last
  end

  def any_empty_cell?
    next_empty_cell_position.present?
  end

  def [](position)
    rows[position.row][position.column]
  end

  def to_s
    rows_as_s = rows.map do |row|
      cells_as_s = row.map { |cell| cell.nil? ? '_' : cell.to_s }
      cells_as_s.join(' ')
    end
    rows_as_s.join("\n")
  end
end
