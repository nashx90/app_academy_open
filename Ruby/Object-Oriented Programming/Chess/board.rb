require_relative "piece_kit"

class Board
  attr_accessor :rows
  
  def initialize(original = true)
    @rows = Array.new (8) { Array.new (8) { NullPiece.instance } }
    @sentinel = NullPiece.instance
    @original = original
    populate_pieces
  end

  def [](position)
    @rows[position[0]][position[1]]
  end

  def []=(position, value)
    @rows[position[0]][position[1]] = value
  end

  def move_piece(color, start_pos, end_pos)
    piece_in_hand = self[start_pos]
    if @original == true
      if piece_in_hand.is_a?(NullPiece)
        raise "You can't move an empty square!"
      elsif piece_in_hand.color != color
        raise "You can only move a piece of your own color!"
      elsif !piece_in_hand.available_moves.include?(end_pos)
        raise "This is an invalid move!"
      elsif !piece_in_hand.valid_moves.include?(end_pos)
        raise "You need to move out of check!"
      end
    end
    self[start_pos], self[end_pos] = NullPiece.instance, self[start_pos]
    self[end_pos].position = end_pos
  end

  def valid_pos?(pos)
    if pos.any? { |coord| coord >= @rows.length || coord < 0 }
      return false
    end
    true
  end

  def clone
    cloned_board = Board.new(false)
    cloned_board.rows.each_with_index do |row, r_idx|
      row.each_with_index do |spot, s_idx|
        c_pos = [r_idx, s_idx]
        orig_piece = self[c_pos]
        c_class, c_color, c_position = orig_piece.class, orig_piece.color, orig_piece.position
        if c_class == NullPiece
          cloned_board[c_pos] = c_class.instance
        else
          cloned_board[c_pos] = c_class.new(c_color, cloned_board, c_position)
        end
      end
    end
    cloned_board
  end

  def in_check?(color)
    king = select_pieces(color).select { |piece| piece.class == King }.first
    if select_pieces.any? { |piece| piece.available_moves.include?(king.position) && piece.color != king.color }
      # puts "#{color.to_s.capitalize} is in check!" unless checkmate?(color)
      return true
    end
    false
  end

  def checkmate?(color)
    if in_check?(color)
      if select_pieces(color).all? { |piece| piece.valid_moves.empty? }
        return true
      end
    end
    false
  end

  private

  def populate_pieces
    @rows.each_with_index do |row, r_idx|
      if r_idx == 0
        row.each_index do |s_idx|
          position, color = [r_idx, s_idx], :black
          self[position] = Rook.new(color, self, position) if s_idx == 0 || s_idx == 7
          self[position] = Knight.new(color, self, position) if s_idx == 1 || s_idx == 6
          self[position] = Bishop.new(color, self, position) if s_idx == 2 || s_idx == 5
          self[position] = Queen.new(color, self, position) if s_idx == 3
          self[position] = King.new(color, self, position) if s_idx == 4
        end
      elsif r_idx == 1
        row.each_index do |s_idx|
          position, color = [r_idx, s_idx], :black
          self[position] = Pawn.new(color, self, position)
        end
      elsif r_idx == 6
        row.each_index do |s_idx|
          position, color = [r_idx, s_idx], :white
          self[position] = Pawn.new(color, self, position)
        end
      elsif r_idx == 7
        row.each_index do |s_idx|
          position, color = [r_idx, s_idx], :white
          self[position] = Rook.new(color, self, position) if s_idx == 0 || s_idx == 7
          self[position] = Knight.new(color, self, position) if s_idx == 1 || s_idx == 6
          self[position] = Bishop.new(color, self, position) if s_idx == 2 || s_idx == 5
          self[position] = Queen.new(color, self, position) if s_idx == 3
          self[position] = King.new(color, self, position) if s_idx == 4
        end
      end
    end
  end

  def select_pieces(color = :all)
    selection = []
    if color == :all
      rows.each do |row|
        row.each do |piece|
          selection << piece if piece.class != NullPiece
        end
      end
      return selection
    else
      rows.each do |row|
        row.each do |piece|
          selection << piece if piece.color == color
        end
      end
      return selection
    end
  end
  
  def select_all_pieces(color)
    selection = []
    rows.each do |row|
      row.each do |piece|
        selection << piece if piece.color == color
      end
    end
  end

end
