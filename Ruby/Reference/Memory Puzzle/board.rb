require_relative "./card.rb"

class Board
  attr_reader :board

  @@all_card_values = ("A".."Z").to_a

  def initialize(pairs)
    @pairs = pairs
    @board = Array.new(@pairs / 2) { Array.new(@pairs / 2) }
    self.populate
  end

  def [](position)
    @board[position[0] + 1][position[1] + 1]
  end

  def []=(position, value)
    @board[position[0] + 1][position[1] + 1] = value
  end

  def populate
    card_values = @@all_card_values.sample(@pairs)
    card_values = card_values.zip(card_values).flatten
    row_indexes = (0...(@pairs / 2)).to_a.shuffle
    col_indexes = (0...(@pairs / 2)).to_a.shuffle
    positions = []
    row_indexes.each do |r_idx|
      col_indexes.each do |c_idx|
        positions.push([r_idx, c_idx])
      end
    end
    positions.shuffle!
    i = 0
    while i < card_values.length
      @board[positions[i][0]][positions[i][1]] = Card.new(card_values[i], positions[i])
      i += 1
    end
  end

  def grid_helper
=begin
  Create a function that:
    Sees how big the grid is
    Makes the first row of the grid the spot indexes (0 and up)
    Makes the first spot on each row the row indexes
    Does so dynamically based on the grid size (pair numbers, maybe?)
=end
  end

  def print_board
    display = Array.new(@pairs / 2) { Array.new(@pairs / 2) }
    @board.each_with_index do |row, r_idx|
      row.each_with_index do |spot, s_idx|
        if spot.facing == "down"
          display[r_idx][s_idx] = " #{spot.face_value} "
        elsif spot.facing == "up"
          display[r_idx][s_idx] = "*#{spot.face_value}*"
        end
      end
    end
    return display
  end

end

temp = Board.new(8)
pos = [0, 1]
puts temp.print_board.map(&:join)
puts temp[pos].face_value
# puts temp.board
temp[pos].flip("up")
puts temp.print_board.map(&:join)