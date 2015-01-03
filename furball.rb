class Furball
  include Comparable

  attr_accessor :x
  attr_accessor :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    Furball.new(self.x + other.x, self.y + other.y)
  end

  def -(other)
    Furball.new(self.x - other.x, self.y - other.y)
  end

  def *(factor)
    Furball.new(self.x * factor, self.y * factor)
  end

  def <=>(other)
    if self.x < other.x
      -1
    elsif self.x > other.x
        1
    else
      self.y <=> other.y
    end
  end

  def to_s
    "[#{@x}, #{@y}]"
  end

end

#ball = Furball.new(1,5)

#dumped = Marshal.dump(ball)

#ball2 = Marshal.load(dumped)
#p ball2