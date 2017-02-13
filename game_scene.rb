class GameScene < Scene

  LEFT = Gosu::Button::KbLeft
  UP = Gosu::Button::KbUp
  DOWN = Gosu::Button::KbDown
  RIGHT = Gosu::Button::KbRight

  def initialize(window)
    @map = Map.new(window, './assets/map.yml')
    @player = Character.new(window, './assets/sprite.png')
  end

  def update(window)
    direction = ''
    direction = :left if window.button_down? LEFT
    direction = :right if window.button_down? RIGHT
    direction = :up if window.button_down? UP
    direction = :down if window.button_down? DOWN

    @player.update(direction, @map)
  end

  def draw(window)
    @player.draw(window.width / 2 / 16, window.height / 2 / 16)
    @map.draw(@player.x + 1, @player.y + 1)
  end
end
