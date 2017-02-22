class MenuItem

  attr_reader :x, :y
  attr_writer :action

  def initialize(x, y, text, action=nil)
    @x = x
    @y = y
    @text = text
    @action = action || Proc.new {}
  end

  def draw(window)
    window.write(@x, @y, @text)
  end

  def run(window)
    @action.call(window)
  end
end