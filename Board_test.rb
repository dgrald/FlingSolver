require 'minitest/autorun'
require_relative 'board'
require_relative 'furball'
require_relative 'directions'
require_relative 'fling_solver'

class MyTest < MiniTest::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_ball_immediately_right
    b = Board.new([Furball.new(2, 2), Furball.new(1, 2)])
    assert_equal(true, b.isBallImmediatelyAdjacent?(Furball.new(1, 2), Directions::RIGHT), b.to_s)
  end

  def test_ball_left
    ball1 = Furball.new(2, 1)
    ball2 = Furball.new(4, 1)
    b = Board.new([ball1, ball2])
    assert_equal(true, b.isBallRight?(ball1, ball2), b.to_s)
  end

  def test_ball_right
    left = Furball.new(2, 1)
    right = Furball.new(4, 1)
    b = Board.new([left, right])
    assert_equal(true, b.isBallRight?(left, right), b.to_s)
  end

  def test_possible_moves
    ball1 = Furball.new(2, 1)
    ball2 = Furball.new(4, 1)
    b = Board.new([ball1, ball2])

    move1 = Move.new(ball1, Directions::RIGHT)
    move2 = Move.new(ball2, Directions::LEFT)

    possibleMoves = b.possibleMoves

    assert(possibleMoves.include?(move1))
    assert(possibleMoves.include?(move2))
    assert_equal(2, possibleMoves.size)
  end

  def test_possible_moves_ball_in_way
    ball1 = Furball.new(1, 1)
    ball2 = Furball.new(3, 1)
    ball3 = Furball.new(5, 1)

    b = Board.new([ball1, ball2, ball3])

    move1 = Move.new(ball1, Directions::RIGHT)
    move2 = Move.new(ball2, Directions::RIGHT)
    move3 = Move.new(ball2, Directions::LEFT)
    move4 = Move.new(ball3, Directions::LEFT)

    possibleMoves = b.possibleMoves

    assert(possibleMoves.include?(move1))
    assert(possibleMoves.include?(move2))
    assert(possibleMoves.include?(move3))
    assert(possibleMoves.include?(move4))
    assert_equal(4, possibleMoves.size, possibleMoves)
  end

  def test_possible_moves_vertical
    ball1 = Furball.new(1, 1)
    ball2 = Furball.new(1, 3)
    ball3 = Furball.new(1, 5)
    ball4 = Furball.new(3, 1)

    b = Board.new([ball1, ball2, ball3, ball4])

    possibleMoves = b.possibleMoves

    move1 = Move.new(ball1, Directions::UP)
    move2 = Move.new(ball4, Directions::LEFT)
    move3 = Move.new(ball1, Directions::RIGHT)
    move4 = Move.new(ball2, Directions::DOWN)
    move5 = Move.new(ball2, Directions::UP)
    move6 = Move.new(ball3, Directions::DOWN)

    assert(possibleMoves.include?(move1))
    assert(possibleMoves.include?(move2))
    assert(possibleMoves.include?(move3))
    assert(possibleMoves.include?(move4))
    assert(possibleMoves.include?(move5))
    assert(possibleMoves.include?(move6))
    assert_equal(6, possibleMoves.size)

  end

  def test_is_ball_in_row_in_way
    ball1 = Furball.new(1, 1)
    ball2 = Furball.new(3, 1)
    ball3 = Furball.new(5, 1)

    b = Board.new([ball1, ball2, ball3])

    assert(b.isBallInRowInWay?(ball1, ball3, b.getRow(ball1.y)))
  end

  def test_is_ball_horizontal_to_hit
    ball1 = Furball.new(1, 1)
    ball2 = Furball.new(3, 1)

    b = Board.new([ball1, ball2])

    puts b.to_s
    assert(b.isBallToHit?(ball1, Directions::RIGHT), b)

  end

  def test_move_ball
    ball1 = Furball.new(1, 1)
    ball2 = Furball.new(3, 1)

    b = Board.new([ball1, ball2])
    b.move(ball1, Directions::RIGHT)

    exp = Board.new([Furball.new(2, 1)])

    assert_equal(exp, b)

  end

  def test_move_ball_vertical
    ball1 = Furball.new(2, 1)
    ball2 = Furball.new(2, 3)
    ball3 = Furball.new(2, 4)

    b = Board.new([ball1, ball2, ball3])
    b.move(ball1, Directions::UP)

    exp = Board.new([Furball.new(2, 2), Furball.new(2, 3)])

    assert_equal(exp, b)

  end

  def test_solve1
    ball1 = Furball.new(1, 3)
    ball2 = Furball.new(1, 5)

    b = Board.new([ball1, ball2])
    solver = FlingSolver.new(b)
    solve = solver.solve

    assert_equal(1, solve.size)
  end

end