class FlingSolver

  def initialize(initialBoard)
    @initialBoard = initialBoard
  end

  def solve
    #perform a depth-first search of the solution space
    stack = []
    stack.push(State.new(@initialBoard, nil))

    seenBoards = [@initialBoard]

    while !stack.empty?
      peek = stack.last
      possibilities = peek.board.possibleMoves
      previousBoard = peek.board
      for index in 0..possibilities.size
        move = possibilities[index]
        nextBoard = previousBoard.move(move.ball, move.direction)
        if !seenBoards.include?(nextBoard)
          seenBoards.push(nextBoard)
          if nextBoard.board.size == 1
            stack.push(State.new(nextBoard, move))
            return stack
          elsif !nextBoard.possibleMoves.empty?
            stack.push(State.new(nextBoard, move))
            break
          end
        end
        #this is the case where all of the options are exhausted
        if move == possibilities.last
          stack.pop
        end
      end

    end
  end
end