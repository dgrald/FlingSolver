class State

  attr_reader :board, :move

  def initialize(board, move)
    @board = board
    @move = move
  end
end