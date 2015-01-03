require_relative 'directions'
require_relative 'furball'
require_relative 'move'
require_relative 'state'

class Board

  attr_reader :board

  COLUMNS = 5
  ROWS = 5

  def initialize(board)
    unless board.is_a? Array
      raise ArgumentError, "Board must be an instance of an Array but was a #{board.class.to_s}"
    end
    @board = board
    @board.sort
  end

  def to_s
    returnString = ''
    for y in ROWS.downto(1)
      for x in 1.upto(COLUMNS)
        if board.include? Furball.new(x, y)
          returnString << "0"
        else
          returnString << "-"
        end
      end
      returnString << "\n"
    end
    returnString
  end

  def possibleMoves
    possibilities = []
    for furball in @board
      (possibilities << possibleMovesForBall(furball)).flatten!
    end
    possibilities
  end

  def possibleMovesForBall(ball)
    #get the possible horizontal moves
    possibilities = []
    row = getRow(ball.y)
    for otherBall in row
      if otherBall != ball
        #check left moves
        if isBallLeft?(ball, otherBall) && isValidHorizontalMove?(ball, otherBall, Directions::LEFT, row)
          possibilities << Move.new(ball, Directions::LEFT)
        end

        #check right moves
        if isBallRight?(ball, otherBall) && isValidHorizontalMove?(ball, otherBall, Directions::RIGHT, row)
          possibilities << Move.new(ball, Directions::RIGHT)
        end

      end
    end

    #get the possible vertical moves
    column = getColumn(ball.x)
    for otherBall in column
      if otherBall != ball
        #check up moves
        if isBallAbove?(ball, otherBall) && isValidVerticalMove?(ball, otherBall, Directions::UP, column)
          possibilities << Move.new(ball, Directions::UP)
        end

        #check down moves
        if isBallBelow?(ball, otherBall) && isValidVerticalMove?(ball, otherBall, Directions::DOWN, column)
          possibilities << Move.new(ball, Directions::DOWN)
        end
      end
    end

    possibilities

  end

  def isValidHorizontalMove?(ball, otherBall, direction, row)
    !isBallImmediatelyAdjacent?(ball, direction) && !isBallInRowInWay?(ball, otherBall, row)
  end

  def isValidVerticalMove?(ball, otherBall, direction, column)
    !isBallImmediatelyAdjacent?(ball, direction) && !isBallInColumnInWay?(ball, otherBall, column)
  end

  def isBallImmediatelyAdjacent?(ball, direction)
    @board.include?(ball + direction)
  end

  def isBallInRowInWay?(ball, otherBall, row)
    ordered = [ball, otherBall].sort
    row.select { |furball| furball > ordered[0] && furball < ordered[1] }.size > 0
  end

  def isBallInColumnInWay?(ball, otherBall, column)
    ordered = [ball, otherBall].sort
    column.select { |furball| furball > ordered[0] && furball < ordered[1] }.size > 0
  end

  def isBallLeft?(ball1, ball2)
    relativePosition = ball2 - ball1
    relativePosition.x < 0
  end

  def isBallRight?(ball1, ball2)
    relativePosition = ball2 - ball1
    relativePosition.x > 0
  end

  def isBallAbove?(ball1, ball2)
    relativePosition = ball2 - ball1
    relativePosition.y > 0
  end

  def isBallBelow?(ball1, ball2)
    relativePosition = ball2 - ball1
    relativePosition.y < 0
  end

  def isBallToHit?(ball, direction)
    if direction == Directions::DOWN || direction == Directions::UP
      isBallToHitInColumn?(ball, direction)
    elsif direction == Directions::LEFT || direction == Directions::RIGHT
      isBallToHitInRow?(ball, direction)
    else
      raise ArgumentError("The direction #{direction} is invalid")
    end
  end

  def isBallToHitInColumn?(ball, direction)
    column = getColumn(ball.x)
    for i in 1..COLUMNS
      if column.include?(ball + (direction*i))
        return true
      end
    end
    false
  end

  def isBallToHitInRow?(ball, direction)
    row = getRow(ball.y)
    for i in 1..ROWS
      if row.include?(ball + (direction*i))
        return true
      end
    end
    false
  end

  def getRow(y)
    row = []
    @board.each { |furball|
      if furball.y == y
        row << furball
      end
    }
    row.sort
  end

  def getColumn(x)
    column = []
    @board.each { |furball|
      if furball.x == x
        column << furball
      end
    }
    column.sort
  end

  def move(ball, direction)
    if @board.include?(ball)
      #first, we need to check if there's a ball immediately adjacent
      if !isBallImmediatelyAdjacent?(ball, direction)
        #next, we check that there's a ball to hit
        if isBallToHit?(ball, direction)
          #start moving the ball
          newBoard = @board.dup
          moveBallInMotion(ball, direction, newBoard)
        end
      end
    end
  end

  def moveBallInMotion(ball, direction, newBoard)
    newPosition = ball + direction
    if newBoard.include?(newPosition)
      #the ball has struck another ball, so move the other ball
      moveBallInMotion(newPosition, direction, newBoard)
    elsif isBallOffBoard?(newPosition)
      #the ball is off the board, so remove the ball from the board
      newBoard.delete(ball)
      return Board.new(newBoard)
    else
      #the ball has moved to an empty spot, so move the ball and do a recursive call
      newBoard.delete(ball)
      newBoard.push(newPosition)
      newBoard.sort
      moveBallInMotion(newPosition, direction, newBoard)
    end
  end

  def isBallOffBoard?(ball)
    if ball.x < 1 || ball.y < 1
      true
    elsif ball.x > COLUMNS || ball.y > ROWS
      true
    else
      false
    end

  end

  def ==(other)
    self.to_s == other.to_s
  end

end

