class Move
  attr_reader :position, :value, :board

  def self.next_valid_move_for(position, board)
    return nil if board[position] == Puzzle::BOARD_SIZE

    next_value_move_range_start = (board[position] || 0) + 1

    novel_moves = (next_value_move_range_start..Puzzle::BOARD_SIZE).map do |value|
      Move.new(position, value, board)
    end

    novel_moves.detect(&:valid?)
  end

  def initialize(position, value, board)
    @position = position
    @value = value
    @board = board
  end

  def apply!
    board.rows[position.row][position.column] = value
  end

  def reset!
    board.rows[position.row][position.column] = nil
  end

  def valid?
    column_valid? && row_valid? && block_valid?
  end

  def column_valid?
    column_values = (0..(Puzzle::BOARD_SIZE - 1)).map do |column|
      column == position.column ? value : board[Position.new(position.row, column)]
    end

    values_cohort_valid?(column_values)
  end

  def row_valid?
    row_values = (0..(Puzzle::BOARD_SIZE - 1)).map do |row|
      row == position.row ? value : board[Position.new(row, position.column)]
    end

    values_cohort_valid?(row_values)
  end

  def block_valid?
    block_min_row = (position.row / 3) * 3
    block_min_column = (position.column / 3) * 3

    block_values = (block_min_row..(block_min_row + 2)).flat_map do |row|
      (block_min_column..(block_min_column + 2)).map do |column|
        if row == position.row && column == position.column
          value
        else
          board[Position.new(row, column)]
        end
      end
    end

    values_cohort_valid?(block_values)
  end

  def values_cohort_valid?(cohort)
    cohort.compact.tally.values.all? { |tally_value| tally_value <= 1 }
  end
end
