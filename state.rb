class State
  def initialize(window)
    @window = window
  end

  def update(window, direction)
  end

  def draw(window)
  end

  def button_down(window, id)
  end

  def button_up(window, id)
  end

  protected

  attr_reader :window
end
