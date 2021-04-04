class Puzzle
  include ActiveModel::Model
  attr_accessor :board

  BOARD_SIZE = 9

  def self.from_file(file)
    rows = file.each_line.map do |line|
      cells = line.split(' ')
      raise "invalid line: #{line}" unless cells.size == BOARD_SIZE
      cells.map do |cell|
        if cell == '0'
          nil
        else
          cell.to_i
        end
      end
    end
    raise "invalid file: #{file}" unless rows.size == BOARD_SIZE
    new(board: Board.new(rows))
  end

  def solve!
    moves = []

    while board.next_empty_cell_position.present?
      empty_cell_position = board.next_empty_cell_position
      valid_move_for_empty_cell_position = Move.next_valid_move_for(empty_cell_position, board)

      if valid_move_for_empty_cell_position.present?
        valid_move_for_empty_cell_position.apply!
        moves.push(valid_move_for_empty_cell_position)
      else
        reconsidered_move = moves.pop
        next_reconsidered_move = Move.next_valid_move_for(reconsidered_move.position, board)
        while next_reconsidered_move.nil?
          reconsidered_move.reset!
          reconsidered_move = moves.pop
          next_reconsidered_move = Move.next_valid_move_for(reconsidered_move.position, board)
        end
        next_reconsidered_move.apply!
        moves.push(next_reconsidered_move)
      end
    end
  end

  delegate :to_s, to: :board
end
