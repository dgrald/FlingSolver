require_relative 'directions'
require_relative 'furball'
class Move

  attr_reader :ball, :direction

  def initialize(ball, direction)
    @ball = ball
    @direction = direction
  end

  def to_s
    @ball.to_s << ": " << @direction.to_s
  end

  def ==(other)
    @ball == other.ball && @direction == other.direction
  end

end