class GameMenuScene < Scene

  DOWN = Gosu::Button::KbDown
  UP = Gosu::Button::KbUp

  def initialize(window)
    @menu = Menu.new(window)
  end

  def update(window)
    direction = ''
    direction = :up if window.button_down? UP
    direction = :down if window.button_down? DOWN

    @menu.update(direction)
  end

  def draw(window)
    @menu.draw(window.width, window.height)
  end
end