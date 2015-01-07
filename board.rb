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
    ROWS.downto(1).each { |y|
      1.upto(COLUMNS).each { |x|
        if board.include? Furball.new(x, y)
          returnString << '0'
        else
          returnString << '-'
        end
      }
      returnString << "\n"
    }
    returnString
  end

  def possible_moves
    possibilities = []
    @board.each { |furball|
      (possibilities << possible_moves_for_ball(furball)).flatten!
    }
    possibilities
  end

  def possible_moves_for_ball(ball)
    #get the possible horizontal moves
    possibilities = []
    row = row(ball.y)
    row.each { |otherBall|
      if otherBall != ball
        #check left moves
        if ball_left?(ball, otherBall) && valid_move?(ball, otherBall, Directions::LEFT, row)
          possibilities << Move.new(ball, Directions::LEFT)
        end

        #check right moves
        if ball_right?(ball, otherBall) && valid_move?(ball, otherBall, Directions::RIGHT, row)
          possibilities << Move.new(ball, Directions::RIGHT)
        end

      end
    }

    #get the possible vertical moves
    column = column(ball.x)
    column.each { |otherBall|
      if otherBall != ball
        #check up moves
        if ball_above?(ball, otherBall) && valid_move?(ball, otherBall, Directions::UP, column)
          possibilities << Move.new(ball, Directions::UP)
        end

        #check down moves
        if ball_below?(ball, otherBall) && valid_move?(ball, otherBall, Directions::DOWN, column)
          possibilities << Move.new(ball, Directions::DOWN)
        end
      end
    }

    possibilities

  end

  def valid_move?(ball, otherBall, direction, rowOrColumn)
    !ball_immediately_adjacent?(ball, direction) && !ball_in_row_or_column_in_way?(ball, otherBall, rowOrColumn)
  end

  def ball_immediately_adjacent?(ball, direction)
    @board.include?(ball + direction)
  end

# @param [Furball] ball
# @param [Furball] otherBall
# @param [Array[Furball]] rowOrColumn
  def ball_in_row_or_column_in_way?(ball, otherBall, rowOrColumn)
    ordered = [ball, otherBall].sort
    rowOrColumn.any? { |furball| furball > ordered[0] && furball < ordered[1] }
  end

  def ball_left?(ball1, ball2)
    relativePosition = ball2 - ball1
    relativePosition.x < 0
  end

  def ball_right?(ball1, ball2)
    relativePosition = ball2 - ball1
    relativePosition.x > 0
  end

  def ball_above?(ball1, ball2)
    relativePosition = ball2 - ball1
    relativePosition.y > 0
  end

  def ball_below?(ball1, ball2)
    relativePosition = ball2 - ball1
    relativePosition.y < 0
  end

  def is_ball_to_hit?(ball, direction)
    if direction == Directions::DOWN || direction == Directions::UP
      ball_to_hit_in_dimension?(ball, direction, column(ball.x), 1..COLUMNS)
    elsif direction == Directions::LEFT || direction == Directions::RIGHT
      ball_to_hit_in_dimension?(ball, direction, row(ball.y), 1..ROWS)
    else
      raise ArgumentError("The direction #{direction} is invalid")
    end
  end

  def ball_to_hit_in_dimension?(ball, direction, dimension, range)
    range.each { |num|
      if dimension.include?(ball + (direction * num))
        return true
      end
    }
  end

  def row(y)
    row = []
    @board.each { |furball|
      if furball.y == y
        row << furball
      end
    }
    row.sort
  end

  def column(x)
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
      if !ball_immediately_adjacent?(ball, direction)
        #next, we check that there's a ball to hit
        if is_ball_to_hit?(ball, direction)
          #start moving the ball, which is handled by the moveBallInMotion method
          newBoard = @board.dup
          move_ball_in_motion(ball, direction, newBoard)
        end
      end
    end
  end

  def move_ball_in_motion(ball, direction, newBoard)
    newPosition = ball + direction
    if newBoard.include?(newPosition)
      #the ball has struck another ball, so move the other ball
      move_ball_in_motion(newPosition, direction, newBoard)
    elsif ball_off_board?(newPosition)
      #the ball is off the board, so remove the ball from the board
      newBoard.delete(ball)
      return Board.new(newBoard)
    else
      #the ball has moved to an empty spot, so move the ball and do a recursive call
      newBoard.delete(ball)
      newBoard.push(newPosition)
      newBoard.sort
      move_ball_in_motion(newPosition, direction, newBoard)
    end
  end

  def ball_off_board?(ball)
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

